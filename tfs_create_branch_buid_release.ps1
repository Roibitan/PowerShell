$User = "XXXXXXXXX@XXXXXXXXX.XXXXXXXXX.XXXXXXXXX"
$Pass = "XXXXXXXXX"
$tenant = "XXXXXXXXX-XXXXXXXXX-XXXXXXXXX-XXXXXXXXX-XXXXXXXXX"
$organization = "https://dev.azure.com/XXXXXXXXX/"
$Team_Project = "CMTeam"
$pat = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
$org = "XXXXXXXXX"
$source_branch = "refs/heads/Dev"
############
$Target_stage = "QA"
$NewBranchName = "refs/heads/Release/Release_154"
$Branch_Name = "Release_154"
$Branch_Number = $Branch_Name -replace '[^\d]+', ''
############
$output_file = "D:\Scripts\Dev_Branch\Branch_Create_"+$Branch_Number+".txt"
$output_file_Build = "D:\Scripts\Dev_Branch\Build_started_"+$Branch_Number+".txt"
$output_file_Build_completed = "D:\Scripts\Dev_Branch\Build_completed_"+$Branch_Number+".txt"






$MS_List = "D:\Scripts\Dev_Branch\MicroServices.txt"
$Content = Get-Content -Path $MS_List

az login -u $User -p $Pass -t $tenant 
az devops configure --defaults organization=$organization project=$Team_Project 



## Create Branch in repo ##
foreach ($repository in $Content) {
    $Branchs = az repos ref list --project $Team_Project --repository $repository --query "[].{id: objectId, name: name}" --output json | ConvertFrom-Json
    #az repos ref list --project $Team_Project --repository $repository --query "[].{id: objectId, name: name}" --output table
    foreach ($Branch in $Branchs) {
        #Write-Host "Repository Name: $($Branch.Name)"
        if( $Branch.name -ieq $source_branch){
            Write-Host "################"
            Write-Host    $repository
            Write-Host "################"
            $BranchList_Release = az repos ref list --filter heads/ -r $repository -p $Team_Project --output json | ConvertFrom-Json
            foreach ($obj in $BranchList_Release) {
                if( $obj.name -ieq $source_branch){
                    $ReleaseBranchID = $obj.objectId
                }
            }

            $reposlist = az repos list --project $Team_Project --query "[].{Name: name, ID: id}" --output json
            $repos = $reposlist | Out-String | ConvertFrom-Json
            $e = $ErrorActionPreference
            $ErrorActionPreference="stop"
            foreach ($repo in $repos) {
                if ( $repo.Name -ieq $repository){
                    $repository_ID = $repo.ID   
                    try {
                        $policyConfigurations_az = az repos policy list --org $organization --project $Team_Project --repository-id $repository_ID --branch $source_branch --output json
                        #az repos policy list --organization $organization --project $Team_Project --repository-id $repository_ID --branch $source_branch --output json
                        $policyConfigurations = $policyConfigurations_az | Out-String | ConvertFrom-Json
                        $jsonData_az = az repos policy list --branch $source_branch --repository-id $repository_ID --output json 
                        $jsonData = $jsonData_az | Out-String | ConvertFrom-Json
                        # Create new Branch & Policy
                        write-host "##[debug] Creating $Branch_Name Branch"
                        az repos ref create --name $NewBranchName -p $Team_Project -r $repository --object-id $ReleaseBranchID
                        write-host "##[section] Finish Create $Branch_Name Branch" 
                        #pause
                        write-host "##[debug] Creating Policies"
                        for ($i = 0; $i -lt $jsonData.Length; $i++) {
                            $body = @($jsonData[$i]) | ConvertTo-Json -Depth 99
                            $body | Set-Content -Path C:\Temp\Branch_Policies.json
                            $jsonFilePath = "C:\Temp\Branch_Policies.json"
                            $jsonContent = Get-Content -Path $jsonFilePath -Raw
                            #$findString = "refs/heads/Dev"
                            #$replaceString = "refs/heads/Release_154"
                            $modifiedContent = $jsonContent -replace [regex]::Escape($source_branch), $NewBranchName
                            Set-Content -Path $jsonFilePath -Value $modifiedContent
                            Write-Output "String replacement complete."
                            az repos policy create --config C:\Temp\Branch_Policies.json #--output none
                            write-host "##[section] Finish Creating Policies" 
                            Write-Host "------------------------------------"
                            Write-Host "Branch '$NewBranchName' created successfully."
                            Write-Host "------------------------------------"
                            Add-Content -Path $output_file -Value \"Branch in $repository created successfully.\"
                        }
                        #Add Security Groups to branch
                        $tfs_project_info = az devops project show --project $Team_Project --org $organization --output json | ConvertFrom-Json
                        $tfs_project_id = $tfs_project_info.id
                        #$tfs_project_id

                        $repo = az repos list --query '[].{Name:name, Url:remoteUrl, ID:id}' --output json | ConvertFrom-Json
                        foreach ($repo_all in $repo) {
                            if( $repo_all.name -ieq $repository){
                                $repo_id = $repo_all.id
                                #$repo_id
                            }
                        }

                        $Name_spaces = az devops security permission namespace list --output json | ConvertFrom-Json
                        foreach ($Name_space in $Name_spaces) {
                            if( $Name_space.name -ieq "Git Repositories"){
                                $ID = $Name_space.namespaceId
                            }
                        }
                        
                        function hexify($string) {
                            return ($string | Format-Hex -Encoding Unicode | Select-Object -Expand Bytes | ForEach-Object { '{0:x2}' -f $_ }) -join ''
                        }


                        #$split = $Branch_Name.Split("/")
                        $split = $Branch_Name
                        $hexBranch = ($split | ForEach-Object { hexify -string $_ }) -join "/"
                        $token2 = "refs/heads/Release/$hexBranch"
                        $token3="repoV2"+"/"+$tfs_project_id+"/"+$repo_id+"/"+$token2
                        $security_groups = az devops security group list --org $organization --project $Team_Project --output json | ConvertFrom-Json
                        #az devops security group list --org $organization --project $Team_Project --output table
                        $security_groups = $security_groups.PsObject.Properties.value
                        foreach ($security_group in $security_groups) {
                            if( $security_group.principalName -ieq "[XXXXXXXXX]\Group name"){
                                $subject = $security_group.descriptor
                            }
                        }
                        
                        Write-Host "security permission 1"
                        az devops security permission update --id $ID --subject $subject --token $token3 --allow-bit 4
                        Write-Host "security permission 2"
                        az devops security permission update --id $ID --subject $subject --token $token3 --allow-bit 32768
                        Write-Host "security permission 3"
                        az devops security permission update --id $ID --subject $subject --token $token3 --allow-bit 128

                    } catch {
                        Write-Host "Error creating branch: $_"
                        Write-Host "------------------------------------"
                        Write-Host "Branch '$NewBranchName' didnt created."
                        Write-Host "------------------------------------"
                        Add-Content -Path $output_file -Value \"Branch in $repository not created.\"
                    }
                }
            }
        }
    }
}


pause


## Triger build for the new Branch ##
foreach ($repository in $Content) {  
    try {
        #Start-Sleep -Seconds 25
        az pipelines run --name $repository --branch $NewBranchName
        Write-Host "------------------------------------"
        Write-Host "Build '$repository' Started successfully."
        Write-Host "------------------------------------"
        Add-Content -Path $output_file_Build -Value \"Build $repository Started successfully.\"
    } catch {
        Write-Host "Error Starting Build: $_"
        Add-Content -Path $output_file_Build -Value \"Build $repository not Started. **** \"
    } 
}


pause


## Build seccess report ##
foreach ($repository in $Content) { 
    #az pipelines list --output table
    $Builds = az pipelines list --output json | ConvertFrom-Json
    foreach ($Build in $Builds) { 
        if( $Build.name -ieq $repository){
            $Build_ID = $Build.id
            #az pipelines runs list --branch $NewBranchName --pipeline-ids $Build_ID -p $Team_Project --top 1 --output table
            $Build_run = az pipelines runs list --branch $NewBranchName --pipeline-ids $Build_ID -p $Team_Project --top 1 --output json | ConvertFrom-Json
            $Build_Status = $Build_run.Status
            $Build_Result = $Build_run.Result
            $Build_run_ID = $Build_run.id
            $Build_Status_Loop = "Not_Run"
            $Build_run = az pipelines runs list --branch $NewBranchName --pipeline-ids $Build_ID -p $Team_Project --top 1 --output json | ConvertFrom-Json
            if ( $Build_Status -ieq "completed" -or "cancelling" -or "none" ){
                az pipelines runs list --branch $NewBranchName --pipeline-ids $Build_ID -p $Team_Project --top 1 --output table
                Write-Host "--------------------------------------------------------"
                Add-Content -Path $output_file_Build_completed -Value \"Build * $repository * Status - $Build_Status | Result - $Build_Result\"
            }
            else{
                if ( $Build_Status -ieq "inProgress" -or "notStarted" -or "postponed" ){
                    do {
                        $Build_Status_Loop = $Build_run.Status
                        az pipelines runs list --branch $NewBranchName --pipeline-ids $Build_ID -p $Team_Project --top 1 --output table
                        Write-Host "checking again"
                    }until ($Build_Status_Loop -ieq "completed" -or "cancelling" -or "none" -and $Build_run.id -ge $Build_run_ID )
                    Add-Content -Path $output_file_Build_completed -Value \"Build * $repository * Status - $Build_Status | Result - $Build_Result\"
                }
            }
        }
    } 
}


pause



## Triger Release from Build ##
foreach ($repository in $Content) { 
    $release_id = az pipelines release definition list --output json | ConvertFrom-Json
    #az pipelines release definition list --output table
    foreach ($obj in $release_id) {
        if( $obj.name -ieq $repository){
            $DEFINITION_ID = $obj.id
            Write-Host "The Release is:"
            $obj.name
            #$DEFINITION_ID 8
            $Build_Run_ID = az pipelines runs list --branch $NewBranchName --pipeline-ids $Build_ID -p $Team_Project --top 1 --output json | ConvertFrom-Json

            #az pipelines run --name $repository --branch $NewBranchName --output table
            $Release_info = "_"+$obj.name+"="+$Build_Run_ID.id

            az pipelines release create --definition-name $obj.name --artifact-metadata-list "$Release_info"
            #Write-Host "sleep 10 sec..."
            #Start-Sleep -Seconds 10
            $RELEASE_ID_Source = az pipelines release list --source-branch $NewBranchName --org $organization --top 1 --project $Team_Project --definition-id $DEFINITION_ID --output json | ConvertFrom-Json
            #az pipelines release list --source-branch $NewBranchName --org $organization --top 1 --project $Team_Project --definition-id $DEFINITION_ID --output table
            $Status = "continue" 
            foreach ($Release in $RELEASE_ID_Source) {
                $RELEASE_ID = $Release.id
                #$RELEASE_ID
                $stages = az pipelines release show --id $RELEASE_ID --query "environments[].{id: id, name: name, Status: status}" --output json | ConvertFrom-Json
                #az pipelines release show --id $RELEASE_ID --query "environments[].{id: id, name: name, Status: status}" --output table
                Write-Host "The Release ID is:"
                $RELEASE_ID
                foreach ($stage in $stages) {
                    Write-Host "The Stage is:"
                    Write-Host $stage
                    if ($stage.name -ieq $Target_stage ) {
                        $Stage_ID = $stage.id
                        Write-Host "The Release ID is:"
                        $RELEASE_ID
                        #$Stage_ID
                        $URL1 = "https://vsrm.dev.azure.com/$org/$Team_Project/_apis/release/releases/$RELEASE_ID/environments/$Stage_ID"
                        $URL2 = "?api-version=6.0-preview.6"
                        $uri = $URL1+$URL2
                        #$uri = "https://vsrm.dev.azure.com/$org/$Team_Project/_apis/release/releases/$RELEASE_ID/environments/724?api-version=6.0-preview.6"
            
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