<#
.PURPOSE			Detection
.GUID				e7e43ee5-d886-4aa6-a400-50483ee4abe2
.SYNOPSIS			Removes Win11 FeaturesOnDemand for ASD Blueprint for Secure Cloud
.DESCRIPTION		Scripts/User Application Hardening - Remove Features
.FILENAME			asd-rem-Win11 FoD Uninstall-Detection.ps1
.VERSION HISTORY	v1.0 | 20250409 17:07:21	[D.Ridley]		Initial creation
#>


# $ErrorActionPreference = "Stop"

# Define features to Remove; Comment out apps you do NOT wish to uninstall
$FoDList = @(
	"Browser.InternetExplorer~~~~0.0.11.0"
)


$WindowsCapability = Get-WindowsCapability -Online | where { $_.State -eq "Installed" }

ForEach ( $item in $FoDList ) {
	Try {
		If ( $WindowsCapability.Name -eq $item ) {
			$Msg = "ERROR: $item is installed: $(Get-Date -Format "yyyy/MM/dd HH:mm:ss")"
			Throw
		}
		Clear-Variable Msg -EA SilentlyContinue
	} Catch {
		If ( $Msg ) {
			Write-Host "$($Msg)"				# Trigger Remediation script
			Exit 7001
		} Else {
			Write-Error "$_.Exception.Message"	# Do not trigger Remediation script as cmdlets must have failed
			Exit 7002
		}
	}
}

Write-Host "COMPLIANT: $(Get-Date -Format "yyyy/MM/dd HH:mm:ss")"
Exit 0
