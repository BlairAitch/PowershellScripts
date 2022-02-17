﻿# Output start menu contents for each user
Write-Host "`r`n[+] Startup Folder Contents:`r`n"
$path = 'C:\Users\*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Start-up\*'
Get-ChildItem $path | Where-Object {$_.name -ne 'desktop.ini'}