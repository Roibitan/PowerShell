#################################################################################################################################################################################################################
# $MailHR	=
# $Employee	=
# $FirstName	=
# $LastName	=
# $Position	=
# $Department	=
# $Phone	=
# $BirthDay	=
# $CopyFromUser	=
# $StartDay	=
# $Login	=
# $LoginMail	=
# $MailAddress	=
# $Password	=
# $Password_SS	=
# $Proxys	=
# $CopyFromLogin	=
# $3CXNumber	=
#################################################################################################################################################################################################################
#	ARRAYS	#
$ArrMonthName = "NoMonth", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
$ArrTwoNumber = "00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"
$ArrOneNumber = "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"
#################################################################################################################################################################################################################
#This function searches in array
function findinarr ($array, $value) {
    for ($i=0; $i -lt $array.count;$i++) {
        if($array[$i] -eq $value){$i}
    }
}
#################################################################################################################################################################################################################
#################################################################################################################################################################################################################
#################################################################################################################################################################################################################
$b = Read-Host "Enter quantity of Last name's characters"
$3CXNumber = Read-Host "Enter 4-digt 3CX umber"

#Define path where to save mail
$MailHR = "C:\Temp\HRLastMail.txt"


#################################################################################################################
#######SAVE MAIL FROM HR TO TXT FILE#############################################################################
#################################################################################################################

#Почта в которой ищем письмо
$Mail = "User@XXXXXX.com"

#Ввод пароля
$SecurePassword = Read-Host "Enter password for mailbox" -AsSecureString
#$password = ""

Write-host "Reading and saving last HRs e-mail (it takes about 1 minute)..."

#Путь к dll (НАДО УСТАНОВИТЬ Microsoft Exchange Web Services Managed API 2.2)
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
#Поиск папки в которой лежат письма (у меня это папка Done)
$ffname = new-object Microsoft.Exchange.WebServices.Data.SearchFilter+ContainsSubstring([Microsoft.Exchange.WebServices.Data.FolderSchema]::DisplayName,"Done")

$fv = new-object Microsoft.Exchange.WebServices.Data.FolderView(20)
$fv.Traversal = "Deep"
######################################################################################################################################################
#Выбор последнего письма в папке Done
$folders = $Service.findFolders([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::MsgFolderRoot,$ffname, $fv)
$completedfolder = $folders.Folders[0]
$findResults = $completedfolder.FindItems(1)
$item = $findResults.Items
#Загрузка последнего письма(первого сверху) из папки Done
$item.Load($PropertySet)
#Сохранение тела письма в файл
Set-Content -Path $MailHR -Value $($Item.Body.Text)

Write-host "Mail saved."

#################################################################################################################
#######GET ALL INFORMATION FROM HR'S MAIL########################################################################
#################################################################################################################
Write-host "Getting all information from HRs e-mail..."

#Remove first 5 lines from HR's mail (Nameniuk or user like this could make some troubles)
(Get-Content $MailHR | Select-Object -Skip 5) | Set-Content $MailHR

# Get Names of new employee
$NameString = Get-Content $MailHR | Where-Object { $_.Contains("Name") }
#Get Name and last-name
$Employee = $NameString.Remove(0,6)
#Get First Name
$FirstName = $NameString.Split(" ")[1]
#Get Last Name
$LastName = $NameString.Split(" ")[2]

# Get Position
$Position = Get-Content $MailHR | Where-Object { $_.Contains("Position") }
$Position = $Position.Remove(0,10)

# Get Department
$Department = Get-Content $MailHR | Where-Object { $_.Contains("Department") }
$Department = $Department.Remove(0,12)

# Get Phone
$Phone = Get-Content $MailHR | Where-Object { $_.Contains("Cell Phone number") }
$Phone = $Phone.Split("+")[1]
$Phone = $Phone.TrimEnd(" ")
$Phone = $Phone.Insert(10, " ")
$Phone = $Phone.Insert(8, " ")
$Phone = $Phone.Insert(5, " ")
$Phone = $Phone.Insert(2, " ")
$Phone = $Phone.Insert(0, "+")
$Phone = $Phone.Substring(0,17)

# Get Birth Day
$BirthString = Get-Content $MailHR | Where-Object { $_.Contains("Birth") }
$BirthDay = $BirthString.Remove(0,12)

# Get "Permissions copy from"
$CopyFromUser = Get-Content $MailHR | Where-Object { $_.Contains("Permission") }
$CopyFromUser = $CopyFromUser.Remove(0,21)

# Get Start Day
$Starting = Get-Content $MailHR | Where-Object { $_.Contains("Starting") }
$Starting = $Starting.Remove(0,15)
$Starting = $Starting.Replace(", "," ")
$StartingArray = $Starting.Split()
$StartingMonth = $StartingArray[0]
$StartingDay = $StartingArray[1]
$StartingYear = $StartingArray[2]
#Converting moth name to month number
$MonthItem = findinarr $ArrMonthName "$StartingMonth"
$StartingMonth = $ArrTwoNumber[$MonthItem]
#Converting one digit day to two digit
$DayItem = findinarr $ArrOneNumber "$StartingDay"
$StartingDay = $ArrTwoNumber[$DayItem]
#Start Day is:
$StartDay = "$StartingDay.$StartingMonth.$StartingYear"

Write-host "All informtion from HRs e-mail have been saved."

#################################################################################################################
#######CREATE ADDITIONAL VARIABLES FOR ACCOUNT###################################################################
#################################################################################################################
Write-host "Addind additioanl information..."

# Get Login name
$bukva = $LastName.SubString(0,$b)
$Login = "$FirstName$bukva"

# Get Login Mail name
$LoginMail = "$Login" + "@neogames.com"

# Get Mail Address
$MailAddress = "$FirstName" + ".$LastName" + "@neogames.com"
$MailAddress = $MailAddress.ToLower()

# Get password
$Password = '123456$IT'
#SecureString password
$Password_SS = ConvertTo-SecureString -String $password -AsPlainText -Force

# Get set of proxy address
$Proxys = @("SMTP:$MailAddress","smtp:$LoginMail")

#Get CopyFromLogin
$CopyFromLogin = Get-ADUser -SearchBase 'OU=Users,OU=Neogames,OU=Ukraine,DC=corp,DC=neogames-tech,DC=com' -Filter * | Where -Property Name -eq $CopyFromUser
$CopyFromLogin = $CopyFromLogin.SamAccountName

Write-host "All information from e-mail is in script now.
Creating user..."

#################################################################################################################
#######CREATE USER IN ACTIVE DIRECTORY###########################################################################
#################################################################################################################

# Create user
New-ADUser -Name $Employee -GivenName $FirstName -Surname $LastName -SamAccountName $Login -UserPrincipalName $LoginMail -DisplayName $Employee -EmailAddress $MailAddress -City Kyiv -Company Neogames -Country UA -Department $Department -Office $3CXNumber -OfficePhone $Phone -PostalCode $BirthDay -Title $Position -Path "OU=Users,OU=Neogames,OU=Ukraine,DC=corp,DC=neogames-tech,DC=com" -AccountPassword $Password_SS -Enabled $true

# Complete fill Country (add "co" and "CountryCode" parameters)
Set-ADUser -Identity $Login -Add @{co="Ukraine"}
Set-ADUser -Identity $Login -Replace @{countrycode="804"}

# Add "ProxyAddress" parameter
Set-ADUser -Identity $Login -Add @{proxyaddresses=$Proxys}

# Add "ShowInAddressBook" parameter
#It doesn't work
#$siab = (Get-ADUser illiat -properties *).showinaddressbook
#And this works
$siab = @("CN=Default Global Address List,CN=All Global Address Lists,CN=Address Lists Container,CN=NeogamesExchange,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=corp,DC=neogames-tech,DC=com","CN=All Users,CN=All Address Lists,CN=Address Lists Container,CN=NeogamesExchange,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=corp,DC=neogames-tech,DC=com")
Set-ADUser -Identity $Login -Add @{showinaddressbook=$siab}

# Add "msExchUserAccountControl" parameter
Set-ADUser -Identity $Login -Add @{msExchUserAccountControl=0}

# Add New user to all relevant groups
#copy-paste process. Get-ADUser membership               | then selecting membership                       | and add it to the second user
Get-ADUser -Identity $CopyFromLogin -Properties MemberOf | Select-Object MemberOf -expandproperty MemberOf | Add-AdGroupMember -Members $Login

Write-host "User created."

#################################################################################################################
#######CREATE WELCOME SHEET######################################################################################
#################################################################################################################
Write-host "Creating welcome-sheet..."
#Создаем новый объект WORD
$word = New-Object -ComObject Word.Application

#Видимый режим вставки, по умолчанию FALSE
$word.Visible = $True

#Создаем новый документ
$doc = $word.Documents.Add()

#Выбираем открывшийся документ для работы
$Selection = $word.Selection

#Отступ сверху и снизу по 2 см, слева 3 см, справа 1.5 см (1 cm = 28.35 points)
$Selection.PageSetup.TopMargin = 56.7
$Selection.PageSetup.BottomMargin = 56.7
$Selection.PageSetup.LeftMargin = 85.05
$Selection.PageSetup.RightMargin = 42.525

#Интервал отступов сверху и снизу
$Selection.ParagraphFormat.SpaceBefore = 0
$Selection.ParagraphFormat.SpaceAfter = 0


#Выравнивание по центру
$Selection.ParagraphFormat.Alignment = 1
#Добавляем таблицу ЛОГОТИП
$Table = $Word.ActiveDocument.Tables.Add($Word.Selection.Range, 1, 1)
#Вставляем картинку в ячейку таблицы ($PSScriptRoot - директория где лежит скрипт и лого)
$Table.Cell(1,1).Range.InlineShapes.AddPicture("$PSScriptRoot\_NEO(LOGO).png")
#Конец таблицы, начать новую строку
$Selection.EndKey(6,0)


#Выравнивание по ширине
$Selection.ParagraphFormat.Alignment = 3
#Размер шрифта
$Selection.Font.Size = 12

#############
###ТАБЛИЦЫ###
#############

#Новый параграф
$Selection.TypeParagraph()
#Добавляем таблицу "Dear USER"
$Table = $Word.ActiveDocument.Tables.Add($Word.Selection.Range, 1, 1)
#Заполняем таблицу "Dear USER"
$Table.Cell(1,1).Range.Text = "Dear $EMPLOYEE,

We are happy to welcome you as a member of our team!
Please read the information below before you begin:"
$Table.Cell(1,1).Range.Font.Size = 14
$Table.Cell(1,1).Range.Font.Bold = $True
#Конец таблицы, начать новую строку
$Selection.EndKey(6, 0)

#Новый параграф
$Selection.TypeParagraph()
#Новый параграф
$Selection.TypeParagraph()
#Добавляем таблицу "Domain account details:"
$Table = $Word.ActiveDocument.Tables.Add($Word.Selection.Range, 5, 2)
#Заполняем таблицу "Domain account details"
$Table.Cell(1,1).Range.Text = "Domain account details:"
$Table.Cell(1,1).Range.Font.Bold = $True
$Table.Cell(1,1).Range.Font.Name = "Helvetica"
$Table.Cell(1,1).Range.Font.TextColor = 4408131
$Table.Cell(2,1).Range.Text = "Domain username:"
$Table.Cell(2,1).Range.ParagraphFormat.LeftIndent = 3
$Table.Cell(2,2).Range.Text = "$Login"
$Table.Cell(3,1).Range.Text = "Initial password:"
$Table.Cell(3,1).Range.ParagraphFormat.LeftIndent = 3
$Table.Cell(3,2).Range.Text = '123456$IT'
$Table.Cell(4,1).Range.Text = "(password has to be changed on first login)"
$Table.Cell(4,1).Range.ParagraphFormat.LeftIndent = 4
$Table.Cell(4,1).Range.Font.Italic = $True
$Table.Cell(5,1).Range.Text = "Domain name:"
$Table.Cell(5,1).Range.ParagraphFormat.LeftIndent = 3
$Table.Cell(5,2).Range.Text = "corp.neogames-tech.com"
#Конец таблицы, начать новую строку
$Selection.EndKey(6, 0)

#Новый параграф
$Selection.TypeParagraph()
#Новый параграф
$Selection.TypeParagraph()
#Добавляем таблицу "E-Mail account details"
$Table = $Word.ActiveDocument.Tables.Add($Word.Selection.Range, 5, 2)
#Заполняем таблицу "E-Mail account details"
$Table.Cell(1,1).Range.Text = "E-Mail account details:"
$Table.Cell(1,1).Range.Font.Bold = $True
$Table.Cell(1,1).Range.Font.Name = "Helvetica"
$Table.Cell(1,1).Range.Font.Color = 4408131
$Table.Cell(2,1).Range.Text = "Mail address:"
$Table.Cell(2,1).Range.ParagraphFormat.LeftIndent = 3
$Table.Cell(2,2).Range.Text = "$MailAddress"
$Table.Cell(3,1).Range.Text = "Login:"
$Table.Cell(3,1).Range.ParagraphFormat.LeftIndent = 3
$Table.Cell(3,2).Range.Text = "$LoginMail"
$Table.Cell(4,1).Range.Text = "Initial mailbox password:"
$Table.Cell(4,1).Range.ParagraphFormat.LeftIndent = 3
$Table.Cell(4,2).Range.Text = '123456$IT'
$Table.Cell(5,1).Range.Text = "Mail Web Access:"
$Table.Cell(5,1).Range.ParagraphFormat.LeftIndent = 3
$Table.Cell(5,2).Range.Text = "https://www.office.com/"
#Конец таблицы, начать новую строку
$Selection.EndKey(6, 0)

#Новый параграф
$Selection.TypeParagraph()
#Новый параграф
$Selection.TypeParagraph()
#Добавляем таблицу "IT HelpDesk mail address"
$Table = $Word.ActiveDocument.Tables.Add($Word.Selection.Range, 1, 2)
#Заполняем таблицу "IT HelpDesk mail address"
$Table.Cell(1,1).Range.Text = "IT HelpDesk mail address: "
$Table.Cell(1,1).Range.Font.Bold = $True
$Table.Cell(1,1).Range.Font.Name = "Helvetica"
$Table.Cell(1,1).Range.Font.Color = 4408131
$Table.Cell(1,2).Range.Text = "HelpDesk-UA@neogames.com"
#Конец таблицы, начать новую строку
$Selection.EndKey(6, 0)

#Новый параграф
$Selection.TypeParagraph()
#Новый параграф
$Selection.TypeParagraph()
#Добавляем таблицу "Common software and resources"
$Table = $Word.ActiveDocument.Tables.Add($Word.Selection.Range, 6, 2)
#Заполняем таблицу "Common software and resources"
$Table.Cell(1,1).Range.Text = "Common software and resources:"
$Table.Cell(1,1).Range.Font.Bold = $True
$Table.Cell(1,1).Range.Font.Name = "Helvetica"
$Table.Cell(1,1).Range.Font.Color = 4408131
$Table.Cell(2,1).Range.Text = "Mail client:"
$Table.Cell(2,1).Range.ParagraphFormat.LeftIndent = 3
$Table.Cell(2,2).Range.Text = "Microsoft Office Outlook"
$Table.Cell(3,1).Range.Text = "Communicator:"
$Table.Cell(3,1).Range.ParagraphFormat.LeftIndent = 3
$Table.Cell(3,2).Range.Text = "Microsoft Teams"
$Table.Cell(4,1).Range.Text = "Soft-Phone:"
$Table.Cell(4,1).Range.ParagraphFormat.LeftIndent = 3
$Table.Cell(4,2).Range.Text = "3CX"
$Table.Cell(5,1).Range.Text = "Human Resource Management System:"
$Table.Cell(5,1).Range.ParagraphFormat.LeftIndent = 3
$Table.Cell(5,2).Range.Text = "https://neogames.hurma.work/"
$Table.Cell(6,1).Range.Text = "Company portal (HR creates an account):"
$Table.Cell(6,1).Range.ParagraphFormat.LeftIndent = 3
$Table.Cell(6,2).Range.Text = "portal.neogames.com/login"
#Конец таблицы, начать новую строку
$Selection.EndKey(6, 0)

#Новый параграф
$Selection.TypeParagraph()
#Новый параграф
$Selection.TypeParagraph()
#Новый параграф
$Selection.TypeParagraph()
#Добавляем таблицу "Sincerely yours"
$Table = $Word.ActiveDocument.Tables.Add($Word.Selection.Range, 1, 1)
#Заполняем таблицу "Common software and resources"
$Table.Cell(1,1).Range.Text = "___________________________________________________________________________
Sincerely yours,
IT Department"
$Table.Cell(1,1).Range.Font.Bold = $True
#Конец таблицы, начать новую строку
$Selection.EndKey(6, 0)

################
###СОХРАНЕНИЕ###
################

#СохранитьКак указываем путь куда и имя файла
$doc.SaveAs([ref]"$PSScriptRoot\$EMPLOYEE.docx")

#Закрываем документ
$doc.Close()

#Закрываем приложение
$word.Quit()
Write-host "
Welcome sheet created."

#################################################################################################################
#######SENDING WELCOME SHEET#####################################################################################
#################################################################################################################
Write-host "Sending welcome sheet..."

$AdminMail = "AlexS@neogames.com"
$HelpdeskMail = "Helpdesk-UA@neogames.com"

$SubjectMail = "Welcome sheet for $EMPLOYEE."
$BodyMail = "Here is Welcome sheet for $EMPLOYEE."
$Attachments = "$PSScriptRoot\$EMPLOYEE.docx"

$secpasswd = ConvertTo-SecureString '123456$IT' -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ($HelpdeskMail, $secpasswd)

Send-MailMessage -From $HelpdeskMail -To $AdminMail -SmtpServer smtp.office365.com -Subject $SubjectMail -Body $BodyMail -BodyAsHTML -Attachments $Attachments -Credential $mycreds -Port 587 -UseSsl

Write-host "
Welcome sheet has been sent.

ALL DONE!
"

#################################################################################################################
#######VARIABLES#################################################################################################
#################################################################################################################

$MailHR
$Employee
$FirstName
$LastName
$Position
$Department
$Phone
$BirthDay
$CopyFromUser
$StartDay
$Login
$LoginMail
$MailAddress
$Password
$Password_SS
$Proxys
$CopyFromLogin	
