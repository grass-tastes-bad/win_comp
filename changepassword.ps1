function Invoke-ChangePassword
{
	<#
	.SYNOPSIS

		Changes passwords based on the password matrix

	.DESCRIPTION

		Changes the password for the current domain by using Get-ADDomain to get the current domain and all accounts tied to it.

	.PARAMETER Matrix
		
		Flattened, comma delimited matrix of passwords

	.EXAMPLE
		
		Invoke-ChangePassword -Matrix password,abc123,cat,dog,gecko,fish,donky,cow,pig
	#>
	Param
	(
		[Object[]]$Matrix
	)

    function locationConvert
    {
	    Param
	    (
		    [Parameter(Mandatory=$True, Position=0)]
		    [int]$Row,

		    [Parameter(Mandatory=$True, Position=1)]
		    [int]$Column
	    )
	
	    $alphabet = @("A", "B", "C")
	    return @($alphabet[$Row], ($Column+1))
    }

	If ($Matrix.Length -ne 9) {
		Write-Error "You must supply 9 passwords"
		return
	}

	$tableObject = @()

	# Get Initial users
    $domainUsers = Get-ADUser -Ldapfilter "(!(sAMAccountName=krbtgt))" -Searchscope Subtree -SearchBase (Get-ADDomain).DistinguishedName

    # Change current domain password
	foreach ($user in $domainUsers) {
        # Create new pasword
	    $newPassword = ""
	    $newPasswordLocation = @()
	    For ($i = 0; $i -lt 3; $i++) {
	        $location = Get-Random $Matrix.Length
	        $newPassword += $Matrix[$location]
            $row = [Math]::Truncate($location/3)
	        $column = $location-($row*3)
	        $encodedPassword = locationConvert $row $column
	        $newPasswordLocation += $encodedPassword[0] + $encodedPassword[1]
	    }

        try {
            Set-ADAccountPassword -Identity $user.Name -NewPassword (ConvertTo-SecureString -AsPlainText "$NewPassword" -Force) -Reset
        } catch {
            Write-Error $_.Exception.Message
            continue
        }
        # Create table
	    $tableObject += @{Username=$user.Name;Password=$newPasswordLocation}  | % { New-Object object | Add-Member -NotePropertyMembers $_ -PassThru }
    }


    # Set the password


	$tableObject | Format-Table Username,Password
}
