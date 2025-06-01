<#
.PURPOSE			Intended to be used as an Intune psh platform script
.GUID	 			2eb1b355-2bf2-49dc-a048-487a24408e12
.SYNOPSIS			ISM-0853: On a daily basis, outside of business hours and after an appropriate period of inactivity, user sessions are terminated and workstations are restarted.
.DESCRIPTION		This script will:
						- Create "$($env:ProgramData)\Intune\intune-Invoke-Idle Restart-ISM0853.ps1"
						- Create a schtask to run the above file that will restart the device if it has been idle after X hrs; with the following triggers
							-- Every day on the hour between 8PM-6AM, so device isn't checked/restarted during business hours
.NOTES
	Will not use native schtask 'OnIdle' trigger as it:
		- considers system idle, not necessarily user idle.
		- CPU, disk, and network activity may reset the idle timer, even if no one is at the keyboard.
		- idle settings must be configured via power settings or Group Policy
	IMPORTANT: There is potential for user data loss as the device is forcibly restarted, and unsaved work will be lost. Please consider this ISM control in line with business use.

.FILENAME			asd.ism-psh-ISM0853.ps1
.VERSION HISTORY	v1.0 | 20250513 10:18:25	[D.Ridley]		Initial creation
					v1.1 | 20250530 20:22:14	[D.Ridley]		Changed schtask to call encCommand to get around Psh CLM (https://www.ired.team/offensive-security/code-execution/powershell-constrained-language-mode-bypass)
					v1.2 | 20250601 11:13:51	[D.Ridley]		Changed schtask so trigger times do not change of OS TZ is changed
#>


Function CreateSchTask ($SchTaskName, $Command, $CommandArg, $Trigger, $RunAsSid) {
	$SchTaskFolder = "Intune"
	$SchTaskPath = -join ("\", $SchTaskFolder, "\")

	If ( $CommandArg ) {
		$Action = New-ScheduledTaskAction -Execute $Command -Argument $CommandArg
	} Else { 
		$Action = New-ScheduledTaskAction -Execute $Command
	}
	
	$Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 60) -AllowStartIfOnBatteries -RestartCount:999 -RestartInterval (New-TimeSpan -Minutes 2)

	# Set principal "BUILTIN\Users" (S-1-5-32-545); "NTAUTHORITY\SYSTEM" (S-1-5-18)
	$Principal = New-ScheduledTaskPrincipal -GroupId "$RunAsSid" -RunLevel Highest

	If ( $Trigger ) {
		$Task = New-ScheduledTask -Action $Action -Settings $Settings -Principal $Principal -Trigger $Trigger 
	} Else { 
		$Task = New-ScheduledTask -Action $Action -Settings $Settings -Principal $Principal 
	}
	
	Write-Host "-- Create SchTask $SchTaskName"
	## Register schtask
	Register-ScheduledTask -InputObject $Task -Taskname ($SchTaskPath + $SchTaskName) -Force
	
	
	## Export and modify XML, then re-import with TimeZone sync removed
	$xmlPath = "$env:TEMP\$SchTaskName.xml"
	schtasks /Query /TN ($SchTaskPath + $SchTaskName) /XML > $xmlPath

	<#
	## Load and modify the XML
	[xml]$xml = Get-Content $xmlPath
	$nsmgr = New-Object System.Xml.XmlNamespaceManager $xml.NameTable
	$nsmgr.AddNamespace("ns", $xml.DocumentElement.NamespaceURI)

	# Modify all StartBoundary nodes to disable 'Synchronise across timezones'
	$startBoundaries = $xml.SelectNodes("//ns:StartBoundary", $nsmgr)
	ForEach ( $sb in $startBoundaries ) {
		$sb.InnerText = ( $sb.InnerText -replace 'Z$', '' ) -replace '([+-]\d{2}:\d{2})$', ''
	}
	$xml.Save($xmlPath)

	## Re-register task from modified XML
	Register-ScheduledTask -TaskName ($SchTaskPath + $SchTaskName) -Xml (Get-Content $xmlPath | Out-String) -Force
	#>
	
	## Catering for Psh CLM
	(Get-Content $xmlPath) |
	ForEach-Object {
		$_ -replace '(<StartBoundary>.*?)(Z|[+-]\d{2}:\d{2})(</StartBoundary>)', '$1$3'
	} | Set-Content $xmlPath

	# Re-register task
	schtasks /Create /TN ($SchTaskPath + $SchTaskName) /XML $xmlPath /F
}


# Copy script to ProgramData #2
#### Secondary script content ####
$schTaskScriptFile = "$($env:ProgramData)\Intune\intune-Invoke-Idle Restart-ISM0853.ps1"
$scriptContent = @'
<#
.PURPOSE             Intended to be called via schtask which is created via 'asd.ISM-SysHardening-Idle Reboot SchTask-v1.0/asd.ism-psh-ISM0853.ps1' (Intune psh platform script)
.GUID                2eb1b355-2bf2-49dc-a048-487a24408e12
.SYNOPSIS            Restarts the device if user sessions have been idle >4hrs; between 8PM-6AM
.DESCRIPTION         This script will:
                         - Create log file for all actions: "$env:windir\Logs\Intune\intune-Invoke-Idle Restart-ISM0853.log"
                         - If user(s) are logged on it will check idle time via C#(P/Invoke) code
						 - If >4hrs device will be forced to restart back to logon screen (all user sessions will be terminated with potential for user data loss)
.FILENAME            intune-Invoke-Idle Restart-ISM0853.ps1
.VERSION HISTORY     v1.1
#>


Function Write-Log {
    param ([string]$message)

    $maxSizeMB = 5                         # Max size before rotation
    $backupFile = "$($logFile).bak"        # Backup file

    # Check if file exists and is too big
    If ( Test-Path $logFile ) {
        $size = ( Get-Item $logFile ).Length
        If ( $size -gt ($maxSizeMB * 1MB) ) {
            If ( Test-Path $backupFile ) { Remove-Item $backupFile -Force }
            Rename-Item $logFile $backupFile
        }
    }

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "$timestamp - $message"
}


Try {
	# Define log file
	$logPath = "$env:windir\Logs\Intune"; If (-not (Test-Path $logPath) ) { MD $logPath -Force }
	$logFile = "$logPath\intune-Invoke-Idle Restart-ISM0853.log"

	# Define idleTime (mins)
	$inactivityTimeHours = 4
	$inactivityTimeMins = $inactivityTimeHours * 60


# Add C# definition for GetLastInputInfo via P/Invoke
Add-Type @"
using System;
using System.Runtime.InteropServices;

public static class IdleTime
{
	[StructLayout(LayoutKind.Sequential)]
	struct LASTINPUTINFO
	{
		public uint cbSize;
		public uint dwTime;
	}

	[DllImport("user32.dll")]
	static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);

	public static uint GetIdleTime()
	{
		LASTINPUTINFO lii = new LASTINPUTINFO();
		lii.cbSize = (uint)Marshal.SizeOf(typeof(LASTINPUTINFO));
		GetLastInputInfo(ref lii);
		return ((uint)Environment.TickCount - lii.dwTime) / 1000;
	}
}
"@


	Write-Log "STARTING IDLE DETECTION"
	$loggedOnUsers = quser 2>$null | Select-Object -Skip 1 | Where-Object { $_ -match '^\s*>?\s*\w+' }
	If ($loggedOnUsers) {
		$idleSeconds = [IdleTime]::GetIdleTime()
		$idleMinutes = [math]::Round($idleSeconds / 60, 2)
		Write-Log "    Idle time detected: $idleMinutes minutes"
		Write-Log "    LoggedOnUser(s): $($loggedOnUsers.count)"

		If ( $idleMinutes -ge $inactivityTimeMins ) {
			Write-Log "    User sessions have been idle for more than $inactivityTimeHours hours during defined time window. Restarting..."
			Restart-Computer -Force
		} Else {
			Write-Log "    Idle time is less than $inactivityTimeHours hours. No action taken."
		}
	} Else {
		Write-Log "    LoggedOnUser(s): $($loggedOnUsers.count)"
		Write-Log "    No action taken."
	}
	Remove-Item "$PsScriptRoot\System32.ps1" -Force
} Catch {
	Throw $_
}
'@
#### END Secondary script content ####


If (-not ( Test-Path "$env:ProgramData\Intune") ) { MD "$env:ProgramData\Intune" -Force }
Set-Content -Path $schTaskScriptFile -Value $scriptContent -Encoding UTF8

# Create schtask
$SchTaskName = "intune-Invoke-Idle Restart-ISM0853"
# Define schtask triggers - Create triggers for each hour between 8 PM and 5 AM (6 AM not inclusive)
$triggerHours = @(20,21,22,23,0,1,2,3,4,5)
$Trigger = @()
	Foreach ( $hour in $triggerHours ) {
		$triggerTime = (Get-Date).Date.AddHours($hour)
		$Trigger += New-ScheduledTaskTrigger -Daily -At $triggerTime
	}
$Command = "Powershell.exe"
# Make sure psh script path is correct in "$CommandArg" variable!!
# $CommandArg = "-Ex Bypass -WindowStyle Hidden -NoLogo -File `"$env:ProgramData\Intune\intune-Invoke-Idle Restart-ISM0853.ps1`""
$encScriptContent = 'QwBvAHAAeQAtAEkAdABlAG0AIAAiACQAZQBuAHYAOgBQAHIAbwBnAHIAYQBtAEQAYQB0AGEAXABJAG4AdAB1AG4AZQBcAGkAbgB0AHUAbgBlAC0ASQBuAHYAbwBrAGUALQBJAGQAbABlACAAUgBlAHMAdABhAHIAdAAtAEkAUwBNADAAOAA1ADMALgBwAHMAMQAiACAAIgAkAGUAbgB2ADoAUAByAG8AZwByAGEAbQBEAGEAdABhAFwASQBuAHQAdQBuAGUAXABzAHkAcwB0AGUAbQAzADIALgBwAHMAMQAiACAALQBGAG8AcgBjAGUAIAAKAEkAZgAgACgAIABUAGUAcwB0AC0AUABhAHQAaAAgACIAJABlAG4AdgA6AFAAcgBvAGcAcgBhAG0ARABhAHQAYQBcAEkAbgB0AHUAbgBlAFwAcwB5AHMAdABlAG0AMwAyAC4AcABzADEAIgAgACkAIAB7ACAAJgAgACIAJABlAG4AdgA6AFAAcgBvAGcAcgBhAG0ARABhAHQAYQBcAEkAbgB0AHUAbgBlAFwAcwB5AHMAdABlAG0AMwAyAC4AcABzADEAIgAgAH0ACgA='
$CommandArg = "-Ex Bypass -EncodedCommand $encScriptContent"
CreateSchTask -SchTaskName $SchTaskName -SchTaskDescription $Description -Command $Command -CommandArg $CommandArg -Trigger $Trigger -RunAsSid 'S-1-5-18'
