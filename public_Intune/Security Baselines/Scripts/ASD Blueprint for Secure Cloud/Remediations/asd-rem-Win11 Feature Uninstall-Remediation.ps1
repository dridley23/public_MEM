<#
.PURPOSE			Remediation
.GUID				b76c73cd-7863-40b9-b782-1c8019248cae
.SYNOPSIS			Removes Win11 FeaturesOnDemand for ASD Blueprint for Secure Cloud
.DESCRIPTION		Scripts/User Application Hardening - Remove Features
.FILENAME			asd-rem-Win11 Feature Uninstall-Remediation.ps1
.VERSION HISTORY	v1.0 | 20250409 17:04:10	[D.Ridley]		Initial creation
#>


$ErrorActionPreference = "Stop"

# Setup Logging Functionality
$LogPath = "$($env:windir)\Logs\Intune"; IF (-not (Test-Path $LogPath -EA SilentlyContinue) ) { MD $LogPath -Force }
$LogFileName = "asd-rem-Win11 Feature Uninstall-Remediation.log"
$LogFile = "$($LogPath)\$($LogFileName)"

# Define features to Remove
# Full list via: (Get-WindowsOptionalFeature -Online).featurename | sort
$FeatureList = @(
	"NetFx3"
	"SMB1Protocol"
) 


Start-Transcript -Path "$LogFile" -Append -Force

$objFeature = Get-WindowsOptionalFeature -Online | where { $_.State -match "Enable" }		 # Enabled/EnablePending

ForEach ( $item in $FeatureList ) {
	Try {
		Write-Host "[$(Get-Date -Format "yyyy/MM/dd HH:mm:ss")]: Checking $item..." -NoNewLine
		If ( $objFeature.FeatureName -match $item ) {
			Write-Host "[$(Get-Date -Format "yyyy/MM/dd HH:mm:ss")]: Removing $item..." -NoNewLine
			$objFeature | where { $_.FeatureName -match $item } | Disable-WindowsOptionalFeature -Online -FeatureName $item -NoRestart -EA Stop -Verbose
			Write-Host "SUCCESS"
		} Else {
			$errMsg = $_.Exception.Message
			Write-Host "`n[$(Get-Date -Format "yyyy/MM/dd HH:mm:ss")]: $errMsg" -ForegroundColor Yellow
			$Exitcode = 7001
		}
	} Catch {
		$errMsg = $_.Exception.Message
		Write-Host "`n[$(Get-Date -Format "yyyy/MM/dd HH:mm:ss")]: $errMsg" -ForegroundColor Yellow
		$Exitcode = 7001
	} #end try
}

If (-not ($Exitcode) ) { $Exitcode = 0 }
Write-Host "[$(Get-Date -Format "yyyy/MM/dd HH:mm:ss")]: Exitcode = $ExitCode" -ForegroundColor Yellow
Stop-Transcript
Exit $Exitcode
