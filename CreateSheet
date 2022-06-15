$EMPLOYEE = Read-Host "Enter employee's full name"
$b = Read-Host "Enter number of characters of lastname"

$FirstName = $EMPLOYEE.Split(" ")[0]
$LastName = $EMPLOYEE.Split(" ")[1]

$bukva = $LastName.SubString(0,$b)
$Login = "$FirstName$bukva"
$LoginMail = "$Login" + "@neogames.com"

$MailAddress = "$FirstName" + ".$LastName" + "@neogames.com"
$MailAddress = $MailAddress.ToLower()

#Ð¡Ð¾Ð·Ð´Ð°ÐµÐ¼ Ð½Ð¾Ð²Ñ‹Ð¹ Ð¾Ð±ÑŠÐµÐºÑ‚ WORD
$word = New-Object -ComObject Word.Application

#Ð’Ð¸Ð´Ð¸Ð¼Ñ‹Ð¹ Ñ€ÐµÐ¶Ð¸Ð¼ Ð²ÑÑ‚Ð°Ð²ÐºÐ¸, Ð¿Ð¾ ÑƒÐ¼Ð¾Ð»Ñ‡Ð°Ð½Ð¸ÑŽ FALSE
$word.Visible = $True

#Ð¡Ð¾Ð·Ð´Ð°ÐµÐ¼ Ð½Ð¾Ð²Ñ‹Ð¹ Ð´Ð¾ÐºÑƒÐ¼ÐµÐ½Ñ‚
$doc = $word.Documents.Add()

#Ð’Ñ‹Ð±Ð¸Ñ€Ð°ÐµÐ¼ Ð¾Ñ‚ÐºÑ€Ñ‹Ð²ÑˆÐ¸Ð¹ÑÑ Ð´Ð¾ÐºÑƒÐ¼ÐµÐ½Ñ‚ Ð´Ð»Ñ Ñ€Ð°Ð±Ð¾Ñ‚Ñ‹
$Selection = $word.Selection

#ÐžÑ‚ÑÑ‚ÑƒÐ¿ ÑÐ²ÐµÑ€Ñ…Ñƒ Ð¸ ÑÐ½Ð¸Ð·Ñƒ Ð¿Ð¾ 2 ÑÐ¼, ÑÐ»ÐµÐ²Ð° 3 ÑÐ¼, ÑÐ¿Ñ€Ð°Ð²Ð° 1.5 ÑÐ¼ (1 cm = 28.35 points)
$Selection.PageSetup.TopMargin = 56.7
$Selection.PageSetup.BottomMargin = 56.7
$Selection.PageSetup.LeftMargin = 85.05
$Selection.PageSetup.RightMargin = 42.525

#Ð˜Ð½Ñ‚ÐµÑ€Ð²Ð°Ð» Ð¾Ñ‚ÑÑ‚ÑƒÐ¿Ð¾Ð² ÑÐ²ÐµÑ€Ñ…Ñƒ Ð¸ ÑÐ½Ð¸Ð·Ñƒ
$Selection.ParagraphFormat.SpaceBefore = 0
$Selection.ParagraphFormat.SpaceAfter = 0


#Ð’Ñ‹Ñ€Ð°Ð²Ð½Ð¸Ð²Ð°Ð½Ð¸Ðµ Ð¿Ð¾ Ñ†ÐµÐ½Ñ‚Ñ€Ñƒ
$Selection.ParagraphFormat.Alignment = 1
#Ð”Ð¾Ð±Ð°Ð²Ð»ÑÐµÐ¼ Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñƒ Ð›ÐžÐ“ÐžÐ¢Ð˜ÐŸ
$Table = $Word.ActiveDocument.Tables.Add($Word.Selection.Range, 1, 1)
#Ð’ÑÑ‚Ð°Ð²Ð»ÑÐµÐ¼ ÐºÐ°Ñ€Ñ‚Ð¸Ð½ÐºÑƒ Ð² ÑÑ‡ÐµÐ¹ÐºÑƒ Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñ‹ ($PSScriptRoot - Ð´Ð¸Ñ€ÐµÐºÑ‚Ð¾Ñ€Ð¸Ñ Ð³Ð´Ðµ Ð»ÐµÐ¶Ð¸Ñ‚ ÑÐºÑ€Ð¸Ð¿Ñ‚ Ð¸ Ð»Ð¾Ð³Ð¾)
$Table.Cell(1,1).Range.InlineShapes.AddPicture("$PSScriptRoot\_NEO(LOGO).png")
#ÐšÐ¾Ð½ÐµÑ† Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñ‹, Ð½Ð°Ñ‡Ð°Ñ‚ÑŒ Ð½Ð¾Ð²ÑƒÑŽ ÑÑ‚Ñ€Ð¾ÐºÑƒ
$Selection.EndKey(6,0)


#Ð’Ñ‹Ñ€Ð°Ð²Ð½Ð¸Ð²Ð°Ð½Ð¸Ðµ Ð¿Ð¾ ÑˆÐ¸Ñ€Ð¸Ð½Ðµ
$Selection.ParagraphFormat.Alignment = 3
#Ð Ð°Ð·Ð¼ÐµÑ€ ÑˆÑ€Ð¸Ñ„Ñ‚Ð°
$Selection.Font.Size = 12

#############
###Ð¢ÐÐ‘Ð›Ð˜Ð¦Ð«###
#############

#ÐÐ¾Ð²Ñ‹Ð¹ Ð¿Ð°Ñ€Ð°Ð³Ñ€Ð°Ñ„
$Selection.TypeParagraph()
#Ð”Ð¾Ð±Ð°Ð²Ð»ÑÐµÐ¼ Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñƒ "Dear USER"
$Table = $Word.ActiveDocument.Tables.Add($Word.Selection.Range, 1, 1)
#Ð—Ð°Ð¿Ð¾Ð»Ð½ÑÐµÐ¼ Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñƒ "Dear USER"
$Table.Cell(1,1).Range.Text = "Dear $EMPLOYEE,

We are happy to welcome you as a member of our team!
Please read the information below before you begin:"
$Table.Cell(1,1).Range.Font.Size = 14
$Table.Cell(1,1).Range.Font.Bold = $True
#ÐšÐ¾Ð½ÐµÑ† Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñ‹, Ð½Ð°Ñ‡Ð°Ñ‚ÑŒ Ð½Ð¾Ð²ÑƒÑŽ ÑÑ‚Ñ€Ð¾ÐºÑƒ
$Selection.EndKey(6, 0)

#ÐÐ¾Ð²Ñ‹Ð¹ Ð¿Ð°Ñ€Ð°Ð³Ñ€Ð°Ñ„
$Selection.TypeParagraph()
#ÐÐ¾Ð²Ñ‹Ð¹ Ð¿Ð°Ñ€Ð°Ð³Ñ€Ð°Ñ„
$Selection.TypeParagraph()
#Ð”Ð¾Ð±Ð°Ð²Ð»ÑÐµÐ¼ Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñƒ "Domain account details:"
$Table = $Word.ActiveDocument.Tables.Add($Word.Selection.Range, 5, 2)
#Ð—Ð°Ð¿Ð¾Ð»Ð½ÑÐµÐ¼ Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñƒ "Domain account details"
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
#ÐšÐ¾Ð½ÐµÑ† Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñ‹, Ð½Ð°Ñ‡Ð°Ñ‚ÑŒ Ð½Ð¾Ð²ÑƒÑŽ ÑÑ‚Ñ€Ð¾ÐºÑƒ
$Selection.EndKey(6, 0)

#ÐÐ¾Ð²Ñ‹Ð¹ Ð¿Ð°Ñ€Ð°Ð³Ñ€Ð°Ñ„
$Selection.TypeParagraph()
#ÐÐ¾Ð²Ñ‹Ð¹ Ð¿Ð°Ñ€Ð°Ð³Ñ€Ð°Ñ„
$Selection.TypeParagraph()
#Ð”Ð¾Ð±Ð°Ð²Ð»ÑÐµÐ¼ Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñƒ "E-Mail account details"
$Table = $Word.ActiveDocument.Tables.Add($Word.Selection.Range, 5, 2)
#Ð—Ð°Ð¿Ð¾Ð»Ð½ÑÐµÐ¼ Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñƒ "E-Mail account details"
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
#ÐšÐ¾Ð½ÐµÑ† Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñ‹, Ð½Ð°Ñ‡Ð°Ñ‚ÑŒ Ð½Ð¾Ð²ÑƒÑŽ ÑÑ‚Ñ€Ð¾ÐºÑƒ
$Selection.EndKey(6, 0)

#ÐÐ¾Ð²Ñ‹Ð¹ Ð¿Ð°Ñ€Ð°Ð³Ñ€Ð°Ñ„
$Selection.TypeParagraph()
#ÐÐ¾Ð²Ñ‹Ð¹ Ð¿Ð°Ñ€Ð°Ð³Ñ€Ð°Ñ„
$Selection.TypeParagraph()
#Ð”Ð¾Ð±Ð°Ð²Ð»ÑÐµÐ¼ Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñƒ "IT HelpDesk mail address"
$Table = $Word.ActiveDocument.Tables.Add($Word.Selection.Range, 1, 2)
#Ð—Ð°Ð¿Ð¾Ð»Ð½ÑÐµÐ¼ Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñƒ "IT HelpDesk mail address"
$Table.Cell(1,1).Range.Text = "IT HelpDesk mail address: "
$Table.Cell(1,1).Range.Font.Bold = $True
$Table.Cell(1,1).Range.Font.Name = "Helvetica"
$Table.Cell(1,1).Range.Font.Color = 4408131
$Table.Cell(1,2).Range.Text = "HelpDesk-UA@neogames.com"
#ÐšÐ¾Ð½ÐµÑ† Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñ‹, Ð½Ð°Ñ‡Ð°Ñ‚ÑŒ Ð½Ð¾Ð²ÑƒÑŽ ÑÑ‚Ñ€Ð¾ÐºÑƒ
$Selection.EndKey(6, 0)

#ÐÐ¾Ð²Ñ‹Ð¹ Ð¿Ð°Ñ€Ð°Ð³Ñ€Ð°Ñ„
$Selection.TypeParagraph()
#ÐÐ¾Ð²Ñ‹Ð¹ Ð¿Ð°Ñ€Ð°Ð³Ñ€Ð°Ñ„
$Selection.TypeParagraph()
#Ð”Ð¾Ð±Ð°Ð²Ð»ÑÐµÐ¼ Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñƒ "Common software and resources"
$Table = $Word.ActiveDocument.Tables.Add($Word.Selection.Range, 6, 2)
#Ð—Ð°Ð¿Ð¾Ð»Ð½ÑÐµÐ¼ Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñƒ "Common software and resources"
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
#ÐšÐ¾Ð½ÐµÑ† Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñ‹, Ð½Ð°Ñ‡Ð°Ñ‚ÑŒ Ð½Ð¾Ð²ÑƒÑŽ ÑÑ‚Ñ€Ð¾ÐºÑƒ
$Selection.EndKey(6, 0)

#ÐÐ¾Ð²Ñ‹Ð¹ Ð¿Ð°Ñ€Ð°Ð³Ñ€Ð°Ñ„
$Selection.TypeParagraph()
#ÐÐ¾Ð²Ñ‹Ð¹ Ð¿Ð°Ñ€Ð°Ð³Ñ€Ð°Ñ„
$Selection.TypeParagraph()
#ÐÐ¾Ð²Ñ‹Ð¹ Ð¿Ð°Ñ€Ð°Ð³Ñ€Ð°Ñ„
$Selection.TypeParagraph()
#Ð”Ð¾Ð±Ð°Ð²Ð»ÑÐµÐ¼ Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñƒ "Sincerely yours"
$Table = $Word.ActiveDocument.Tables.Add($Word.Selection.Range, 1, 1)
#Ð—Ð°Ð¿Ð¾Ð»Ð½ÑÐµÐ¼ Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñƒ "Common software and resources"
$Table.Cell(1,1).Range.Text = "___________________________________________________________________________
Sincerely yours,
IT Department"
$Table.Cell(1,1).Range.Font.Bold = $True
#ÐšÐ¾Ð½ÐµÑ† Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñ‹, Ð½Ð°Ñ‡Ð°Ñ‚ÑŒ Ð½Ð¾Ð²ÑƒÑŽ ÑÑ‚Ñ€Ð¾ÐºÑƒ
$Selection.EndKey(6, 0)

################
###Ð¡ÐžÐ¥Ð ÐÐÐ•ÐÐ˜Ð•###
################

#Ð¡Ð¾Ñ…Ñ€Ð°Ð½Ð¸Ñ‚ÑŒÐšÐ°Ðº ÑƒÐºÐ°Ð·Ñ‹Ð²Ð°ÐµÐ¼ Ð¿ÑƒÑ‚ÑŒ ÐºÑƒÐ´Ð° Ð¸ Ð¸Ð¼Ñ Ñ„Ð°Ð¹Ð»Ð°
$doc.SaveAs([ref]"$PSScriptRoot\$EMPLOYEE.docx")

#Ð—Ð°ÐºÑ€Ñ‹Ð²Ð°ÐµÐ¼ Ð´Ð¾ÐºÑƒÐ¼ÐµÐ½Ñ‚
$doc.Close()

#Ð—Ð°ÐºÑ€Ñ‹Ð²Ð°ÐµÐ¼ Ð¿Ñ€Ð¸Ð»Ð¾Ð¶ÐµÐ½Ð¸Ðµ
$word.Quit()
