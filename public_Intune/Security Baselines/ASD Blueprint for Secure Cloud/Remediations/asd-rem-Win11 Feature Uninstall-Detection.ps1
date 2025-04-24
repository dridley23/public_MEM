<#
.PURPOSE			Detection
.GUID				b76c73cd-7863-40b9-b782-1c8019248cae
.SYNOPSIS			Removes Win11 Optional Features for ASD Blueprint for Secure Cloud
.DESCRIPTION		Scripts/User Application Hardening - Remove Features
.FILENAME			asd-rem-Win11 Feature Uninstall-Detection.ps1
.VERSION HISTORY	v1.0 | 20250409 17:02:26	[D.Ridley]		Initial creation
#>


$ErrorActionPreference = "Stop"


# Define features to Remove; Comment out apps you do NOT wish to uninstall
$FeatureList = @(
	"Internet-Explorer-Optional-amd64"
	"NetFx3"
	"MicrosoftWindowsPowerShellV2Root"
) 


$objFeature = Get-WindowsOptionalFeature -Online | where { $_.State -match "Enable" }		 # Enabled/EnablePending

ForEach ( $item in $FeatureList ) {
	Try {
		If ( $objFeature.FeatureName -eq $item ) {
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
