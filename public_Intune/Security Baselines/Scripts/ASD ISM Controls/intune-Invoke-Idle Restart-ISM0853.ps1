# Define log file
$logFile = "$env:windir\Logs\Intune\IdleRestart.log"
if (!(Test-Path -Path (Split-Path $logFile))) {
    New-Item -ItemType Directory -Path (Split-Path $logFile) -Force | Out-Null
}

Function Write-Log {
    param ([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "$timestamp - $message"
}

# Define the allowed restart window: 8 PM today to 6 AM next day
$startTime = [datetime]::Today.AddHours(20)         # 8 PM today
$endTime = [datetime]::Today.AddDays(1).AddHours(6) # 6 AM next day
$currentTime = Get-Date

# Adjust time window if current time is before 8 PM
if ($currentTime -lt $startTime) {
    $startTime = $startTime.AddDays(-1)
    $endTime = $endTime.AddDays(-1)
}

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

# Check if current time is within allowed window
if ( ($currentTime -ge $startTime) -or ($currentTime -lt $endTime) ) {
    $idleSeconds = [IdleTime]::GetIdleTime()
    $idleMinutes = [math]::Round($idleSeconds / 60, 2)
    Write-Log "Idle time detected: $idleMinutes minutes"

    if ($idleMinutes -ge 240) { # 4 hours
        Write-Log "User has been idle for more than 4 hours during allowed time window. Restarting..."
        Restart-Computer -Force
    } else {
        Write-Log "Idle time is less than 4 hours. No action taken."
    }
} else {
    Write-Log "Current time is outside the restart window. No action taken."
}
