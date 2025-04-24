<#
.PURPOSE			Remediation
.GUID				181c2907-a762-4a41-8748-5891ae8d9ace
.SYNOPSIS			Sets Local Machine registry keys for ASD Blueprint for Secure Cloud
.DESCRIPTION		Scripts/Allow Null Session Fallback
					Scripts/Auto Disconnect
					Scripts/Disable Domain Credentials
					Scripts/Disable Password Change
					Scripts/Everyone Includes Anonymous
					Scripts/FIPS Algorithm Policy
					Scripts/Force Key Protection
					Scripts/LDAP Client Integrity
					Scripts/Maximum Password Age
					Scripts/OB Case Insensitive
					Scripts/Protection Mode
					Scripts/Require Sign or Seal
					Scripts/Require Strong Key
					Scripts/SCENo Apply Legacy Audit Policy
					Scripts/Seal Secure Channel
					Scripts/Sign Secure Channel
.FILENAME			asd-rem-HKLM Controls-Remediation.ps1
.VERSION HISTORY	v1.0 | 20250411 15:56:58	[D.Ridley]		Initial creation
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

WriteReg -registryPath "HKLM:\System\CurrentControlSet\Control\LSA\MSV1_0" -registryName "allownullsessionfallback" -registryValue 0 -registryType "DWORD"
WriteReg -registryPath "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" -registryName "autodisconnect" -registryValue 15 -registryType "DWORD"
WriteReg -registryPath "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -registryName "DisableDomainCreds" -registryValue 1 -registryType "DWORD"
WriteReg -registryPath "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -registryName "DisablePasswordChange" -registryValue 0 -registryType "DWORD"
WriteReg -registryPath "HKLM:\System\CurrentControlSet\Control\Lsa" -registryName "EveryoneIncludesAnonymous" -registryValue 0 -registryType "DWORD"
WriteReg -registryPath "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\FIPSAlgorithmPolicy" -registryName "Enabled" -registryValue 1 -registryType "DWORD"
WriteReg -registryPath "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography" -registryName "ForceKeyProtection" -registryValue 2 -registryType "DWORD"
WriteReg -registryPath "HKLM:\System\CurrentControlSet\Services\LDAP" -registryName "LDAPClientIntegrity" -registryValue 1 -registryType "DWORD"
WriteReg -registryPath "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -registryName "MaximumPasswordAge" -registryValue 30 -registryType "DWORD"
WriteReg -registryPath "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" -registryName "ObCaseInsensitive" -registryValue 1 -registryType "DWORD"
WriteReg -registryPath "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -registryName "ProtectionMode" -registryValue 1 -registryType "DWORD"
WriteReg -registryPath "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -registryName "RequireSignOrSeal" -registryValue 1 -registryType "DWORD"
WriteReg -registryPath "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -registryName "RequireStrongKey" -registryValue 1 -registryType "DWORD"
WriteReg -registryPath "HKLM:\System\CurrentControlSet\Control\Lsa" -registryName "SCENoApplyLegacyAuditPolicy" -registryValue 1 -registryType "DWORD"
WriteReg -registryPath "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -registryName "SealSecureChannel" -registryValue 1 -registryType "DWORD"
WriteReg -registryPath "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -registryName "SignSecureChannel" -registryValue 1 -registryType "DWORD"
