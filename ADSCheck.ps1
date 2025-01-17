﻿# Check for alternate data streams

Write-Host "`r`nRecently Written Files:`r`n"
Write-Host "---------------------------`r`n"

ForEach($file in $recentFiles){
    Get-Item $file -stream * | Where-Object stream -ne ':$Data'
}