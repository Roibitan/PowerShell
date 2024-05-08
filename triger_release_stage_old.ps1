$User = "XXXXXX@XXXXXX.XXXXXX.XXX"
$Pass = "XXXX"
$tenant = "XXXXXX-XXXXXX-XXXXXX-XXXXXX-XXXXXX"
$organization = "https://dev.azure.com/Project/"
$Team_Project = "XXXXXX"
$pat = "XXXXXX"
$org = "XXXXXX"
$Branch_name = "Branch1"
$Desired_stage = "QA"

#$credentials = Get-Credential -Message "Enter your credentials"
#$credentials.GetNetworkCredential().Password
#$credentials.UserName

$MS_List = "C:\Temp\Scripts\MicroServices.txt"
$Content = Get-Content -Path $MS_List

az login -u $User -p $Pass -t $tenant 
az devops configure --defaults organization=$organization project=$Team_Project 

foreach ($MicroService in $Content) {
    $release_id = az pipelines release definition list #--output table
    $News = $release_id | ConvertTo-Json
    $objects = $release_id | Out-String | ConvertFrom-Json
    foreach ($obj in $objects) {
        if( $obj.name -ieq $MicroService){
            $DEFINITION_ID = $obj.id
            Write-Host "The Release is:"
            $obj.name
            #$DEFINITION_ID
            $RELEASE_ID_Source = az pipelines release list --source-branch $Branch_name --org $organization --project $Team_Project --top 1 --definition-id $DEFINITION_ID --output json | ConvertFrom-Json
            $RELEASE_ID = $RELEASE_ID_Source.id
            #$RELEASE_ID
            $stages = az pipelines release show --id $RELEASE_ID --query "environments[].{id: id, name: name, Status: status}" --output json | ConvertFrom-Json
            foreach ($stage in $stages) {
                if ($Desired_stage -ieq $stage.name ){
                    Write-Host "the stage is:"
                    Write-Host $stage.id
                    $Stage_ID = $stage.id
                    #$Stage_ID
                    $URL1 = "https://vsrm.dev.azure.com/$org/$Team_Project/_apis/release/releases/$RELEASE_ID/environments/$Stage_ID"
                    $URL2 = "?api-version=6.0-preview.6"
                    $uri = $URL1+$URL2
                    #$uri = "https://vsrm.dev.azure.com/$org/$Team_Project/_apis/release/releases/$RELEASE_ID/environments/724?api-version=6.0-preview.6"

                    $body = @{
                        status = "inProgress"
                    } | ConvertTo-Json
                    
                    Invoke-RestMethod -Uri $uri -Method patch -Headers @{Authorization=("Basic {0}" -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($pat)")))} -ContentType "application/json" -Body $body
                }
            }
        }
    }
}