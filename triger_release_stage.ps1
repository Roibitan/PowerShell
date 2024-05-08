$User = "XXXXXXX@XXXXXXX.XXXXXXX.XXX"
$Pass = "XXXXXXX"
$tenant = "XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX"
$organization = "https://dev.azure.com/Project/"
$Team_Project = "XXXXXXX"
$pat = "XXXXXXX"
$org = "XXXXXXX"
$Branch_name = "refs/heads/Master"
$Target_stage = "QALIKE-RC"
$Source_Stage = "DEV2"


#$credentials = Get-Credential -Message "Enter your credentials"
#$credentials.GetNetworkCredential().Password
#$credentials.UserName

#$Pass = Read-Host -Prompt "Enter Password" #-AsSecureString

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
            $RELEASE_ID_Source = az pipelines release list --source-branch $Branch_name --org $organization --project $Team_Project --definition-id $DEFINITION_ID --output json | ConvertFrom-Json
            $Status = "continue" 
            foreach ($Release in $RELEASE_ID_Source) {
                $RELEASE_ID = $Release.id
                #$RELEASE_ID
                $stages = az pipelines release show --id $RELEASE_ID --query "environments[].{id: id, name: name, Status: status}" --output json | ConvertFrom-Json
                #$i = 0
                if ( $Status -ieq "Exit"){
                    Write-Host $Status
                    break
                }
                Write-Host "The Release ID is:"
                $RELEASE_ID
                foreach ($stage in $stages) {
                    #Write-Host "The Stage is:"
                    #Write-Host $stage
                    if ($stage.name -ieq $Source_Stage -and $stage.Status -ieq "Succeeded") {
                        foreach ($stage in $stages) {
                            if( $stage.name -ieq $Target_stage ) {
                                $Stage_ID = $stage.id
                                #Write-Host "The Release ID is:"
                                #$RELEASE_ID
                                #$Stage_ID
                                $URL1 = "https://vsrm.dev.azure.com/$org/$Team_Project/_apis/release/releases/$RELEASE_ID/environments/$Stage_ID"
                                $URL2 = "?api-version=6.0-preview.6"
                                $uri = $URL1+$URL2
    
                    
                                $body = @{
                                    status = "inProgress"
                                } | ConvertTo-Json
                                
                                Invoke-RestMethod -Uri $uri -Method patch -Headers @{Authorization=("Basic {0}" -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($pat)")))} -ContentType "application/json" -Body $body
                                $Status = "Exit"
                            }
                        }
                    }
                }
            }
        }
    }
}