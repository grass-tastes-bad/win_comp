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
function Enumerate-Devices {
    
    gwmi Win32_USBControllerDevice |%{[wmi]($_.Dependent)} | Sort Manufacturer,Description,DeviceID | Ft -GroupBy Manufacturer Description,Service,DeviceID

}
