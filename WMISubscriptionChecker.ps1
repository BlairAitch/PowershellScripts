﻿#  Outputs a list of WMI subscription which we're able to check for persistence
Write-Host "`r`n[+] WMI Subscriptions:`r`n"
Write-Host "------------------------------"
Get-WmiObject -Namespace root/Subscription -Class __Eventfilter