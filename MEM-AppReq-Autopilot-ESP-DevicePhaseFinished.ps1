<#
.SYNOPSIS
	Checks if explorer.exe is running under defaultuser0 context; indication Device Setup phase of ESP is still running.
	This script would typically be used as a requirements script of a Win32 app; to ensure it does not install during Device Setup phase.
	It will not stop the app installing during the User Setup phase.

.NOTES
	If the exitode is 0, the standard output (STDOUT) is interogated in more detail. For example, we can detect STDOUT as an string that has a value of "Installed"
	Recommended encoding = UTF-8
#>


# Get explorer.exe process
$ExplorerProcesses = @(Get-CimInstance -ClassName 'Win32_Process' -Filter "Name like 'explorer.exe'" -ErrorAction 'Ignore')

# Find username of explorer process
ForEach ($TargetProcess in $ExplorerProcesses) {
    $Username = (Invoke-CimMethod -InputObject $TargetProcess -MethodName GetOwner).User
}

# Interrogate explorer user
If ( $UserName -eq 'defaultuser0' ) {
    # Autopilot Device Phase IS running
	Write-Output 'MEM: Autopilot device phase still running'
	Exit 1
} Else {
    # Autopilot Device Phase NOT running
	Write-Output 'MEM: Autopilot device phase finished'
	Exit 0
}
