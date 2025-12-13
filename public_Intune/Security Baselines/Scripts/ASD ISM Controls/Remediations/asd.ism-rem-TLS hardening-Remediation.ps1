<#
.PURPOSE			Remediation
.GUID				8da6b936-e8fa-45f1-8877-af098087c9a3
.SYNOPSIS			TLS hardening. Disables SSL 2.0; SSL 3.0; TLS 1.0; TLS 1.1 and enables TLS 1.2; TLS 1.3
.DESCRIPTION		ISM-1085
.FILENAME			asd.ism-rem-TLS hardening-Remediation.ps1
.VERSION HISTORY	v1.0 | 20251210 14:19:52	[D.Ridley]		Initial creation
#>


$Settings = @(
    @{ Protocol="SSL 2.0";   Enabled=0; DisabledByDefault=1 },
    @{ Protocol="SSL 3.0";   Enabled=0; DisabledByDefault=1 },
    @{ Protocol="TLS 1.0";   Enabled=0; DisabledByDefault=1 },
    @{ Protocol="TLS 1.1";   Enabled=0; DisabledByDefault=1 },
    @{ Protocol="TLS 1.2";   Enabled=1; DisabledByDefault=0 },
    @{ Protocol="TLS 1.3";   Enabled=1; DisabledByDefault=0 }
)

foreach ($item in $Settings) {
    $proto = $item.Protocol

    foreach ($role in @("Client","Server")) {

        $path = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$proto\$role"

        if (!(Test-Path $path)) {
            New-Item -Path $path -Force | Out-Null
        }

        New-ItemProperty -Path $path -Name Enabled -Value $item.Enabled -PropertyType DWORD -Force | Out-Null
        New-ItemProperty -Path $path -Name DisabledByDefault -Value $item.DisabledByDefault -PropertyType DWORD -Force | Out-Null
    }
}

Write-Output "TLS protocol settings remediated."
exit 0
