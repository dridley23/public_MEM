<#
.PURPOSE			Detection
.GUID				38bbb1cd-8f9d-4a3f-8029-b4c1f450f5e8
.SYNOPSIS			Configures Windows 11 Services as per CIS Microsoft Intune for Windows 11 Benchmark (LEVEL 1)
.DESCRIPTION		Section #81 - System Services
					Level 1 (L1)
.FILENAME			cis.Services Controls-rem-4.0.0-L1-Detection.ps1
.VERSION HISTORY	v1.0 | 20250429 20:04:51	[D.Ridley]		Initial creation
					v1.1 | 20251126 12:03:13	[D.Ridley]		Added Enable function
#>


$ErrorActionPreference = "Stop"

Function Sys-Services-L1-Disable {
	Try {
		@(
			# 'Browser'				# Computer Browser
			'IISADMIN'				# IIS Admin Service
			'irmon'					# Infrared monitor service
			'LxssManager'			# LxssManager
			'FTPSVC'				# Microsoft FTP Service
			'sshd'					# OpenSSH SSH Server
			'RpcLocator'			# Remote Procedure Call (RPC) Locator
			'RemoteAccess'			# Routing and Remote Access
			'simptcp'				# Simple TCP/IP Services
			'sacsvr'				# Special Administration Console Helper
			'SSDPSRV'				# SSDP Discovery
			'upnphost'				# UPnP Device Host
			'WMSvc'					# Web Management Service
			'WMPNetworkSvc'			# Windows Media Player Network Sharing Service
			'icssvc'				# Windows Mobile Hotspot Service
			'W3SVC'					# World Wide Web Publishing Service
			'XboxGipSvc'			# Xbox Accessory Management Service
			'XblAuthManager'		# Xbox Live Auth Manager
			'XblGameSave'			# Xbox Live Game Save
			'XboxNetApiSvc'			# Xbox Live Networking Service
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


Function Sys-Services-L1-Enable {
	Try {
		@(
			'Browser'
		) | ForEach { 
			If ( Get-Service $_ -ErrorAction SilentlyContinue) {
				If ( (Get-Service $_).StartType -ne 'Manual' ) { Throw "Service: $_ not set to Automatic" } 
			}
		}
	} Catch {
		Write-Error "ERROR! $($_.Exception.Message)"
		Exit 1
	}
}


## :: Disable Services on device
Sys-Services-L1-Disable
## :: Enable Services on device
Sys-Services-L1-Enable


Write-Host "COMPLIANT: $(Get-Date -Format "yyyy/MM/dd HH:mm:ss")"
Exit 0
