<#
.PURPOSE			Remediation
.GUID				cec351b3-a114-4671-92ab-fb3ea8816b53
.SYNOPSIS			Sets Current User registry keys for ASD Blueprint for Secure Cloud
.DESCRIPTION		Scripts/Block Certificates from Trusted Publishers that are only installed in the current user certificate store
					Scripts/Office Macro Hardening Prevent Activation of OLE
.FILENAME			asd-rem-HKCU Controls-Remediation.ps1
.VERSION HISTORY	v1.0 | 20250411 15:56:06	[D.Ridley]		Initial creation
					v1.1 | 20251221 10:26:43	[D.Ridley]		Removed 'vbarequirelmtrustedpublisher' as it can now be set via Intune settings
#>


Function WriteReg {
    param (
        [Parameter(Mandatory = $true)]
        [string]$registryPath,
        [string]$registryName,
        $registryValue,
        [string]$registryType
    )

    If (-not (Test-Path $registryPath) ) { New-Item -Path $registryPath -Force | Out-Null }
    New-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -PropertyType $registryType -Force | Out-Null
}

## Require digitally signed macros to have a signed certificate residing in the Local Machine (LM) certificate store, rather than the Current User store. 
## This prevents standard users from adding their own "Trusted Publishers" to bypass security, as administrator privileges are required to modify the Local Machine store.
# WriteReg -registryPath "HKCU:\Software\Policies\Microsoft\office\16.0\excel\security" -registryName "vbarequirelmtrustedpublisher" -registryValue 1 -registryType "DWORD"

## Prevent Office Macro Activation of OLE
WriteReg -registryPath "HKCU:\Software\Microsoft\Office\16.0\Excel\Security" -registryName "PackagerPrompt" -registryValue 2 -registryType "DWORD"
WriteReg -registryPath "HKCU:\Software\Microsoft\Office\16.0\PowerPoint\Security" -registryName "PackagerPrompt" -registryValue 2 -registryType "DWORD"
WriteReg -registryPath "HKCU:\Software\Microsoft\Office\16.0\Word\Security" -registryName "PackagerPrompt" -registryValue 2 -registryType "DWORD"
