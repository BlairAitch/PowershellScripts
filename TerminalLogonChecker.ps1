﻿# Check for terminal services logon
Write-Host "`r`n[+]  Terminal Services Logons:`r`n"
Write-Host "----------------------------------`r`n"
$Before = Get-Date 2022/02/20
$After = Get-Date 2022/02/15

Get-WinEvent -FilterHashtable @{LogName='Security';StartTime=$After;EndTime=$Before; Id='4624'}|Where {$_.Message -match "Logon Type:\s+10"}|Select TimeCreated,Message