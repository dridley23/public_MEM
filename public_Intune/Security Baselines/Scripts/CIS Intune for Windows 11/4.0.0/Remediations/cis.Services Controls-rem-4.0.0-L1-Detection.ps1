<#
.PURPOSE			Detection
.GUID				c420015c-da91-475c-9096-89f57804e949
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
.FILENAME			cis.Services Controls-rem-4.0.0-L1-Detection.ps1
.VERSION HISTORY	v1.0 | 20250429 20:04:51	[D.Ridley]		Initial creation
#>


$ErrorActionPreference = "Stop"

Function Sys-Services-L1 {
	Try {
		@(
			'Browser'				# 69.3  - Computer Browser
			'IISADMIN'				# 69.6  - IIS Admin Service
			'irmon'					# 69.7  - Infrared monitor service
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
				If ( Get-Service $_ -ErrorAction SilentlyContinue) {
					If ( (Get-Service $_).StartType -ne 'Disabled' ) { Throw "Service: $_ not set to Disabled" } 
				}
			}
	} Catch {
		Write-Error "ERROR! $($_.Exception.Message)"
		Exit 1
	}
}


## :: Disable Services on device
Sys-Services-L1


Write-Host "COMPLIANT: $(Get-Date -Format "yyyy/MM/dd HH:mm:ss")"
Exit 0
