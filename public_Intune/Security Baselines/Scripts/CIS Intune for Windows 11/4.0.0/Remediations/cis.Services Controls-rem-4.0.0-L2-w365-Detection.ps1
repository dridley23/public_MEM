<#
.PURPOSE			Detection
.GUID				a0167bb5-3bcf-43e2-a86f-158ec9c7cbd2
.SYNOPSIS			Configures Windows 11 Services as per CIS Microsoft Intune for Windows 11 Benchmark (LEVEL 2)
.DESCRIPTION	    Section #81 - System Services
					Level 2 (L2)
.FILENAME			cis.Services Controls-rem-4.0.0-L2-Detection.ps1
.VERSION HISTORY	v1.0 | 20250429 20:06:09	[D.Ridley]		Initial creation
					v1.1 | 20251124 09:53:14	[D.Ridley]		Added Enable section to toggle services on
#>


$ErrorActionPreference = "Stop"

Function Sys-Services-L2-Disable {
	Try {
		@(
			'BTAGService'           	# Bluetooth Audio Gateway Service                          ; required or BT Audio/Mic
			'bthserv'               	# Bluetooth Support Service                                ; required for some native BT mice/keyboards
			'MapsBroker'            	# Downloaded Maps Manager
			'GameInputSvc'         		# GameInput Service
			'lfsvc'               		# Geolocation Service
			'lltdsvc'               	# Link-Layer Topology Discovery Mapper
			'MSiSCSI'               	# Microsoft iSCSI Initiator Service
			'Spooler'               	# Print Spooler                                            ; required for PrintToPdf too
			'wercplsupport'         	# Problem Reports and Solutions Control Panel Support
			# 'RasAuto'               	# Remote Access Auto Connection Manager                    ; required for w365
			# 'SessionEnv'            	# Remote Desktop Configuration                             ; required for w365 + dependency for Workstation svc (LanmanWorkstation)
			# 'TermService'           	# Remote Desktop LocalServices                             ; required for w365
			# 'UmRdpService'          	# Remote Desktop LocalServices UserMode Port Redirector    ; required for w365
			'RemoteRegistry'			# Remote Registry
			'LanmanServer'          	# Server
			'SNMP'						# SNMP Service
			'WerSvc'                	# Windows Error Reporting Service
			'Wecsvc'                	# Windows Event Collector
			# 'WpnService'            	# Windows Push Notifications System Service                 ; required for Intune push WNS
			'PushToInstall'         	# Windows PushToInstall Service
			'WinRM'                 	# Windows Remote Management
			# 'WinHttpAutoProxySvc'		# WinHTTP Web Proxy Auto-Discovery Service 					; required as dependency for WLANAutoConfig service
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


Function Sys-Services-L2-Enable {
	Try {
		@(
			'RasAuto'     
			'SessionEnv'  
			'TermService' 
			'UmRdpService'
			'WpnService'
			'WinHttpAutoProxySvc'
		) | ForEach { 
			If ( Get-Service $_ -ErrorAction SilentlyContinue) {
				If ( (Get-Service $_).StartType -ne 'Automatic' ) { Throw "Service: $_ not set to Automatic" } 
			}
		}
	} Catch {
		Write-Error "ERROR! $($_.Exception.Message)"
		Exit 1
	}
}




## :: Disable Services on device
Sys-Services-L2-Disable
## :: Enable Services on device
Sys-Services-L2-Enable


Write-Host "COMPLIANT: $(Get-Date -Format "yyyy/MM/dd HH:mm:ss")"
Exit 0
