<#
.PURPOSE			Detection
.GUID				ddcda745-b872-4383-9738-af2502c50e64
.SYNOPSIS			Sets Environment variables
.DESCRIPTION		ISM-1622
.FILENAME			asd.ism-rem-Environment Variables-Detection.ps1
.VERSION HISTORY	v1.0 | 20250409 14:21:38	[D.Ridley]		Initial creation
#>


$envName = '__PSLockdownPolicy'
$envValue = '4'

Try {
    $currentLangMode = $ExecutionContext.SessionState.LanguageMode
	If ( $currentLangMode -eq 'ConstrainedLanguage' ) { 
		# Possibly set via AppLocker script rules which auto enables CLM
		Write-Host "COMPLIANT: $(Get-Date -Format "yyyy/MM/dd HH:mm:ss")"
		Exit 0
	} Else {
		# check the environmental variables
		$ret = [System.Environment]::GetEnvironmentVariable($envName, [System.EnvironmentVariableTarget]::Machine)
		If (-not ($ret) ) {
			Write-Host "nonComplaint: $envName not set"
			Exit 7002
		}
		If ( $ret -eq $envValue ) {
			Write-Host "COMPLIANT: $(Get-Date -Format "yyyy/MM/dd HH:mm:ss")"
			Exit 0
		} Else {
			Write-Host "nonComplaint: $envName is set to $ret"
			Exit 7003
		}
	}
} Catch {
    $errMsg = $_.Exception.Message
    Write-Host $errMsg
    Exit 7001
}
