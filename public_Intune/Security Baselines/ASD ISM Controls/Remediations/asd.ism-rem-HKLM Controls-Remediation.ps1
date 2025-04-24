<#
.PURPOSE			Remediation
.GUID				8c2ab446-3867-4c2c-bf25-aa4201942ab8
.SYNOPSIS			Removes any Credential Hints for accounts
.DESCRIPTION		ISM-1980
.FILENAME			asd.ism-rem-HKLM Controls-Remediation.ps1
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
			# Remove UserPasswordHint
			Remove-ItemProperty -Path "registry::$rid" -Name $regValue -Force
		}
	}
} Catch {
    $errMsg = $_.Exception.Message
    Write-Host $errMsg
    Exit 7001
}
