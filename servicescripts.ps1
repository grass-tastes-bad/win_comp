#region Services
	function Get-DefaultServices
	{
		<#
		.SYNOPSIS
		
			Gets default services so that the hardener can figure out what needs to be stopped/disabled

		.DESCRIPTION
		
			Uses the `win32_service` WMI object to get service names and paths. You have the ability to use this command with the `-Not` attribute to get non-default services
	
		.PARAMETER Not
		
			Gets Non-default services in the same fashion as without the `-Not` parameter

 		.EXAMPLE
        
 		       Get-DefaultServices -Not        
		#>
	
		Param
		(
			[switch] $Not
		)

		$defaultServices = @("AppInfo", "AudioEndpointBuilder", "Audiosrv", "BFE", "BITS", "BrokerInfrastructure", "CertPropSvc", "CoreMessagingRegistrar", "CryptSvc", "DeviceAssociationService", "Dhcp", "DiagTrack", "Dnscache", "SecurityHealthServMpsSvc", "DoSvc", "DPS", "TimeBrokerSvc", "ProfSvc", "Winmgmt", "EventLog", "LicenseManager", "EventSystem", "wuauserv", "WpnService", "Wcmsvc", "FontCache", "WSearch", "stisvc", "WinDefend", "FontCache", "CDPSvc", "WdNisSvc", "tiledatamodelsvc", "lmhosts", "WdiSest", "TrkWks", "Schedule", "UserManager", "lfsvc", "gpsvc", "StorSvc", "SystemEventsBroker", "hidserv", "iphlpsvc", "LSM", "SysMain", "netprofm", "NcbService", "NlaSvc", "nsi", "SENS", "PlugPlay", "ShellHWDetection", "Power", "StateRepository", "PcaSvc", "RpcSs", "Spooler", "SessionEnv", "SSDPSRV", "wscsvc", "LanmanServer", "TermService", "UmRdpService", "WlanSvc", "WinHttpAutoProxySvc", "DcomLaunch", "DusmSvc", "KeyIso", "LanmanWorkstation", "QWAVE", "RpcEptMapper", "VaultSvc", "AppXSvc", "ClipSVC", "COMSysApp", "dmwappushsvc", "SamSs", "sppsvc", "TrustedInstaller", "WerSvc", "wlidsvc")

		$allServices = Get-WmiObject win32_service

		if ($PSBoundParameters.ContainsKey("Not")) {
			# Filter all services to get non-default services
			$allServices = $allServices | ?{ $defaultServices -notcontains $_.Name } 
		} else {
			# Filter all services to get default services
			$allServices = $allServices | ?{ $defaultServices -contains $_.Name } 
		}

		# Display the names and paths of all filtered running services
		$allServices | ?{ $_.State -eq "Running" } | select Name, DisplayName, PathName | Format-Table -AutoSize

	}	

	function Get-ServiceRecommendations
	{
		<#
		.SYNOPSIS
		
			Gets recommendations for stopping currently-running services based on Microsoft's recommendations.

		.DESCRIPTION
		
			Uses the `win32_service` WMI object to get service names and paths, then compares running services to categories based on Microsoft's service recommendations.
	    .EXAMPLE
        
        	Get-ServiceRecommendations        
		#>

		# Lists of default services by Microsoft's security recommendations

		$shouldDisable = @("XblAuthManager", "XblGameSave")

		$disabledByDefault = @("tzautoupdate", "Browser", "AppVClient", "NetTcpPortSharing", "CscService", "RemoteAccess", "SCardSvr", "UevAgentService", "WSearch")

		$okToDisable = @("CDPUserSvc", "PimIndexMaintenanceSvc", "dmwappushservice", "MapsBroker", "lfsvc", "SharedAccess", "lltdsvc", "wlidsvc", "NgcSvc", "NgcCtnrSvc", "NcbService", "PhoneSvc", "PcaSvc", "QWAVE", "RmSvc", "SensorDataService", "SensrSvc", "SensorService", "ShellHWDetection", "ScDeviceEnum", "SSDPSRV", "WiaRpc", "OneSyncSvc", "TabletInputService", "upnphost", "UserDataSvc", "UnistoreSvc", "WalletService", "Audiosrv", "AudioEndpointBuilder", "FrameServer", "stisvc", "wisvc", "icssvc", "WpnService", "WpnUserService")

		$okToDisableIfNotPrintOrDC = @("PrintNotify", "Spooler")

		$runningServices = Get-WmiObject win32_service | ?{$_.State -eq "Running"}
	
		# List all running services by Microsoft's security recommendations

		if($runningServices | ?{$shouldDisable -contains $_.Name})
		{
			$Host.UI.RawUI.ForegroundColor = "yellow"
			Write-Host "Should disable:"
			$Host.UI.RawUI.ForegroundColor = "white"
			$runningServices | ?{$shouldDisable -contains $_.Name} | Format-Table -AutoSize -Property Name, DisplayName, PathName
		}
	
		if($runningServices | ?{$disabledByDefault -contains $_.Name})
		{
			$Host.UI.RawUI.ForegroundColor = "yellow"
			Write-Host "Disabled by default:"
			$Host.UI.RawUI.ForegroundColor = "white"
			$runningServices | ?{$disabledByDefault -contains $_.Name} | Format-Table -AutoSize -Property Name, DisplayName, PathName
		}
	
		if($runningServices | ?{$okToDisable -contains $_.Name})
		{
			$Host.UI.RawUI.ForegroundColor = "yellow"
			Write-Host "OK to disable:"
			$Host.UI.RawUI.ForegroundColor = "white"
			$runningServices | ?{$okToDisable -contains $_.Name} | Format-Table -AutoSize -Property Name, DisplayName, PathName
		}
	
		if($runningServices | ?{$okToDisableIfNotPrintOrDC -contains $_.Name})
		{
			$Host.UI.RawUI.ForegroundColor = "yellow"
			Write-Host "OK to disable if not print server or DC:"
			$Host.UI.RawUI.ForegroundColor = "white"
			$runningServices | ?{$okToDisableIfNotPrintOrDC -contains $_.Name} | Format-Table -AutoSize -Property Name, DisplayName, PathName
		}
	}
#endregion Services