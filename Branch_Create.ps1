$organization = "https://XXXXX.XXXXX.com/XXXXX/"
$project = "XXXXX"
$User = "XXXXX@XXXXX.XXXXX.XXXXX"
$Pass = "XXXXX"
$projectName = "XXXXX"
$repositoryName = "XXXXX"
$BranchIDfrom = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

az login -u $User -p $Pass
az devops configure --defaults organization=$organization project=$project

$desiredBranchNames = @("Branch1", "Branch2")

$existingBranchNames = az repos ref list --filter heads/ -r $repositoryName -p $projectName --query "[].name" --output tsv
$existingBranchNames = $existingBranchNames-replace"refs/heads/"

foreach ($BranchName in $desiredBranchNames) {
    if ($BranchName -notin $existingBranchNames) {
        az repos ref create --name heads/$BranchName -p $projectName -r $repositoryName --object-id $BranchIDfrom
        Write-Host "Branch $BranchName created."
    } else {
        Write-Host "Branch $BranchName already exists in the project."
    }
}

az logout