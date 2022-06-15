Enter-PSSession lap-shakedg-10
 


$session = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{B12744B8-5BB7-463a-B85E-BB7627E73002}" -Name "EnforceSingleLogon"

 

#$session = Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{B12744B8-5BB7-463a-B85E-BB7627E73002}" -Name "EnforceSingleLogon" -Value 0

 

$enforcelogin = $session.EnforceSingleLogon

 

$enforcelogin
if (1 -eq $enforcelogin)
{
Write-Host "This Computer supported only 1 session for logon user"
}
else 
{
Write-Host "This Computer supported multiple user session "
}
