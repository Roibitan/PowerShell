$Processes = Get-Process Agent.Listener
$Agent = $Processes.ProcessName
if ($Agent -eq "Agent.Listener") {
    Write-Host "On"
}
else {
    cd C:\agents\CmsFront_Agent1
    .\run.cmd
}