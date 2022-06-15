Import-Module activeDirectory
$computers = Get-ADComputer -Filter * -SearchBase "OU=Clients,OU=Computers,OU=Neogames,OU=Israel,DC=corp,DC=neogames-tech,DC=com" | Select-Object -ExpandProperty Name
#$computers = 'VM-ARIELK-10'
foreach ($computer in $computers) {
Invoke-Command -ComputerName $computer -ScriptBlock {$software = "Fortinet Endpoint Detection and Response Platform";
$Fortinet = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $software }) -ne $null
$soft = "Symantec Endpoint Protection";
$Symantec = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $soft }) -ne $null  
write-Host $env:COMPUTERNAME
Write-Host $Fortinet "Fortinet Endpoint Detection and Response Platform"
Write-Host $Symantec "Symantec Endpoint Protection"

#Add-Content -Path C:\FortiEDR.txt -Value $computer , $Fortinet , $Symantec

}
}

#| Out-File "C:\FortiEDR.txt"
