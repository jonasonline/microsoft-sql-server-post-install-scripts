[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$SQLServerInstanceName,
	
   [Parameter(Mandatory=$false)]
   [string]$InputFolder,

   [Parameter(Mandatory=$True)]
   [string]$OperatorEmail,

   [Parameter(Mandatory=$True)]
   [string]$MailServer
)

if ($InputFolder -eq $null -or $InputFolder -eq "") {
    $InputFolder = "Templates"
}

if ($OutputFolder -eq $null -or $OutputFolder -eq "") {
    $OutputFolder = "Scripts"
}

if ((Test-Path -Path $OutputFolder) -eq $false) {
    mkdir $OutputFolder 
}

$olaHallengrenScriptPath = "https://ola.hallengren.com/scripts/MaintenanceSolution.sql"
$olaHallengrenScriptFileName = "Scripts\026.InstallOlaHallengrenMaintenanceSolution.sql"
Invoke-WebRequest -Uri $olaHallengrenScriptPath -OutFile $olaHallengrenScriptFileName
(Get-Content -Path $olaHallengrenScriptFileName).replace('USE [master]', 'USE [MaintenanceDB]') | Set-Content $olaHallengrenScriptFileName -Force
Copy-Item $($InputFolder + "\*") -Filter "*.sql" -Destination $OutputFolder
Get-ChildItem -Path $OutputFolder -Filter "*.sql" | ForEach-Object {(Get-Content -Path $($OutputFolder + "\" + $_.Name)).Replace("{{email}}", $OperatorEmail) | Set-Content -Path $($OutputFolder + "\" + $_.Name) -Force}
Get-ChildItem -Path $OutputFolder -Filter "*.sql" | ForEach-Object {(Get-Content -Path $($OutputFolder + "\" + $_.Name)).Replace("{{mailserver}}", $MailServer) | Set-Content -Path $($OutputFolder + "\" + $_.Name) -Force}

if ($(Read-Host -Prompt "Do you want to continue the installation? (Y/N)") -ne "Y") {
    exit
}

if ($(Get-Command -Name "SQLPS\Invoke-Sqlcmd" -ErrorAction SilentlyContinue) -eq $null) {
    Write-Error "SQL Server Powershell module not installed"
    exit
}

if ($SQLServerInstanceName -eq $null) {
    $SQLServerInstanceName = Read-Host -Prompt "Enter SQL Server instance name"
}

Get-ChildItem $OutputFolder -Filter *.sql | Sort-Object -property Name | ForEach-Object{ Write-Host $_.Name; Invoke-Sqlcmd -InputFile $_.FullName -ServerInstance $SQLServerInstanceName -Verbose -DisableVariables}
