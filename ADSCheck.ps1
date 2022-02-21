﻿# Output a list of recent files, then  check them for Alternate Data Streams

Write-Host "`r`nRecently Written Files:`r`n"
Write-Host "---------------------------`r`n"

$recentFiles = Get-ChildItem -Path C:\ -Filter *.exe -Recurse -ErrorAction SilentlyContinue -Force|? {$_.LastWriteTime -gt (Get-Date).AddDays(-1)|select -exp FullName}

ForEach($file in $recentFiles){
    Get-Item $file -stream * | Where-Object stream -ne ':$Data'
}