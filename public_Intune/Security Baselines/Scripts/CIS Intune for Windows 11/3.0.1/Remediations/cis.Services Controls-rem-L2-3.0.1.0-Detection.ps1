<#
.PURPOSE			Detection
.GUID				3fa63147-eb57-47be-a847-03e19bcc6111
.SYNOPSIS			Configures Windows 11 Services as per CIS Microsoft Intune for Windows 11 Benchmark (LEVEL 2)
.DESCRIPTION		L2/69.1
					L2/69.2
					L2/69.4
					L2/69.5
					L2/69.9
					L2/69.12
					L2/69.14
					L2/69.15
					L2/69.16
					L2/69.17
					L2/69.18
					L2/69.19
					L2/69.20
					L2/69.21
					L2/69.22
					L2/69.23
					L2/69.25
					L2/69.27
					L2/69.29
					L2/69.34
					L2/69.35
					L2/69.38
					L2/69.39
					L2/69.40
.FILENAME			cis.Services Controls-rem-L2-3.0.1.1-Detection.ps1
.VERSION HISTORY	v1.0 | 20250409 17:15:44	[D.Ridley]		Initial creation
#>


$ErrorActionPreference = "Stop"

Function Sys-Services-L2 {
	Try {
		## :: Section 5 - System Services
		@(
		'BTAGService'           # Bluetooth Audio Gateway Service
		'bthserv'               # Bluetooth Support Service
		'MapsBroker'            # Downloaded Maps Manager
		'lfsvc'               	# Geolocation Service
		'lltdsvc'               # Link-Layer Topology Discovery Mapper
		'MSiSCSI'               # Microsoft iSCSI Initiator Service
		'PNRPsvc'               # Peer Name Resolution Protocol
		'p2psvc'                # Peer Networking Grouping
		'p2pimsvc'              # Peer Networking Identity Manager
		'PNRPAutoReg'           # PNRP Machine Name Publication Service
		'Spooler'               # Print Spooler 
		'wercplsupport'         # Problem Reports and Solutions Control Panel Support
		'RasAuto'               # Remote Access Auto Connection Manager
		'SessionEnv'            # Remote Desktop Configuration
		'TermService'           # Remote Desktop Services
		'UmRdpService'          # Remote Desktop Services UserMode Port Redirector
		'RemoteRegistry'		# Remote Registry
		'LanmanServer'          # Server
		'SNMP'					# SNMP Service
		'WerSvc'                # Windows Error Reporting Service
		'Wecsvc'                # Windows Event Collector
		'WpnService'            # Windows Push Notifications System Service
		'PushToInstall'         # Windows PushToInstall Service
		'WinRM'                 # Windows Remote Management
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
Sys-Services-L2


Write-Host "COMPLIANT: $(Get-Date -Format "yyyy/MM/dd HH:mm:ss")"
Exit 0
