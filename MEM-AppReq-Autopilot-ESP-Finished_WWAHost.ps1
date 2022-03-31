If ( (Get-Process -Name WWAHost -ErrorAction SilentlyContinue).Responding -eq $True ) {
    # Autopilot IS running
	Write-Output 'MEM: ESP is running'
	Exit 1
} Else {
    # Autopilot is NOT running
	Write-Output 'MEM: ESP is complete'
	Exit 0
}
