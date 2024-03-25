param (
    [string]$build_sourcesdirectory, [string]$Application_Pool_name_1, [string]$Application_Pool_name_2
)


$applicationPoolNames = $Application_Pool_name_1, $Application_Pool_name_2

$remoteComputers = "$build_sourcesdirectory\DevOps\Gac_Install\QA\all_machines_qa.txt"
$computerList = Get-Content $remoteComputers

foreach ($computer in $computerList) {
    $applicationPools = Invoke-Command -ComputerName $computer -ScriptBlock {
    Import-Module WebAdministration
    Get-ChildItem IIS:\AppPools | Select-Object Name
    }
    foreach ($Pool in $applicationPoolNames) {
        if ($applicationPools.name.Contains($Pool)){

            $maxRetries = 3
            $retryCount = 0
            do {
                $retryCount++
                try {
                    Invoke-Command -ComputerName $computer -ScriptBlock{
                    Param ($Pool)
                    stop-WebAppPool -Name $Pool
                    sleep 4
                    start-WebAppPool -Name $Pool} -ArgumentList $Pool
                    Write-Host "$Pool restart on computer $computer"
                    break
                }
                catch {
                    Write-Host "Error occurred while restarting application pool '$Pool'."
                    if ($retryCount -lt $maxRetries) {
                        Write-Host "Retrying..."
                        Start-Sleep -Seconds 5
                    }
                    else {
                        Write-Host "Maximum retries exceeded. Exiting..."
                        break
                    }
                }
            } while ($retryCount -lt $maxRetries)
        }
        else {
            if ($Pool -ne "None" ){
                Write-Host "Application pool '$Pool' not found on $computer."
            }
        }
    }
}