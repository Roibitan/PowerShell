param (
    [string]$build_sourcesdirectory, [string]$VerNumber, [string]$User_Folder, [string]$Deploy_To_Production
)

$computerListFile = "$build_sourcesdirectory\DevOps\Gac_Install\QA\all_machines_qa.txt"
$computerList = Get-Content $computerListFile
$User_Folder = ($User_Folder.Split("@"))[0]
$DllUser_folder = "\\XXXXXX\XXXXX\XXXX\XXXXXX"
$DllUser_folder_newgac = XXXXXX\XXXXX\XXXX\XXXXXX\"
$DllUser_folder_V = $DllUser_folder+$VerNumber+$DllUser_folder_newgac
$DllUser_folder_source = $DllUser_folder_V+$User_Folder
$Dll_Names = Get-ChildItem -Path $DllUser_folder_source -File 
$Dll_NAMES = $Dll_NAMES.Name

foreach ($Dll in $Dll_NAMES) {
    Write-Host "Create Backup to Dll: $Dll"
    $VerPath_3_EAI = \\XXXXXX\XXXXX\XXXX\XXXXXX\XXXXXXX
    $VerPath1 = "_XXXXX\XXXX\XXXXXX\$Dll"
    $VerPath2 = $VerNumber
    $VerPath3 = $VerPath2+$VerPath1
    $VerPath4 = $VerPath_3_EAI+$VerPath3
    $sourceFilePath = $VerPath4
    $directory = [System.IO.Path]::GetDirectoryName($sourceFilePath)
    $filename = [System.IO.Path]::GetFileNameWithoutExtension($sourceFilePath)
    $extension = [System.IO.Path]::GetExtension($sourceFilePath)
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $newFilename = "{0}_{1}{2}" -f $filename, $timestamp, $extension
    $newFilePath = Join-Path -Path $directory -ChildPath $newFilename

    $VerPath_QA = "\\XXXXXX\XXXXX\XXXX\XXXXXX"
    $VerPath_QA_newgac = XXXXXX\XXXXX\XXXX\XXXXXX\$User_Folder\*"
    $VerPath3_QA = $VerPath2+$VerPath_QA_newgac
    $VerPath4_QA = $VerPath_QA+$VerPath3_QA
    $sourceFilePath_Backup = $VerPath4_QA
    $New_Path_QA = "_XXXXX\XXXX\XXXXXX"
    $VerPath_QA_to = \\XXXXXX\XXXXX\XXXX\XXXXXX\XXXXXXX
    $New_Path_QA_des = $VerPath_QA_to+$VerPath2+$New_Path_QA

    $VerPath_PROD = "\\XXXXX\XXXX\XXXXXX\XXXXXX"
    $VerPath_PROD_newgac = XXXXXX\XXXXX\XXXX\XXXXXX\$User_Folder\*"
    $VerPath3_PROD = $VerPath2+$VerPath_PROD_newgac
    $VerPath4_PROD = $VerPath_PROD+$VerPath3_PROD
    $New_Path_PROD = "_NET_4.0\Cel\newgac"
    $New_Path_PROD_des = $VerPath_PROD+$VerPath2+$New_Path_PROD

    $number = [int]($VerNumber -replace '\D+')
    $number -= 1
    $newString = "v$number"
    $Mizdamnot_Path = "\\XXXXX\XXXX\XXXXXX\XXXXXX"
    $Mizdamnot_Ver = $newString+"_Mizdamnot"
    $Mizdamnot_file_Path = $Mizdamnot_Path+$Mizdamnot_Ver+"\Cel\newgac\"
    $MIZ_Mizdamnot_file_backup = $Mizdamnot_file_Path+"$Dll"
    $MIZ_directory = [System.IO.Path]::GetDirectoryName($MIZ_Mizdamnot_file_backup)
    $MIZ_filename = [System.IO.Path]::GetFileNameWithoutExtension($MIZ_Mizdamnot_file_backup)
    $MIZ_extension = [System.IO.Path]::GetExtension($MIZ_Mizdamnot_file_backup)
    $MIZ_timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $MIZ_newFilename = "{0}_{1}{2}" -f $MIZ_filename, $MIZ_timestamp, $MIZ_extension
    $MIZ_newFilePath = Join-Path -Path $MIZ_directory -ChildPath $MIZ_newFilename

    try {
        if ($Deploy_To_Production -match "Deploy_To_Production_") {
            Write-Host "Deployed to Production"
            Copy-Item -Path $sourceFilePath -Destination $newFilePath -ErrorAction Continue
            Write-Host "File $filename Backup successfully to $newFilePath."

            Copy-Item -Path $sourceFilePath_Backup -Destination $sourceFilePath - -Force
            Write-Host "File $filename copied successfully to $sourceFilePath."

            # Copy-Item -Path $sourceFilePath_Backup -Destination $New_Path_QA_des -ErrorAction Stop
            # Write-Host "File $filename copied successfully to $New_Path_QA_des."

            Copy-Item -Path $sourceFilePath_Backup -Destination $New_Path_PROD_des -ErrorAction Stop
            Write-Host "File $filename copied successfully to $New_Path_PROD_des."
            Write-Host " "
        }
        else {
            Write-Host "Deployed to Mizdamnot"
            Copy-Item -Path $MIZ_Mizdamnot_file_backup -Destination $MIZ_newFilePath -ErrorAction Continue
            Write-Host "File $MIZ_newFilename Backup successfully to $MIZ_newFilePath."
            Copy-Item -Path $sourceFilePath_Backup -Destination $Mizdamnot_file_Path -ErrorAction Stop -Force
            Write-Host "File $filename copied successfully to $Mizdamnot_file_Path."
            Write-Host " "
        }

    } 
    catch {
        Write-Host "Failed to copy the file.(Please check that the file exists or if its a new file) Error: $_" 
    }
}
foreach ($computerName in $computerList) {
    Write-Host "Clean Files From $computerName"
    try {
        Remove-Item -Path \\$computerName\c$\install_dll\dll\* -Force
    } 
    catch {
        Write-Host "Failed to Delete the files from:
        $computerName Error: $_" 
    }
}
Write-Host "Clean Files From:
$sourceFilePath_Backup" 
Remove-Item -Path $sourceFilePath_Backup -Force