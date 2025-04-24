<#
.PURPOSE			Detection
.GUID				cec351b3-a114-4671-92ab-fb3ea8816b53
.SYNOPSIS			Sets Current User registry keys for ASD Blueprint for Secure Cloud
.DESCRIPTION		Scripts/Block Certificates from Trusted Publishers that are only installed in the current user certificate store
					Scripts/Office Macro Hardening Prevent Activation of OLE
.FILENAME			asd-rem-HKCU Controls-Detection.ps1
.VERSION HISTORY	v1.0 | 20250411 15:55:57	[D.Ridley]		Initial creation
#>


$ErrorActionPreference = "Stop"

Function ReadReg {
    param (
        [Parameter(Mandatory = $true)]
        [string]$registryPath,
        [string]$registryName,
        $registryValue
    )

	Try {
		$ret = (Get-ItemProperty -Path $registryPath).$registryName
		If ( $ret -ne $registryValue ) { Throw "$($registryName) non compliant" }
	} Catch {
		Write-Output "ERROR! $($_.Exception.Message)"
		Exit 7001
	}
}


ReadReg -registryPath "HKCU:\Software\Policies\Microsoft\office\16.0\excel\security" -registryName "vbarequirelmtrustedpublisher" -registryValue 1
# Prevent Office Macro Activation of OLE
ReadReg -registryPath "HKCU:\Software\Microsoft\Office\16.0\Excel\Security" -registryName "PackagerPrompt" -registryValue 2
ReadReg -registryPath "HKCU:\Software\Microsoft\Office\16.0\PowerPoint\Security" -registryName "PackagerPrompt" -registryValue 2
ReadReg -registryPath "HKCU:\Software\Microsoft\Office\16.0\Word\Security" -registryName "PackagerPrompt" -registryValue 2


Write-Host "COMPLIANT: $(Get-Date -Format "yyyy/MM/dd HH:mm:ss")"
Exit 0
