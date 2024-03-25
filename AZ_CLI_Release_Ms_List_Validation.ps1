param (
    [string]$User, [string]$Pass, [string]$organization, [string]$Team_Project, [string]$New_Master_Source, [string]$tenant, [string]$AgentPath, [string]$Ms_List, [string]$Repo_Branch_chk
)



az login -u $User -p $Pass -t $tenant --output none
az devops configure --defaults organization=$organization project=$Team_Project 


$MS_List = $AgentPath+$Ms_List
$Content = Get-Content -Path $MS_List
$repos = az repos list --project $Team_Project --query "[].{Name: name, ID: id}" --output json
$repos = $repos | Out-String | ConvertFrom-Json
foreach ($repoName in $Content){
    $Match_Repo = $repos.Name -contains $repoName
    if($Match_Repo -ne "True"){
        Write-Host "##[error]Error!!! The Repo is not correct: " $repoName
        exit
    }
    else{
        Write-Host "##[section] The Repo " $repoName " is OK!"
    }

}
$Branchs_list = az repos ref list --project $Team_Project --repository $Repo_Branch_chk --query "[].{Name: name}" --output json
$Branchs = $Branchs_list | Out-String | ConvertFrom-Json
foreach ( $Branch in $Branchs.Name) {
    if( $Branch -ieq $New_Master_Source){
        Write-Host "##[section] Found Branch:" $Branch " in Repo: " $repoName
    }
    else{
        exit
    }
}


az logout