<##############################################################################
   
    CIS Microsoft Intune for Windows 11 Benchmark v4.0.0 Build Kit script
    Section #81 - System Services
    Level 1 (L1)

    The purpose of this script is to configure a system using the recommendations 
    provided in the Benchmark, section(s), and profile level listed above to a 
    hardened state consistent with a CIS Benchmark. 
    
    The script can be tailored to the organization's needs such as by creating 
    exceptions or adding additional event logging.

    This script can be deployed through various means, including Intune script 
    manager, running it locally, or through any automation tool.

    Version: 1.10
    Updated: 24.Apr.2025 by jjarose
	
.VERSION HISTORY	v1.1 | 20251201 19:01:58	[D.Ridley]		Added Enable section to toggle services on

##############################################################################>

#Requires -RunAsAdministrator
<# Start values
	2 = Automatic
	3 = Manual
	4 = Disable
#>


$L1Services = @{
    ## Disabled Services
	'IIS Admin Service'                           	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\IISADMIN'        ; Start=4 }
    'Infrared monitor service'                    	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\irmon'           ; Start=4 }
    'LxssManager'                                 	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\LxssManager'     ; Start=4 }
    'Microsoft FTP Service'                       	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\FTPSVC'          ; Start=4 }
    'OpenSSH SSH Server'                          	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\sshd'            ; Start=4 }
    'Remote Procedure Call (RPC) Locator'         	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\RpcLocator'      ; Start=4 }
    'Routing and Remote Access'                   	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\RemoteAccess'    ; Start=4 }
    'Simple TCP/IP LocalServices'                 	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\simptcp'         ; Start=4 }
    'Special Administration Console Helper'       	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\sacsvr'          ; Start=4 }
    'SSDP Discovery'                              	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\SSDPSRV'         ; Start=4 }
    'UPnP Device Host'                            	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\upnphost'        ; Start=4 }
    'Web Management Service'                      	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\WMSvc'           ; Start=4 }
    'Windows Media Player Network Sharing Service'	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\WMPNetworkSvc'   ; Start=4 }
    'Windows Mobile Hotspot Service'              	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\icssvc'          ; Start=4 }
    'World Wide Web Publishing Service'           	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\W3SVC'           ; Start=4 }
    'Xbox Accessory Management Service'           	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\XboxGipSvc'      ; Start=4 }
    'Xbox Live Auth Manager'                      	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\XblAuthManager'  ; Start=4 }
    'Xbox Live Game Save'                         	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\XblGameSave'     ; Start=4 }
    'Xbox Live Networking Service'                	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\XboxNetApiSvc'   ; Start=4 }
	
	## Enabled Services (Automatic or Manual)
    'Computer Browser'                            	= @{ Path='HKLM:\SYSTEM\CurrentControlSet\Services\Browser'			; Start=3 }
}


ForEach ($service in $L1Services.GetEnumerator()) {
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
