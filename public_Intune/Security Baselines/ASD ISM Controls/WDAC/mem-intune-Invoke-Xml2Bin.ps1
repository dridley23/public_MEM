param (
    [Parameter(Mandatory=$true)]
    [string]$XmlFile #= $($args[1])
)

$XmlFile = $XmlFile -replace '.xml',''
$XmlFile = $XmlFile -replace '"',''
$XmlFile
# $($args[0])
# $($args[1])

ConvertFrom-CIPolicy -XmlFilePath "$($XmlFile).xml" -BinaryFilePath "$($XmlFile).bin"

Write-Host "All Done..." -Fore Yellow
Start-Sleep 10
