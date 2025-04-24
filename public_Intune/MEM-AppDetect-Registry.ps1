<#
.SYNOPSIS
	Search registry for DisplayName/DisplayVersion

.NOTES
	The app will be detected when the script both returns a 0 value exit code and writes a string value to STDOUT.
		When the script exits with the value of 0, the script execution was successful. 
		The second output channel indicates that the app was detected. STDOUT data indicates that the app was found on the client. We don't look for a particular string from STDOUT.
#>

$installsList = [collections.generic.list[psobject]]::new()

$installs64 =  Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\' | Get-ItemProperty | Select-Object DisplayName, DisplayVersion
$installs32 =  Get-ChildItem -Path 'HKLM:\SOFTWARE\Wow6432node\Microsoft\Windows\CurrentVersion\Uninstall\' | Get-ItemProperty | Select-Object DisplayName, DisplayVersion

$installs64 | ForEach-Object {$installsList.Add($_)}
$installs32 | ForEach-Object {$installsList.Add($_)}

$ret = $installsList | Where-Object { $_.DisplayName -match 'CrowdStrike Windows Sensor' -and [version]$_.DisplayVersion -ge [version]'6.30.14406.0' }
If ( $ret ) { 
	Write-Output "MEM: Installed"
	Exit 0
} Else {
	Exit 7001
}
