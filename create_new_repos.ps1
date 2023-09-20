$organization = "https://XXXXX.XXXXX.com/XXXXX/"
$project = "XXXXX"
$User = "XXXXX@XXXXX.XXXXX.XXXXX"
$Pass = "XXXXX"


az login -u $User -p $Pass
az devops configure --defaults organization=$organization project=$project

$desiredRepoNames = @("repo1", "repo2", "repo3")

$existingRepoNames = az repos list --query "[].name" --output tsv

foreach ($repoName in $desiredRepoNames) {
    if ($repoName -notin $existingRepoNames) {
        az repos create --project $project --organization $organization --name $repoName
        Write-Host "Repository $repoName created."
    } else {
        Write-Host "Repository $repoName already exists in the project."
    }
}

az logout