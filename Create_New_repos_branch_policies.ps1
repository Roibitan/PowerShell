﻿$organization = "XXXX://XXXX.XXXX.XXXX/XXXXXXXX/"
$project = "XXXX"
$User = "XXXXXXXX@XXXX.XXXX.XXXX"
$Pass = "XXXX"
$desiredRepoNames = @("repo1", "repo2")
$BranchID = "XXXXXXXXXXXXXXXXXXXX"
$desiredBranchNames = @("Branch1", "Branch2")
$RepoPolicy = @("XXXXXXXXXXXX")


az login -u $User -p $Pass
az devops configure --defaults organization=$organization project=$project


if ([string]::IsNullOrEmpty($desiredRepoNames)){
Write-Host "No Repos to Create, Continue to Next stage..."
}
else{
    $existingRepoNames = az repos list --query "[].name" --output tsv

        foreach ($repoName in $desiredRepoNames) {
            if ($repoName -notin $existingRepoNames) {
                az repos create --project $project --organization $organization --name $repoName
                Write-Host "Repository $repoName created."
            } 
            else{
                Write-Host "Repository $repoName already exists in the project."
            }
        }

}
if ([string]::IsNullOrEmpty($desiredBranchNames)){
Write-Host "No Branches to Create, Continue to Next stage..."
}
else{
    $existingBranchNames = az repos ref list --filter heads/ -r $repositoryName -p $project --query "[].name" --output tsv
    $existingBranchNames = $existingBranchNames-replace"refs/heads/"
    
    foreach ($BranchName in $desiredBranchNames) {
        if ($BranchName -notin $existingBranchNames) {
            az repos ref create --name heads/$BranchName -p $project -r $repositoryName --object-id $BranchID
            Write-Host "Branch $BranchName created."
        } 
        else{
            Write-Host "Branch $BranchName already exists in the project."
        }
    }

}



az repos policy create --config C:\Users\XXXX\Desktop\Azure_CLi\branch-policies.json




az logout