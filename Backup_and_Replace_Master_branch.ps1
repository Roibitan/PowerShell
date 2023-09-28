param (
    [string]$User, [string]$Pass, [string]$organization, [string]$project, [string]$Oldmastername, [string]$newMastersource, [string]$tenant, [string]$AgentPath
)

#az repos ref list -r $repoName -p $project -o table

az login -u $User -p $Pass -t $tenant
az devops configure --defaults organization=$organization project=$project 


$MS_List = $AgentPath+"\Jet_Project\MS_List.txt"
$Content = Get-Content -Path $MS_List

foreach ($repoName in $Content)
{
    $BranchList = az repos ref list -r $repoName -p $project
    $BranchList | ConvertTo-Json
    $objects = $BranchList | Out-String | ConvertFrom-Json
        foreach ($obj in $objects) {
            if( $obj.name -ieq $Oldmastername){
            $MasterBranchID = $obj.objectId
            }
        }

    # Create Master Backup
    $time = $(get-date -f yyyy_MM_dd-HH_mm_s)
    $mastername = "refs/heads/master_"+$time
    az repos ref create --name $mastername -p $project -r $repoName --object-id $MasterBranchID

    # Delete Master Branch
    az repos ref delete --name "refs/heads/master" --object-id $MasterBranchID --organization $organization --project $project --repository $repoName 

    foreach ($obj in $objects) {
    if( $obj.name -ieq $newMastersource){
        $ReleaseBranchID = $obj.objectId
        }
    }

    # Create Master Branch
    az repos ref create --name refs/heads/master -p $project -r $repoName --object-id $ReleaseBranchID

}

az logout