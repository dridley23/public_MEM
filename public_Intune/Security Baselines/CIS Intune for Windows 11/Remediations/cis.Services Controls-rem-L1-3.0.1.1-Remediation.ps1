<#
.PURPOSE			Remediation
.GUID				9517bcb8-9964-435c-9996-41a080a5c56f
.SYNOPSIS			Configures Windows 11 Services as per CIS Microsoft Intune for Windows 11 Benchmark (LEVEL 1)
.DESCRIPTION		L1/69.3
					L1/69.6
					L1/69.7
					L1/69.8
					L1/69.10
					L1/69.11
					L1/69.13
					L1/69.24
					L1/69.26
					L1/69.28
					L1/69.30
					L1/69.31
					L1/69.32
					L1/69.33
					L1/69.36
					L1/69.37
					L1/69.41
					L1/69.42
					L1/69.43
					L1/69.44
					L1/69.45
.FILENAME			cis.Services Controls-rem-L1-3.0.1.1-Remediation.ps1
.VERSION HISTORY	v1.0 | 20250409 17:12:49	[D.Ridley]		Initial creation
#>


Function Sys-Services-L1 {
	@(
		'Browser'				# 69.3  - Computer Browser
		'IISADMIN'				# 69.6  - IIS Admin Service
		'irmon'					# 69.7  - Infrared monitor service
		'SharedAccess'			# 69.8  - Internet Connection Sharing (ICS)
		'LxssManager'			# 69.1  - LxssManager
		'FTPSVC'				# 69.11 - Microsoft FTP Service
		'sshd'					# 69.13 - OpenSSH SSH Server
		'RpcLocator'			# 69.24 - Remote Procedure Call (RPC) Locator
		'RemoteAccess'			# 69.26 - Routing and Remote Access
		'simptcp'				# 69.28 - Simple TCP/IP Services
		'sacsvr'				# 69.3  - Special Administration Console Helper
		'SSDPSRV'				# 69.31 - SSDP Discovery
		'upnphost'				# 69.32 - UPnP Device Host
		'WMSvc'					# 69.33 - Web Management Service
		'WMPNetworkSvc'			# 69.36 - Windows Media Player Network Sharing Service
		'icssvc'				# 69.37 - Windows Mobile Hotspot Service
		'W3SVC'					# 69.41 - World Wide Web Publishing Service
		'XboxGipSvc'			# 69.42 - Xbox Accessory Management Service
		'XblAuthManager'		# 69.43 - Xbox Live Auth Manager
		'XblGameSave'			# 69.44 - Xbox Live Game Save
		'XboxNetApiSvc'			# 69.45 - Xbox Live Networking Service
	) | ForEach { 
			If ( Get-Service $_ -ErrorAction SilentlyContinue ) {
				Get-Service $_ | Stop-Service -Force -Verbose
				Get-Service $_ | Set-Service -StartupType Disabled -Verbose 
			}
		}
}


## :: Disable Services on device
Sys-Services-L1
