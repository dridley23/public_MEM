<#
.SYNOPSIS
	Audits/Deletes defaultuserX accounts post Autopilot.

.DESCRIPTION
	This is designed as a PAR Detection script to check if defaultuserX accounts exists locally.
	defaultuser1 will be retained as it relates to SSO
	Remediation script will delete if required.
	
	IMPORTANT: Assignments require filter for ENT devices so this remediation runs only after Autopilot has finished (ie after user logs on and OSE uplifts to ENT).
	Alternatively, the EspFinished function has been written into this script which should cover it.
		
.PARAMETER		Nil	
	
.NOTES:	
	.FILENAME
		mem-intune-Par-Detection-defaultuserX.ps1
		
	.OUTPUT
		Status will be sent up to PAR reports
	
	.VERSION HISTORY
		v1.0 | 09/11/2022	D.Ridley		Initial creation
#>


Function EspFinished {
	# Get explorer.exe process
	$ExplorerProcesses = @(Get-CimInstance -ClassName 'Win32_Process' -Filter "Name like 'explorer.exe'" -ErrorAction 'Ignore')

	# Find username of explorer process
	ForEach ($TargetProcess in $ExplorerProcesses) {
		$Username = (Invoke-CimMethod -InputObject $TargetProcess -MethodName GetOwner).User
	}

	# Interrogate explorer user
	If ( $UserName -eq 'defaultuser0' ) {
		# Autopilot Device Phase IS running
		$False
	} Else {
		# Autopilot Device Phase IS NOT running
		$True
	}
}


If ( EspFinished ) {
	$CurrentDate = Get-Date -Format g

	$NumOfAccounts = ( Get-LocalUser | where { ($_.Name -match 'defaultuser') -and ($_.Name -notmatch '1$') } ).Count
	If ( $NumOfAccounts -eq 0 ) {
		Write-Output "COMPLIANT: $($CurrentDate). defaultuser accounts: $($NumOfAccounts)."
		Exit 0
	} Else {
		Write-Output "NonCompliant $($CurrentDate). defaultuser accounts: $($NumOfAccounts)."
		Exit 1
	}
} Else {
	Write-Output "WARNING: $($CurrentDate). ESP still running"
	Exit 0
}