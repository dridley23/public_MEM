<#
.PURPOSE			Remediation
.GUID				ddcda745-b872-4383-9738-af2502c50e64
.SYNOPSIS			Sets Environment variables
.DESCRIPTION		ISM-1622
.FILENAME			asd.ism-rem-Environment Variables-Remediation.ps1
.VERSION HISTORY	v1.0 | 20250409 14:21:38	[D.Ridley]		Initial creation
#>


$envName = '__PSLockdownPolicy'
$envValue = '4'

Try {
    # set the variables
    [System.Environment]::SetEnvironmentVariable($envName, $envValue, [System.EnvironmentVariableTarget]::Machine)
} Catch {
    $errMsg = $_.Exception.Message
    Write-Host $errMsg
    Exit 7001 
}
