<#
.PURPOSE			Detection
.GUID				9b899cf2-ad77-4fb3-b6c4-45bc7b40cf6d
.SYNOPSIS			Cleans up transcript logs set within "cis.Windows Components (4.11)-4.0.0-L2" Intune policy
.DESCRIPTION		Default folder = C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\PSTranscript\
					Level 2 (L2)
.FILENAME			cis.Powershell Transcript Cleanup-rem-4.0.0-L2-Detection.ps1
.VERSION HISTORY	v1.0 | 20260217 12:59:57	[D.Ridley]		Initial creation
#>


# Path to the PowerShell transcript logs 
$TranscriptPath = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\PSTranscript"

# Number of days to retain logs
$RetentionDays = 60

# Get the current date
$CurrentDate = Get-Date

# Get all files older than the retention period
$OldFiles = Get-ChildItem -Path $TranscriptPath -File -Recurse | Where-Object { $_.LastWriteTime -lt $CurrentDate.AddDays(-$RetentionDays) }

# Delete old files
foreach ($File in $OldFiles) { 
	try { 
		Remove-Item -Path $File.FullName -Force 
		Write-Output "Deleted: $($File.FullName)" 
	} catch { 
		Write-Output "Failed to delete: $($File.FullName). Error: $_" 
	} 
}

# Get all empty folders
$EmptyFolders = Get-ChildItem -Path $TranscriptPath -Directory -Recurse | Where-Object { (Get-ChildItem -Path $_.FullName -Recurse | Measure-Object).Count -eq 0 }

# Delete empty folders
foreach ($Folder in $EmptyFolders) { 
	try { 
		Remove-Item -Path $Folder.FullName -Force -Recurse 
		Write-Output "Deleted empty folder: $($Folder.FullName)" 
	} catch { 
		Write-Output "Failed to delete folder: $($Folder.FullName). Error: $_" 
	}
}

# Re-check if all old files and empty folders have been deleted
$RemainingOldFiles = Get-ChildItem -Path $TranscriptPath -File -Recurse | Where-Object { $_.LastWriteTime -lt $CurrentDate.AddDays(-$RetentionDays) }
$RemainingEmptyFolders = Get-ChildItem -Path $TranscriptPath -Directory -Recurse | Where-Object { (Get-ChildItem -Path $_.FullName -Recurse | Measure-Object).Count -eq 0 }

# If no old files and no empty folders remain, exit with code 0 (compliant)
if ($RemainingOldFiles.Count -eq 0 -and $RemainingEmptyFolders.Count -eq 0) { 
	Write-Output "Successfully deleted logs" 
	exit 0
} else { 
	# If any old files or empty folders still remain, exit with code 1 (non-compliant) 
	Write-Output "Unable to delete all files" 
	exit 1
}
