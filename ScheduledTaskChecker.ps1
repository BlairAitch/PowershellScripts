﻿# this script's function is to output scheduled tasks, helping to check for persistence

$tasks = Get-ChildItem "C:\Windows\System32\Tasks" -Recurse

ForEach($task in $tasks){
    Write-Host "`r`n[+] Task: $task"
    Write-Host "-----------------------------------------------------`r`n"
    Get-Content $task -ErrorAction SilentlyContinue | Select-String -Pattern '<Command>' -SimpleMatch
}