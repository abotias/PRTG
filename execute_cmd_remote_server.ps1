#$ErrorActionPreference= 'silentlycontinue'

param(
    [Parameter(Mandatory=$true)][string]$user,
    [Parameter(Mandatory=$true)][string]$password,
    [Parameter(Mandatory=$true)][string]$ip
)

$comandos = "C:\Program Files (x86)\PRTG Network Monitor\Custom Sensors\EXEXML\cmd.ps1"
# $info = Import-CSV "C:\Program Files (x86)\PRTG Network Monitor\Custom Sensors\EXEXML\credentials.csv"

# $user = %windowsdomain + "\" + %windowsuser
# $ip = '%host'
$securepass = ConvertTo-SecureString -String $password -AsPlainText -Force 
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user,$securepass
$mysession = New-PSSession -ComputerName $ip -Credential $cred

Invoke-Command -Session $mysession -Filepath $comandos

Remove-PSSession $mysession
