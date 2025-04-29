<#
.PURPOSE			Remediation
.GUID				cec351b3-a114-4671-92ab-fb3ea8816b53
.SYNOPSIS			Sets Current User registry keys for ASD Blueprint for Secure Cloud
.DESCRIPTION		Scripts/Block Certificates from Trusted Publishers that are only installed in the current user certificate store
					Scripts/Office Macro Hardening Prevent Activation of OLE
.FILENAME			asd-rem-HKCU Controls-Remediation.ps1
.VERSION HISTORY	v1.0 | 20250411 15:56:06	[D.Ridley]		Initial creation
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

WriteReg -registryPath "HKCU:\Software\Policies\Microsoft\office\16.0\excel\security" -registryName "vbarequirelmtrustedpublisher" -registryValue 1 -registryType "DWORD"
# Prevent Office Macro Activation of OLE
WriteReg -registryPath "HKCU:\Software\Microsoft\Office\16.0\Excel\Security" -registryName "PackagerPrompt" -registryValue 2 -registryType "DWORD"
WriteReg -registryPath "HKCU:\Software\Microsoft\Office\16.0\PowerPoint\Security" -registryName "PackagerPrompt" -registryValue 2 -registryType "DWORD"
WriteReg -registryPath "HKCU:\Software\Microsoft\Office\16.0\Word\Security" -registryName "PackagerPrompt" -registryValue 2 -registryType "DWORD"
