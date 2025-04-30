<#
.PURPOSE			Remediation
.GUID				8a6ead39-d3c0-4fee-aea1-11c34c8700d3
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
.FILENAME			cis.Services Controls-rem-4.0.0-L2-Remediation.ps1
.VERSION HISTORY	v1.0 | 20250429 20:06:09	[D.Ridley]		Initial creation
#>


Function Sys-Services-L2 {
	## :: Section 5 - System Services
	@(
		'BTAGService'           # Bluetooth Audio Gateway Service
		'bthserv'               # Bluetooth Support Service
		'MapsBroker'            # Downloaded Maps Manager
		'GameInputSvc'         	# GameInput Service
		'lfsvc'               	# Geolocation Service
		'lltdsvc'               # Link-Layer Topology Discovery Mapper
		'MSiSCSI'               # Microsoft iSCSI Initiator Service
		'Spooler'               # Print Spooler 
		'wercplsupport'         # Problem Reports and Solutions Control Panel Support
		'RasAuto'               # Remote Access Auto Connection Manager
		'SessionEnv'            # Remote Desktop Configuration
		'TermService'           # Remote Desktop LocalServices
		'UmRdpService'          # Remote Desktop LocalServices UserMode Port Redirector
		'RemoteRegistry'		# Remote Registry
		'LanmanServer'          # Server
		'SNMP'					# SNMP Service
		'WerSvc'                # Windows Error Reporting Service
		'Wecsvc'                # Windows Event Collector
		'WpnService'            # Windows Push Notifications System Service
		'PushToInstall'         # Windows PushToInstall Service
		'WinRM'                 # Windows Remote Management
		'WinHttpAutoProxySvc'	# WinHTTP Web Proxy Auto-Discovery Service
	) | ForEach { 
			If ( Get-Service $_ -ErrorAction SilentlyContinue ) {
				Get-Service $_ | Stop-Service -Force -Verbose -EA SilentlyContinue	 # If this step cannot run do not make it terminal, insetad it will require a reboot post-disable
				Get-Service $_ | Set-Service -StartupType Disabled -Verbose 
			}
		}
}


## :: Disable Services on device
Sys-Services-L2
