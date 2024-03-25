param (
    [string]$User, [string]$Pass, [string]$organization, [string]$Team_Project, [string]$Old_Master_Name, [string]$New_Master_Source, [string]$tenant, [string]$AgentPath , [string]$Ms_List
)


az login -u $User -p $Pass -t $tenant --output none
az devops configure --defaults organization=$organization project=$Team_Project

$branch_name = "master"
$MS_List = $AgentPath+$Ms_List
$Content = Get-Content -Path $MS_List

foreach ($repoName in $Content)
{
    Write-Host "##[debug]++++++++++++++++++++++++++++++"
    Write-Host "##[debug]   $repoName   "
    Write-Host "##[debug]++++++++++++++++++++++++++++++"
    $BranchList = az repos ref list -r $repoName -p $Team_Project
    $null = $BranchList | ConvertTo-Json
    $objects = $BranchList | Out-String | ConvertFrom-Json
    foreach ($obj in $objects) {
        if( $obj.name -ieq $Old_Master_Name){
            $MasterBranchID = $obj.objectId
        }
    }

    # Create Backup from Master
    write-host "##[debug] Creating Backup from Master Branch"
    $time = $(get-date -f yyyy_MM_dd-HH_mm_s)
    $mastername = "refs/heads/master_"+$time
    az repos ref create --name $mastername -p $Team_Project -r $repoName --object-id $MasterBranchID
    $Backup_check = az repos ref list -r $repoName -p $Team_Project 
    $null = $Backup_check | ConvertTo-Json
    $Backup = $Backup_check | Out-String | ConvertFrom-Json
    $master_backup = $Backup.name -contains $mastername
    if( $master_backup -eq "True"){
        write-host "##[section] Create Backup Succeeded"
    }
    else{
        write-host "##[error] Create Backup Failed Terminate Process"
        exit
    }    
    #pause
    
    # extract branch id for new master
    foreach ($obj in $objects) {
    if( $obj.name -ieq $New_Master_Source){
        $ReleaseBranchID = $obj.objectId
        }
    }

    # Delete and Add policy to branch
    $reposlist = az repos list --project $Team_Project --query "[].{Name: name, ID: id}" --output json
    $repos = $reposlist | Out-String | ConvertFrom-Json
    #$repos = $reposlist | Out-String | ConvertFrom-Json
    foreach ($repo in $repos) {
        if ( $repo.Name -ieq $repoName){
            $repository_ID = $repo.ID
            # List all policy configurations for the specified branch
            $policyConfigurations_az = az repos policy list --org $organization --project $Team_Project --repository-id $repository_ID --branch $branch_name --output json
            $policyConfigurations = $policyConfigurations_az | Out-String | ConvertFrom-Json
            $jsonData_az = az repos policy list --branch $branch_name --repository-id $repository_ID --output json
            $jsonData = $jsonData_az | Out-String | ConvertFrom-Json
            # Delete Master Branch and export policy
            write-host "##[debug] Deleting" $repoName "Master Branch"
            az repos ref delete --name "refs/heads/master" --object-id $MasterBranchID --organization $organization --project $Team_Project --repository $repoName
            write-host "##[section] Finish Deleteing " $repoName
            #pause
            # Create new Master Branch & Policy
            write-host "##[debug] Creating New Master Branch"
            az repos ref create --name refs/heads/master -p $Team_Project -r $repoName --object-id $ReleaseBranchID
            write-host "##[section] Finish Create New Master Branch" 
            # Iterate through the policy configurations and delete them
            foreach ($policyConfiguration in $policyConfigurations) {
                $policyConfigurationId = $policyConfiguration.id
                foreach ($policy_ID in $policyConfiguration.id){
                    az repos policy delete --org $organization --project $Team_Project --id $policy_ID --yes
                }
            }
            #pause
            write-host "##[debug] Creating Policies"
            for ($i = 0; $i -lt $jsonData.Length; $i++) {
                $body = @($jsonData[$i]) | ConvertTo-Json -Depth 99
                $body | Set-Content -Path C:\Temp\Branch_Policies.json
                az repos policy create --config C:\Temp\Branch_Policies.json --output none
                write-host "##[section] Finish Creating Policies" 
            }
        }
    }
}

az logout