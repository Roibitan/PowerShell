### autonticetion:
$User = "XXXXXXX@XXXXX.XXXX.XXX"
$Pass = "XXXXXXX"
$organization = "https://XXXXXXX.XXXXXXX.XXXXXXX/XXXXXXX/"
$tenant = "XXXXXXX-XXXXX-XXXXX-XXXXX-XXXXXXXXXXXXXX"

#### Azure project:
$project = "XXXXXXX"
$repository="XXXXXXX"

#### Repo & Branch
$Oldmastername = "refs/heads/master"
$newMastersource = "refs/heads/Branch1"
$branch_name = "master"


az login -u $User -p $Pass -t $tenant
az devops configure --defaults organization=$organization project=$project 

#$MS_List = $AgentPath+"\Jet_Project\MS_List.txt"
$MS_List = "C:\Users\XXXXXXX\Desktop\Azure_CLi\Repos.txt"
$Content = Get-Content -Path $MS_List

foreach ($repoName in $Content)
{
    Write-Host "+++++++++++++++"
    Write-Host "++   $repoName   ++"
    Write-Host "+++++++++++++++"
    $BranchList = az repos ref list -r $repoName -p $project
    $BranchList | ConvertTo-Json
    $objects = $BranchList | Out-String | ConvertFrom-Json
        foreach ($obj in $objects) {
            if( $obj.name -ieq $Oldmastername){
            $MasterBranchID = $obj.objectId
            }
        }

    # Create Backup from Master
    $time = $(get-date -f yyyy_MM_dd-HH_mm_s)
    $mastername = "refs/heads/master_"+$time
    az repos ref create --name $mastername -p $project -r $repoName --object-id $MasterBranchID

    # extract branch id for new master
    foreach ($obj in $objects) {
    if( $obj.name -ieq $newMastersource){
        $ReleaseBranchID = $obj.objectId
        }
    }

    # Delete and Add policy to branch
    $repos = az repos list --project $project --query "[].{Name: name, ID: id}" --output json | ConvertFrom-Json
    foreach ($repo in $repos) {
        if ( $repo.Name -ieq $repoName){
            $repository_ID = $repo.ID
            # List all policy configurations for the specified branch
            $policyConfigurations = az repos policy list --org $organization --project $project --repository-id $repository_ID --branch $branch_name --output json
            $jsonData = az repos policy list --branch $branch_name --repository-id $repository_ID | ConvertFrom-Json
            # Delete Master Branch and export policy
            az repos ref delete --name "refs/heads/master" --object-id $MasterBranchID --organization $organization --project $project --repository $repoName
            #pause
            # Create new Master Branch & Policy
            az repos ref create --name refs/heads/master -p $project -r $repoName --object-id $ReleaseBranchID
            # Iterate through the policy configurations and delete them
            foreach ($policyConfiguration in $policyConfigurations | ConvertFrom-Json) {
                $policyConfigurationId = $policyConfiguration.id
                foreach ($policy_ID in $policyConfiguration.id){
                    az repos policy delete --org $organization --project $project --id $policy_ID --yes
                }
            }
            #pause
            for ($i = 0; $i -lt $jsonData.Length; $i++) {
                $body = @($jsonData[$i]) | ConvertTo-Json -Depth 99
                $body | Set-Content -Path C:\Temp\Branch_Policies.json
                az repos policy create --config C:\Temp\Branch_Policies.json
            }
        }
    }
}

az logout