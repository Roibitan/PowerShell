param (
    [string]$build_sourcesdirectory
)



$computerListFile = "$build_sourcesdirectory\DevOps\Gac_Install\QA\all_machines_qa.txt"
$computerList = Get-Content $computerListFile


$scriptBlock = {
    $result = powershell "C:\Install_dll\script\InstallGac.ps1"
    #$result = powershell "C:\Install_dll\script\Test.ps1"  
    return $result
}


foreach ($computerName in $computerList) {
    Write-Host "Executing script on $computerName"
    
    try {
        $result = Invoke-Command -ComputerName $computerName -ScriptBlock $scriptBlock -ErrorAction Stop
        Write-Host "Result from" $computerName
        Write-Output $result
        $res = $result
        if ($res.Contains("1")){
            Write-Host "$computerName failed to install "
            exit(1)
        }
        else{
            continue
        }
    } catch {
        Write-Host "Failed to execute script on $computerName. Error: $_"
    }
}
