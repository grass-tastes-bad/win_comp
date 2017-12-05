function Get-NetworkAdapters
{
	<#
	.SYNOPSIS
		
		Gets a machine's network adapters and each adapter's basic network configuration.

	.DESCRIPTION
		
		Uses the `win32_service` WMI object to get network adapters and their IP addresses, MAC address, gateway, description, and enabled state.

	.EXAMPLE
        
		Get-NetworkAdapters       
	#>

	Get-WmiObject win32_networkadapterconfiguration | ?{$_.IPAddress -ne $null} | select IPAddress, MacAddress, DefaultIPGateway, Description, IPEnabled
}