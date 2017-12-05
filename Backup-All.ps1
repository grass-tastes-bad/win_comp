#REQUIRES -Version 2.0

<#
.SYNOPSIS
    This function will create a backup of all important directories and files on a 
    windows server and store it in a specified location
.DESCRIPTION
    The script makes use of several backup cmdlets that already exist to automate
    the process.
.NOTES
    File Name      : Backup-All.ps1
    Author         : Carson Sallis
    Prerequisite   : PowerShell V2 over Vista and upper.
.EXAMPLE
    Add examples later
#>
function Backup-All {

#Create backup folders
md C:\Backups
md C:\Backups\GPO
md C:\Backups\Registry
md C:\Backups\ACLs
md C:\Backups\ImportantFolders
md C:\Backups\inis
md C:\Backups\hostfile
md C:\Backups\dlls

#Backup GPO
Backup-GPO -Path C:\Backups [-All] 
                                                 
#Backup Registry
Get-ChildItem HKCU:\SOFTWARE\$app -recurse | Export-CliXML "\\server\Users\$Profile\out.reg"

#Backup ACLs
#Seems to be more difficult than expected. Found a large powershell script that may work
#https://gallery.technet.microsoft.com/scriptcenter/Backup-and-Restore-4bae5a26

#Backup Folders
#important folders?
md C:\Backups\ImportantFolders\System32
Copy-Item C:\Windows\System32\* C:\Backups\ImportantFolders\System32

#Backup ini
#Which ini? Boot.ini? What else? system.ini/win.ini
Copy-Item C:\Windows\system.ini C:\Backups\inis
Copy-Item C:\Windows\system.ini C:\Backups\inis

#Backup hostsfile. Similar to linux hosts file
Copy-Item C:\Windows\System32\Drivers\etc\hosts C:\Backups\hostfile

#Backup dll's
Copy-Item C:\Windows\System32\Drivers\Kernel32.dll C:\Backups\hostfile\dlls
Copy-Item C:\Windows\System32\Drivers\Ntdll.dll C:\Backups\hostfile\dlls
Copy-Item C:\Windows\System32\Drivers\user32.dll C:\Backups\hostfile\dlls
Copy-Item C:\Windows\System32\Drivers\hal.dll C:\Backups\hostfile\dlls

}
