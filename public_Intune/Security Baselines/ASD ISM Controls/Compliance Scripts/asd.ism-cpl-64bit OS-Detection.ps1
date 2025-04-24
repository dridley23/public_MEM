<#
.PURPOSE			Detection
.GUID				b11cf4a4-d4e5-4b8c-bd57-695e09fff440
.SYNOPSIS			Marks device as compliant if it is 64bit as per CIS Microsoft Intune for Windows 11 Benchmark (LEVEL 2)
.DESCRIPTION		ISM-1408
.NOTES				- Runs compliance policy check. The script evaluates the conditions of the JSON file uploaded to the same policy.
					- Identifies one or more settings, as defined in the JSON, and returns a list of discovered values for those settings.
					- Must be compressed to output results in one line.
					- Ensure JSON file does not have tabs in it !!
					- Output is case-sensitive so ensure JSON matches
					- If JSON eval returns $Null then there is an error in the JSON code. Check Complaince "Per-setting" status in MEM console
					- JSON
						{"IsNotVM":true}
						{"IsNotVM":false}
.FILENAME			asd.ism-cpl-64bit OS-Detection.ps1
.VERSION HISTORY	v1.0 | 20250410 20:46:09	[D.Ridley]		Initial creation
#>


If ( [Environment]::Is64BitOperatingSystem ) {
	$hash = @{ is64Bit = $true }
} Else {
	$hash = @{ is64Bit = $false }
}

return $hash | ConvertTo-Json -Compress
