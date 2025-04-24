<#
.PURPOSE			Remediation
.GUID				e7e43ee5-d886-4aa6-a400-50483ee4abe2
.SYNOPSIS			Removes Win11 Optional Features for ASD Blueprint for Secure Cloud
.DESCRIPTION		Scripts/User Application Hardening - Remove Features
.FILENAME			asd-rem-Win11 FoD Uninstall-Remediation.ps1
.VERSION HISTORY	v1.0 | 20250409 17:08:09	[D.Ridley]		Initial creation
#>


# $ErrorActionPreference = "Stop"

# Setup Logging Functionality
$LogPath = "$($env:windir)\Logs\Intune"; IF (-not (Test-Path $LogPath -EA SilentlyContinue) ) { MD $LogPath -Force }
$LogFileName = "asd-rem-Win11 FoD Uninstall-Remediation.log"
$LogFile = "$($LogPath)\$($LogFileName)"

# Define features to Remove; Comment out apps you do NOT wish to uninstall
$FoDList = @(
	"Browser.InternetExplorer~~~~0.0.11.0"
)


Start-Transcript -Path "$LogFile" -Append -Force

$WindowsCapability = Get-WindowsCapability -Online | where { $_.State -eq "Installed" }

ForEach ( $item in $FoDList ) {
	Try {
		Write-Host "[$(Get-Date -Format "yyyy/MM/dd HH:mm:ss")]: Checking $item..." -NoNewLine
		If ( $WindowsCapability.Name -eq $item  ) {
			Write-Host "Removing..." -NoNewLine
			$WindowsCapability | where { $_.Name -eq $item } | Remove-WindowsCapability -Online -EA Stop -Verbose
			Write-Host "SUCCESS"
		} Else {
			Write-Host "not installed"
		}
	} Catch {
		$errMsg = $_.Exception.Message
		Write-Host "`n[$(Get-Date -Format "yyyy/MM/dd HH:mm:ss")]: $errMsg" -ForegroundColor Yellow
		$Exitcode = 7001
	}
}

If (-not ($Exitcode) ) { $Exitcode = 0 }
Write-Host "[$(Get-Date -Format "yyyy/MM/dd HH:mm:ss")]: Exitcode = $ExitCode" -ForegroundColor Yellow
Stop-Transcript
Exit $Exitcode
