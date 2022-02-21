﻿Write-Host "`r`nRecently Written Files:`r`n"
Write-Host "---------------------------`r`n"

$recentFiles = Get-ChildItem -Path C:\ -Filter *.exe -Recurse -ErrorAction SilentlyContinue -Force|? {$_.LastWriteTime -gt (Get-Date).AddDays(-1)} | select -ExpandProperty FullName

ForEach($file in $recentFiles){
    Write-Host $file
}