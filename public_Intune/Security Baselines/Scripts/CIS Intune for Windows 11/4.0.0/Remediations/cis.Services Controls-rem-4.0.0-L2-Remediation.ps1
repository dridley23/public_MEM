<##############################################################################
   
    CIS Microsoft Intune for Windows 11 Benchmark v4.0.0 Build Kit script
    Section #81 - System Services
    Level 2 (L2)

    The purpose of this script is to configure a system using the recommendations 
    provided in the Benchmark, section(s), and profile level listed above to a 
    hardened state consistent with a CIS Benchmark. 
    
    The script can be tailored to the organization's needs such as by creating 
    exceptions or adding additional event logging.

    This script can be deployed through various means, including Intune script 
    manager, running it locally, or through any automation tool.

    Version: 1.10
    Updated: 24.Apr.2025 by jjarose

.VERSION HISTORY	v1.1 | 20251124 09:53:14	[D.Ridley]		Added Enable section to toggle services on

##############################################################################>

#Requires -RunAsAdministrator
<# Start values
	2 = Automatic
	3 = Manual
	4 = Disable
#>


$L2Services = @{
	## Disabled Services
    'Bluetooth Audio Gateway Service' 						= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\BTAGService'				; Start=4 }
    'Bluetooth Support Service'       						= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\bthserv'					; Start=4 }
    'Downloaded Maps Manager'         						= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\MapsBroker'				; Start=4 }
    'GameInput Service'               						= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\GameInputSvc'			; Start=4 }
    'Geolocation Service'             						= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc'					; Start=4 }
    'Link-Layer Topology Discovery Mapper' 					= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\lltdsvc'					; Start=4 }
    'Microsoft iSCSI Initiator Service' 					= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\MSiSCSI'					; Start=4 }
    'Print Spooler'                   						= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\Spooler'					; Start=4 }
    'Problem Reports and Solutions Control Panel Support' 	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\wercplsupport'			; Start=4 }
    'Remote Access Auto Connection Manager' 				= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\RasAuto'					; Start=4 }
    'Remote Desktop Configuration'    						= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\SessionEnv'				; Start=4 }
    'Remote Desktop LocalServices'    						= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\TermService'				; Start=4 }
    'Remote Desktop LocalServices UserMode Port Redirector' = @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\UmRdpService'			; Start=4 }
    'Remote Registry'                 						= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\RemoteRegistry'			; Start=4 }
    'Server'                          						= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer'			; Start=4 }
    'SNMP Service'                    						= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\SNMP'					; Start=4 }
    'Windows Error Reporting Service' 						= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\WerSvc'					; Start=4 }
    'Windows Event Collector'         						= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\Wecsvc'					; Start=4 }
    'Windows PushToInstall Service'   						= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\PushToInstall'			; Start=4 }
    'Windows Remote Management'       						= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\WinRM'					; Start=4 }
	
	## Enabled Services (Automatic or Manual)
	'Windows Push Notifications System Service'             = @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\WpnService'				; Start=2 }
    'WinHTTP Web Proxy Auto-Discovery Service'              = @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc'		; Start=2 }		# required for WiFi as it is a dependency
}


ForEach ($service in $L2Services.GetEnumerator()) {
    $ServiceName = $service.Key
    $ServicePath = $service.Value.Path
	$ServiceStart = $service.Value.Start
	
    If (Test-Path -LiteralPath $ServicePath) { 
        $StartValue = (Get-ItemProperty -LiteralPath $ServicePath).Start
        If ($StartValue -and $StartValue -ne $ServiceStart) {
            Set-ItemProperty -LiteralPath $ServicePath -Name 'Start' -Value $ServiceStart
        }
	}
}
