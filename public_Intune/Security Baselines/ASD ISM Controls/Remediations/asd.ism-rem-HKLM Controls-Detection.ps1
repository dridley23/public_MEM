<#
.PURPOSE			Detection
.GUID				8c2ab446-3867-4c2c-bf25-aa4201942ab8
.SYNOPSIS			Removes any Credential Hints for accounts
.DESCRIPTION		ISM-1980
.FILENAME			asd.ism-rem-HKLM Controls-Detection.ps1
.VERSION HISTORY	v1.0 | 20250409 14:21:38	[D.Ridley]		Initial creation
#>


$regPath = "HKEY_LOCAL_MACHINE\SAM\SAM\Domains\Account\Users"
$regValue = "UserPasswordHint"

Try {
    # Get user RID list
    $userRidList = Get-ChildItem -Path "registry::$regPath" -Exclude "Names"
    ForEach ( $rid in $userRidList ) {
		$ret = (Get-ItemProperty -Path "registry::$rid").$regValue
		If ( $ret ) {
			Write-Host "nonCompliant: $regValue set for $($rid.PSChildName)"
			Exit 7002
		}
	}

	Write-Host "COMPLIANT: $(Get-Date -Format "yyyy/MM/dd HH:mm:ss")"
    Exit 0
} Catch {
    $errMsg = $_.Exception.Message
    Write-Host $errMsg
    Exit 7001
}
