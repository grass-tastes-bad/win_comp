#########################################################################
#			Author:Vikas Sukhija(http://msexchange.me)
#			Reviewer:
#			Date: 12/17/2015
#			Desc: Backup & Restore Permissions
#			Refrence: File System Security PowerShell Module 4.0.1
#			Thanks Raimund Andrée for creating the Module
#########################################################################
########################Import NTFS Module###############################

$date = get-date -format d
$date = $date.ToString().Replace(“/”, “-”)
$time = get-date -format t

$time = $time.ToString().Replace(":", "-")
$time = $time.ToString().Replace(" ", "")

$logs = ".\logs\" + "backup" + "_" + $date  + "_" + $time + "_.log"

$bkpfolder = ".\backup\" + "backup" + "_" + $date  + "_" + $time

if(!(Test-path $bkpfolder)){new-item -path $bkpfolder -type directory}


Import-Module .\NTFSSecurity\NTFSSecurity.psd1

if($error) {write-host "Module not imported-- Script will exit" -foregroundcolor yellow}

start-transcript $logs

########################Create Permissions Dump#######################

$getftbkp = gc .\folderstobackup.txt

$getftbkp | foreach-object{

$fb = $_
$fb = $fb.split("\")

Write-host "Processing .........$_" -foregroundcolor green

$csv = $bkpfolder + "\" + $fb[2] + "_" + $fb[-1] + "_.csv"
get-childitem $_ -recurse  | get-ntfsaccess -excludeinherited | export-csv $csv

}

stop-transcript
###########################################################################

