<#
.SYNOPSIS
	Checks if WWAHost svc is running; indication Device & User Setup Phases of ESP has not finished.
	This script would typically be used as a requirements script of a Win32 app; to ensure it does not install during Device or User Setup phase. 
		ie Exclude app from installing during Autopilot

.NOTES
	If the exitode is 0, the standard output (STDOUT) is interogated in more detail. For example, we can detect STDOUT as an string that has a value of "Installed"
	Recommended encoding = UTF-8
#>

If ( (Get-Process -Name WWAHost -ErrorAction SilentlyContinue).Responding -eq $True ) {
    # Autopilot IS running
	Write-Output 'MEM: ESP is running'
	Exit 7001
} Else {
    # Autopilot is NOT running
	Write-Output 'MEM: ESP is complete'
	Exit 0
}
