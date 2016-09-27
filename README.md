# microsoft-sql-server-post-install-scripts
Some useful scripts to run on a SQL Server post installation.

## Description
The Templates folder includes scripts to be executed in order. Some scripts are downloaded during execution. 
The scripts are copied to the output folder which by default is the Scripts folder.
To run additional scripts, just add them to the Scripts folder prior to execution.

## Usage

    .\Setup.ps1 -SQLServerInstanceName "." -OperatorEmail "receiver@yourdomain.com" -MailServer "smtp.yourdomain.com"