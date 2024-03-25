param (
    [string]$VerNumber, [string]$User_Folder, [string]$build_sourcesdirectory
)


$computerListFile = "$build_sourcesdirectory\DevOps\Gac_Install\QA\all_machines_qa.txt"



$computerList = Get-Content $computerListFile
$User_Folder = ($User_Folder.Split("@"))[0]
Write-Host "Copynig From User Folder: $User_Folder"
$VerPath = "\\XXXXXX\XXXXX\XXXX\XXXXX\"
$VerPath1 = "XXXXXX\XXXXX\XXXX\$User_Folder"
$VerPath2 = $VerNumber
$VerPath3 = $VerPath2+$VerPath1
$VerPath4 = $VerPath+$VerPath3+"\*"
$FileNames = Get-ChildItem -Path $VerPath4
$FileNamesList = $FileNames.Name
if ($FileNames -ne $null ){
    $allFilesDll = $true
    foreach ($file in $FileNames) {
        if ($file.Extension -ne ".dll") {
            Write-Host "File $($file.Name) does not have a .dll extension."
            $allFilesDll = $false
        }
    }
    if (-not $allFilesDll) {
        Write-Host "Terminating process because not all files have .dll extension."
        Exit(1)
    }
    else {
        Write-Host "All files have .dll extension. Proceeding with the rest of the script."
        Write-Host "Copy files: "
        $FileNamesList
        Write-Host " "
        Write-Host "Target Servers: "
    }
}
else {
    Write-Host "Terminating process because source folder $User_Folder is empty"
    Exit(1)
}


foreach ($computerName in $computerList) {
    Write-Host "Copy to $computerName"
    Copy-Item -Path $VerPath4 -Destination "\\$computerName\c$\Install_dll\dll\" -ErrorAction Stop -Force
}