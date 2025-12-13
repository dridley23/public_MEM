<#
.SYNOPSIS
	Audits/Deletes defaultuserX accounts post Autopilot.

.DESCRIPTION
	This is designed as a PAR Remediation script to delete defaultuserX accounts that exist locally.
	defaultuser1 will be retained as it relates to SSO
		
.PARAMETER		Nil	
	
.NOTES:	
	.FILENAME
		intune-defaultuserX Cleanup-Remediation.ps1
		
	.OUTPUT
		Status will be sent up to PAR reports
	
	.VERSION HISTORY
		v1.0 | 09/11/2022	D.Ridley		Initial creation
#>


$retAccounts = Get-LocalUser | where { ($_.Name -match 'defaultuser') -and ($_.Name -notmatch '1$') }
If ( $retAccounts.Count -ge 1 ) {
	ForEach ( $account in $retAccounts ) { 
		If ( $account.Name -ne '' ) { Get-LocalUser $account | Remove-LocalUser }
	}
}
