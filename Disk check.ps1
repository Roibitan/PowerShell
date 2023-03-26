# Drives to check: set to $null or empty to check all local (non-network) drives

# $drives = @("C","D");

$drives = $null;

 

# The minimum disk size to check for raising the warning

$minSize = 10GB;

 

# SMTP configuration: username, password & so on

#$email_username = "username@yourdomain.com";

#$email_password = "yourpassword";

$email_smtp_host = "mailSMTP.XXX.COM";

$email_smtp_port = 25;

$email_smtp_SSL = 0;

$email_from_address = "Diskspeace@XXX.COM";

$email_to_addressArray = @("Mail@XXX.COM");

 

 

if ($drives -eq $null -Or $drives -lt 1) {

    $localVolumes = Get-WMIObject win32_volume;

    $drives = @();

    foreach ($vol in $localVolumes) {

        if ($vol.DriveType -eq 3 -And $vol.DriveLetter -ne $null ) {

            $drives += $vol.DriveLetter[0];

        }

    }

}

foreach ($d in $drives) {

    Write-Host ("`r`n");

    Write-Host ("Checking drive " + $d + " ...");

    $disk = Get-PSDrive $d;

    if ($disk.Free -lt $minSize) {

        Write-Host $disk.Free

        $FFF = $disk.Free / 1GB

        $FreeGiga = $FFF.ToString(".00")

        $MinSizeGiga = $minSize / 1GB

        Write-Host ("Drive " + $d + " has less than " + $minSize `

            + " bytes free (" + $disk.free + "): sending e-mail...");

       

        $message = new-object Net.Mail.MailMessage;

        $message.From = $email_from_address;

        foreach ($to in $email_to_addressArray) {

            $message.To.Add($to);

        }

        $message.Subject =  ("[RunningLow] WARNING: " + $env:computername + " drive " + $d);

        $message.Subject += (" has less than " + $MinSizeGiga + " Gigabytes free ");

        $message.Subject += ("(" + $FreeGiga + ")");

        $message.Body =     "Hello there, `r`n`r`n";

        $message.Body +=    "this is an automatic e-mail message ";

        $message.Body +=    "sent by RunningLow Powershell script ";

        $message.Body +=    ("to inform you that " + $env:computername + " drive " + $d + " ");

        $message.Body +=    "is running low on free space. `r`n`r`n";

        $message.Body +=    "--------------------------------------------------------------";

        $message.Body +=    "`r`n";

        $message.Body +=    ("Machine HostName: " + $env:computername + " `r`n");

        $message.Body +=    "Machine IP Address(es): ";

        $ipAddresses = Get-NetIPAddress -AddressFamily IPv4;

        foreach ($ip in $ipAddresses) {

            if ($ip.IPAddress -like "127.0.0.1") {

                continue;

            }

            $message.Body += ($ip.IPAddress + " ");

        }

        $message.Body +=    "`r`n";

        ###### Switch to GB #####

        $diskGiga = $disk.Used / 1GB

        $diskFree = $disk.Free / 1GB

        $message.Body +=    ("Used space on drive " + $d + ": " + $diskGiga.ToString(".00") + " Gigabytes. `r`n");

        $message.Body +=    ("Free space on drive " + $d + ": " + $diskFree.ToString(".00") + " Gigabytes. `r`n");

        $message.Body +=    "--------------------------------------------------------------";

        $message.Body +=    "`r`n`r`n";

        $message.Body +=    "This warning will fire when the free space is lower ";

        $message.Body +=    ("than " + $MinSizeGiga + " Gigabytes `r`n`r`n");

        $message.Body +=    "Sincerely, `r`n`r`n";

        $message.Body +=    "DevOps Team `r`n";

 

 

        $smtp = new-object Net.Mail.SmtpClient($email_smtp_host, $email_smtp_port);

        $smtp.EnableSSL = $email_smtp_SSL;

        $smtp.Credentials = New-Object System.Net.NetworkCredential($email_username, $email_password);

        $smtp.send($message);

        $message.Dispose();

        write-host "... E-Mail sent!" ;

    }

    else {

        $minSize1 = $minSize

        $minSize = $minSize1 / 1GB

        Write-Host ("Drive " + $d + " has more than " + $minSize + " bytes free: nothing to do.");

    }

}
