param (
    [string]$build_sourcesdirectory, [string]$Service_Group_Restart
)

$serverListFilePath = "$build_sourcesdirectory\DevOps\Gac_Install\QA\BZ_Machines.txt"
$servers = Get-Content -Path $serverListFilePath

$servicesToRestart_XXXXX = @(
    'XXXXXXXXX',
    'XXXXXXXXX',
    'XXXXXXXXX',
    'XXXXXXXXX',
    'XXXXXXXXX'
)

$servicesToRestart_XXXXX = @(
    'XXXXXXXXX',
    'XXXXXXXXX',
    'XXXXXXXXX',
    'XXXXXXXXX',
    'XXXXXXXXX',
    'XXXXXXXXX',
    'XXXXXXXXX',
    'XXXXXXXXX'
)

$servicesToRestart_XXXXX = @(
    'XXXXXXXXX',
    'XXXXXXXXX',
    'XXXXXXXXX',
    'XXXXXXXXX'
)

$servicesToRestart_XXXXX = @(
    'XXXXXXXXX',
    'XXXXXXXXX',
    'XXXXXXXXX',
    'XXXXXXXXX',
    'XXXXXXXXX',
    'XXXXXXXXX'
)

$servicesToRestart_XXXXX = @(
    'XXXXXXXXX_1',
    'XXXXXXXXX_10',
    'XXXXXXXXX_11',
    'XXXXXXXXX_12',
    'XXXXXXXXX_2',
    'XXXXXXXXX_3',
    'XXXXXXXXX_4',
    'XXXXXXXXX_5',
    'XXXXXXXXX_6',
    'XXXXXXXXX_7',
    'XXXXXXXXX_8',
    'XXXXXXXXX_9'
)

$servicesToRestart_XXXXX = @(
    'XXXXXXXXX'
)

$servicesToRestart_None = @(
    "None"
)

function IsServiceRunning($serviceName, $serverName) {
    $service = Get-Service -Name $serviceName -ComputerName $serverName -ErrorAction SilentlyContinue
    if ($service -ne $null -and $service.Status -eq "Running") {
        return $true
    }
    else {
        return $false
    }
}



if ($Service_Group_Restart -ieq "XXXXX"){ $servicesToRestart = $servicesToRestart_XXXXX }
ElseIf ($Service_Group_Restart -ieq "XXXXX") { $servicesToRestart = $servicesToRestart_XXXXX }
ElseIf ($Service_Group_Restart -ieq "XXXXX") { $servicesToRestart = $servicesToRestart_XXXXX }
ElseIf ($Service_Group_Restart -ieq "XXXXX") { $servicesToRestart = $servicesToRestart_XXXXX }
ElseIf ($Service_Group_Restart -ieq "XXXXX") { $servicesToRestart = $servicesToRestart_XXXXX }
ElseIf ($Service_Group_Restart -ieq "XXXXX") { $servicesToRestart = $servicesToRestart_XXXXX }
ElseIf ($Service_Group_Restart -ieq "None") { $servicesToRestart = $servicesToRestart_None }

foreach ($server in $servers) {
    foreach ($serviceToRestart in $servicesToRestart) {
        if (IsServiceRunning -serviceName $serviceToRestart -serverName $server) {
            Write-Host "Restarting $serviceToRestart on $server"
            Invoke-Command -ComputerName $server -ScriptBlock { 
                param($serviceName)
                Stop-Service -Name $serviceName -Force
                sleep 4
                Start-Service -Name $serviceName
            } -ArgumentList $serviceToRestart
        }
        else {
            if ($serviceToRestart -ne "None") {
                Write-Host "$serviceToRestart is not running on $server"
            }
        }
    }
}
