﻿##  This is a script designed to print out information pertaining to the most common IoCs


<#  This script's function is to output the registry values which malware may manipulate in order to
      gain persistence.
#>
# First let's return the system keys where suspicious values may be
$syskeys = "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run", "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce"

echo "[-----] SYSTEM KEYS [-----]"
ForEach($key in $syskeys) {
    Get-ItemProperty Registry::$key
    }

# Now, we want to look at user-based registry keys
#  We know user SIDs won't start with S,1,5,18,19 or 20 
$users = (Get-WmiObject Win32_UserProfile | Where-Object {$_.SID -notmatch 'S-1-5-(18|19|20).*'})
$userPaths = $users.localpath
$usersSIDs = $users.sid

for ($counter=0; $counter -lt $users.length; $counter++){
    $path = $users[$counter].localpath
    $sid = $users[$counter].sid
    reg load hku\$sid $path\ntuser.dat
    }

echo "[-----] USER KEYS [-----]"
Get-ItemProperty Registry::\hku\*\software\microsoft\windows\currentversion\run;
Get-ItemProperty Registry::\hku\*\software\microsoft\windows\currentversion\runonce;

# this script's function is to output scheduled tasks, helping to check for persistence

$tasks = Get-ChildItem "C:\Windows\System32\Tasks" -Recurse

ForEach($task in $tasks){
    Write-Host "`r`n[+] Task: $task"
    Write-Host "-----------------------------------------------------`r`n"
    Get-Content $task -ErrorAction SilentlyContinue | Select-String -Pattern '<Command>' -SimpleMatch
}

#  Outputs a list of WMI subscription which we're able to check for persistence
Write-Host "`r`n[+] WMI Subscriptions:`r`n"
Write-Host "------------------------------"
Get-WmiObject -Namespace root/Subscription -Class __Eventfilter

# Output start menu contents for each user
Write-Host "`r`n[+] Startup Folder Contents:`r`n"
$path = 'C:\Users\*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Start-up\*'
Get-ChildItem $path | Where-Object {$_.name -ne 'desktop.ini'}

# Check for terminal services logon
Write-Host "`r`n[+]  Terminal Services Logons:`r`n"
Write-Host "----------------------------------`r`n"
$Before = Get-Date 2022/02/20
$After = Get-Date 2022/02/15

Get-WinEvent -FilterHashtable @{LogName='Security';StartTime=$After;EndTime=$Before; Id='4624'}|Where {$_.Message -match "Logon Type:\s+10"}|Select TimeCreated,Message


# Now, output a list of executables that have been written in the last day
Write-Host "`r`nRecently Written Files:`r`n"
Write-Host "---------------------------`r`n"

$recentFiles = Get-ChildItem -Path C:\ -Filter *.exe -Recurse -ErrorAction SilentlyContinue -Force|? {$_.LastWriteTime -gt (Get-Date).AddDays(-1)}

ForEach($file in $recentFiles){
    Write-Host $file.FullName
}

Write-Host "`r`nFiles with ADS:`r`n"
Write-Host "---------------------------`r`n"

$recentFiles = Get-ChildItem -Path C:\ -Filter *.exe -Recurse -ErrorAction SilentlyContinue -Force|? {$_.LastWriteTime -gt (Get-Date).AddDays(-1)}

ForEach($file in $recentFiles){
    Write-Host $file.FullName
}