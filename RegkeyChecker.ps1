﻿<#  This script's function is to output the registry values which malware may manipulate in order to
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