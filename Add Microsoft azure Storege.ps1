$connectTestResult = Test-NetConnection -ComputerName User.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
# Save the password so the drive will persist on reboot
cmd.exe /C "cmdkey /add:`"User.file.core.windows.net`" /user:`"User`" /pass:`"********`""
# Mount the drive
New-PSDrive -Name Z -PSProvider FileSystem -Root "\\User.file.core.windows.net\getfiles" -Persist
} else {
Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}
