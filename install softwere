

#$AD = Get-ADComputer -LDAPFilter "(name=*WS*)" -SearchBase "OU=Clients,OU=Computers,OU=Neogames,OU=Israel,DC=corp,DC=neogames-tech,DC=com"
#$computers = $AD.Name
$computers = "ws-bens-10"
foreach ($computer in $computers) {
$session = Enter-PSSession -ComputerName $computer 
if(-not($session)){
Write-host $computer,"Not connected"
}
else {
$Cisco = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName | findstr Cisco)
$computer
$Cisco |Format-List
} 
}

### Edit Host ###

Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n20.65.85.83`twww.roitest1.com" -Force
Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n20.65.85.83`twww.roitest2.com" -Force

###

### Install softwehre ###


#$computers = Get-Content -path "C:\temp\ILComputers.txt"
$computer = "WS-roib-10"
foreach ($computer in $computers) {

Invoke-Command -ComputerName $computer -ScriptBlock {Copy-Item -Path '\\corp\NETLOGON\BigFixClientRoi\BigFixAgent.msi' -Destination 'c:\temp\BigFixAgent.msi'}
Invoke-Command -ComputerName $computer -ScriptBlock {Start-Process c:\temp\BigFixAgent.msi #/q }
}
}


#Invoke-Command -ComputerName $computer -ScriptBlock {$software = "Fortinet Endpoint Detection and Response Platform";
#$Fortinet = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $software }) -ne $null
#$soft = "Symantec Endpoint Protection";
#$Symantec = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $soft }) -ne $null  
#write-Host $env:COMPUTERNAME
#Write-Host $Fortinet "Fortinet Endpoint Detection and Response Platform"
#Write-Host $Symantec "Symantec Endpoint Protection"
#
#
#
#
#
#
#
#
#
#$service = Get-Service -Name BESClient -ErrorAction SilentlyContinue
#if ($service.Length -gt 0) {
#
#    Write-Host "the service OK"
#
#} Else
#
#{
#Copy-Item -Path \\corp\NETLOGON\BigFixClientRoi\BigFixAgent.msi -Destination 'c:\windows\temp\BigFixAgent.msi'
#Start-Process c:\windows\temp\BigFixAgent.msi /q
#} 



### USB REGEDIT ###

Set-Itemproperty -path 'HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR' -Name 'Start' -value '3'
