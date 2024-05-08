param (
    [string]$VerNumber1, [string]$Old_Ver1
)



#$VerNumber1 = "v151"
#$Old_Ver1 = "v150"
$VerNumber2 = "_NET_4.0\"
$VerNumber = $VerNumber1+$VerNumber2
$Dll = "dll"
$Total_Dlls = "Total_Dlls"
$backup = "backup"
$serversFilePath = "C:\Github\PowerShell\Move_DLL_To_PROD.txt"

#$BT10PRDAPP1_QA
$BT10PRDAPP1_QA1 = "\\cellcom_nt\dfs02\Groups2\3_EAI_Transferred_To_Biztalk\BizTalk_QA\"
$BT10PRDAPP1_QA2 = "BT10PRDAPP1\"
$BT10PRDAPP1_QA = $BT10PRDAPP1_QA1+$VerNumber+$BT10PRDAPP1_QA2
#$BT10PRDAPP1_PROD
$BT10PRDAPP1_PROD1 = "\\cellcom_nt\dfs02\groups2\3_EAI_Transferred_To_Biztalk\BizTalk_Prod\"
$BT10PRDAPP1_PROD = $BT10PRDAPP1_PROD1+$VerNumber
#Old_Ver
$Old_Ver2 = $Old_Ver1+$VerNumber2
$BT10PRDAPP1_QA_Old = $BT10PRDAPP1_QA1+$Old_Ver2+$BT10PRDAPP1_QA2
#$BT10PRDAPP1_QA_NV
$BT10PRDAPP1_QA_NV1 = "\\cellcom_nt\dfs02\Groups2\3_EAI_Transferred_To_Biztalk\BizTalk_QA\"
$BT10PRDAPP1_QA_NV2 = "BT10PRDAPP1_NV\"
$BT10PRDAPP1_QA_NV = $BT10PRDAPP1_QA_NV1+$VerNumber+$BT10PRDAPP1_QA_NV2
#$BT10PRDAPP1_QA_NV_Old
$BT10PRDAPP1_QA_NV_Old = $BT10PRDAPP1_QA_NV1+$Old_Ver2+$BT10PRDAPP1_QA_NV2





$BT10PRDAPP1_QA_dll = $BT10PRDAPP1_QA+$Dll
$BT10PRDAPP1_QA_Old_dll = $BT10PRDAPP1_QA_Old+$Dll
#Copy-Item -Path $BT10PRDAPP1_QA_Old_dll -Destination $BT10PRDAPP1_QA_dll -ErrorAction Stop
Write-Host "$BT10PRDAPP1_QA_Old_dll copied successfully to $BT10PRDAPP1_QA_dll."
Write-Host " "

$BT10PRDAPP1_QA_NV_dll = $BT10PRDAPP1_QA_NV+$Dll
$BT10PRDAPP1_QA_NV_Old_dll = $BT10PRDAPP1_QA_NV_Old+$Dll
#Copy-Item -Path $BT10PRDAPP1_QA_NV_Old_dll -Destination $BT10PRDAPP1_QA_NV_dll -ErrorAction Stop
Write-Host "$BT10PRDAPP1_QA_NV_Old_dll copied successfully to $BT10PRDAPP1_QA_NV_dll."
Write-Host " "

$BT10PRDAPP1_QA_backup = $BT10PRDAPP1_QA+$backup+"\*"
#Remove-Item -Path $BT10PRDAPP1_QA_backup -Force -ErrorAction Stop
Write-Host "$BT10PRDAPP1_QA_backup Deleted successfully."
Write-Host " "

$BT10PRDAPP1_QA_backup = $BT10PRDAPP1_QA+$backup
#Copy-Item -Path $BT10PRDAPP1_QA_dll -Destination $BT10PRDAPP1_QA_backup -ErrorAction Stop
Write-Host "$BT10PRDAPP1_QA_backup copied successfully to $BT10PRDAPP1_QA_backup."
Write-Host " "

$BT10PRDAPP1_QA_NV_backup = $BT10PRDAPP1_QA_NV+$backup+"\*"
#Remove-Item -Path $BT10PRDAPP1_QA_NV_backup -Force -ErrorAction Stop
Write-Host "$BT10PRDAPP1_QA_NV_backup Deleted successfully."
Write-Host " "

$BT10PRDAPP1_QA_NV_backup = $BT10PRDAPP1_QA_NV+$backup
#Copy-Item -Path $BT10PRDAPP1_QA_NV_dll -Destination $BT10PRDAPP1_QA_NV_backup -ErrorAction Stop
Write-Host "$BT10PRDAPP1_QA_NV_dll copied successfully to $BT10PRDAPP1_QA_NV_backup."
Write-Host " "

$BT10PRDAPP1_PROD_Total_Dlls = $BT10PRDAPP1_PROD+$Total_Dlls
$BT10PRDAPP1_QA_NV_backup = $BT10PRDAPP1_QA_NV+$backup
#Copy-Item -Path $BT10PRDAPP1_QA_dll -Destination $BT10PRDAPP1_PROD_Total_Dlls -ErrorAction Stop
Write-Host "$BT10PRDAPP1_QA_dll copied successfully to $BT10PRDAPP1_PROD_Total_Dlls."
Write-Host " "

$BT10PRDAPP1_PROD_newgac = $BT10PRDAPP1_PROD+"Cel\newgac\*"
#Copy-Item -Path $BT10PRDAPP1_PROD_newgac -Destination $BT10PRDAPP1_PROD_Total_Dlls -ErrorAction Stop
Write-Host "$BT10PRDAPP1_PROD_newgac copied successfully to $BT10PRDAPP1_PROD_Total_Dlls."
Write-Host " "

$BT10PRDAPP1_PROD_Total_Dlls = $BT10PRDAPP1_PROD_Total_Dlls+"\*"
# Iterate over each server name in the text file
Get-Content $serversFilePath | ForEach-Object {
    $server = $_
    
    try {
        #Remove-Item -Path "\\$server\C:\Temp\moshero\Dll\*" -Force -ErrorAction Stop
        Write-Host "files deleted from $server successfully."
        #Copy-Item -Path $BT10PRDAPP1_PROD_Total_Dlls -Destination "\\$server\C:\Temp\moshero\Dll" -Force
        Write-Host "Item copied to $server successfully."
    } catch {
        Write-Host "Failed to copy item to $server. Error: $_"
    }
}

$BTservers = @("bt10prdapp1", "bt10prdapp2", "bt10prdapp3", "bt10prdapp4", "bt10mq")
$BT10PRDAPP1_PROD_NV = $BT10PRDAPP1_PROD+"NV\newgac\*"
foreach ($server in $BTservers) {
    try {
        #Copy-Item -Path $BT10PRDAPP1_PROD_NV -Destination "\\$server\C:\Temp\moshero\Dll" -Force -ErrorAction Stop
        Write-Host "Item copied to $server successfully."
    } catch {
        Write-Host "Failed to copy item to $server. Error: $_"
    }
}

#Copy-Item -Path "\\v-docprd1\c$\temp\moshero\dll_exception\EAI_Infrastructure_TaskManagement.dll" -Destination "\\v-docprd1\c$\temp\moshero\dll" -Force -ErrorAction Stop





































#$BT10PRDAPP1_PROD_NV = $BT10PRDAPP1_PROD+"NV\newgac\*"
#Copy-Item -Path $BT10PRDAPP1_PROD_newgac -Destination $BT10PRDAPP1_PROD_Total_Dlls -ErrorAction Stop
#Write-Host "$BT10PRDAPP1_PROD_NV copied successfully to $BT10PRDAPP1_PROD_Total_Dlls."
#Write-Host " "
