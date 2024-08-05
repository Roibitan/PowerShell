#ÐŸÐ¾Ñ‡Ñ‚Ð° Ð² ÐºÐ¾Ñ‚Ð¾Ñ€Ð¾Ð¹ Ð¸Ñ‰ÐµÐ¼ Ð¿Ð¸ÑÑŒÐ¼Ð¾
$Mail = "Name@RRRROOOOIIIII!!!!!!.com"

#Ð’Ð²Ð¾Ð´ Ð¿Ð°Ñ€Ð¾Ð»Ñ
$SecurePassword = Read-Host "Enter password for mailbox" -AsSecureString
#$password = ""

#ÐŸÑƒÑ‚ÑŒ Ðº dll (ÐÐÐ”Ðž Ð£Ð¡Ð¢ÐÐÐžÐ’Ð˜Ð¢Ð¬ Microsoft Exchange Web Services Managed API 2.2)
$DLLpath = "C:\Program Files\Microsoft\Exchange\Web Services\2.2\Microsoft.Exchange.WebServices.dll"
[Reflection.Assembly]::LoadFile($DLLpath)

# Create a new Exchange service object 
$Service = New-Object Microsoft.Exchange.WebServices.Data.ExchangeService 

#Encode password
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
#These are your O365 credentials
$Service.Credentials = New-Object Microsoft.Exchange.WebServices.Data.WebCredentials($Mail,$PlainPassword)
#Deleting all passwords
$PlainPassword = $null, $BSTR = $null, $SecurePassword = $null

# Security check
$TestUrlCallback = {
    param ([string] $url)
    if ($url -eq "https://autodiscover-s.outlook.com/autodiscover/autodiscover.xml") {$true} else {$false}
}

# Autodiscover using the mail address set above
$Service.AutodiscoverUrl($Mail,$TestUrlCallback)

######################################################################################################################################################
$PropertySet = New-Object Microsoft.Exchange.WebServices.Data.PropertySet([Microsoft.Exchange.WebServices.Data.BasePropertySet]::FirstClassProperties)
# set email body to text
$PropertySet.RequestedBodyType = [Microsoft.Exchange.WebServices.Data.BodyType]::Text;
######################################################################################################################################################
#ÐŸÐ¾Ð¸ÑÐº Ð¿Ð°Ð¿ÐºÐ¸ Ð² ÐºÐ¾Ñ‚Ð¾Ñ€Ð¾Ð¹ Ð»ÐµÐ¶Ð°Ñ‚ Ð¿Ð¸ÑÑŒÐ¼Ð° (Ñƒ Ð¼ÐµÐ½Ñ ÑÑ‚Ð¾ Ð¿Ð°Ð¿ÐºÐ° Done)
$ffname = new-object Microsoft.Exchange.WebServices.Data.SearchFilter+ContainsSubstring([Microsoft.Exchange.WebServices.Data.FolderSchema]::DisplayName,"Done")

$fv = new-object Microsoft.Exchange.WebServices.Data.FolderView(20)
$fv.Traversal = "Deep"
######################################################################################################################################################
#Ð’Ñ‹Ð±Ð¾Ñ€ Ð¿Ð¾ÑÐ»ÐµÐ´Ð½ÐµÐ³Ð¾ Ð¿Ð¸ÑÑŒÐ¼Ð° Ð² Ð¿Ð°Ð¿ÐºÐµ Done
$folders = $Service.findFolders([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::MsgFolderRoot,$ffname, $fv)
$completedfolder = $folders.Folders[0]
$findResults = $completedfolder.FindItems(1)
$item = $findResults.Items
#Ð—Ð°Ð³Ñ€ÑƒÐ·ÐºÐ° Ð¿Ð¾ÑÐ»ÐµÐ´Ð½ÐµÐ³Ð¾ Ð¿Ð¸ÑÑŒÐ¼Ð°(Ð¿ÐµÑ€Ð²Ð¾Ð³Ð¾ ÑÐ²ÐµÑ€Ñ…Ñƒ) Ð¸Ð· Ð¿Ð°Ð¿ÐºÐ¸ Done
$item.Load($PropertySet)
#Ð¡Ð¾Ñ…Ñ€Ð°Ð½ÐµÐ½Ð¸Ðµ Ñ‚ÐµÐ»Ð° Ð¿Ð¸ÑÑŒÐ¼Ð° Ð² Ñ„Ð°Ð¹Ð»
Set-Content -Path C:\Temp\HRLastMail.txt -Value $($Item.Body.Text)
