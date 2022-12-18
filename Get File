    $sessionUrl = "sftp://NG-REPOSITORY:b%5B%5BobRN62QC%21;fingerprint=ecdsa-sha2-nistp384-B3eV4dPJ97jiWLp4RcNYGuiBEAoQxg5iiyFUMcusBVs@95.129.32.72/"
    $remotePath = '/$(RepositoryFolder)/'
    
	$DateTime = get-date -format ddMMyyyyHHmm
    $localPath = "C:\neogames\Builds\$(RepositoryFolder)\$DateTime\"
	
    $batches = 5

if ( -not (Test-Path  $localPath ) ) {
    New-Item $localPath -ItemType Directory
} 
 
try
{
    $assemblyFilePath = "C:\Program Files (x86)\WinSCP\WinSCPnet.dll"
    # Load WinSCP .NET assembly
    Add-Type -Path $assemblyFilePath
 
    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions
    $sessionOptions.ParseUrl($sessionUrl)
	write-host $sessionOptions
 
    $started = Get-Date
    # Plain variables cannot be modified in job threads
    $stats = @{
        count = 0
        bytes = [long]0
    }
 
    try
    {
        # Connect
        Write-Host "Connecting..."
        $session = New-Object WinSCP.Session
        $session.Open($sessionOptions)
        
        Write-Host "Starting files enumeration..."
        $files =
            $session.EnumerateRemoteFiles(
                $remotePath, $Null, [WinSCP.EnumerationOptions]::AllDirectories)
        # An explicit implementation of IEnumerable cannot be accessed directly in PowerShell.
        # WinSCP 5.18.4 has an implicit implementation, so direct $files.GetEnumerator() works.
        $filesEnumerator =
            [System.Collections.IEnumerable].GetMethod("GetEnumerator").Invoke($files, $Null)
 
        for ($i = 1; $i -le $batches; $i++)
        {
            Start-ThreadJob -Name "Batch $i" -ArgumentList $i {
                param ($no)
 
                try
                {
                    Write-Host "Starting download $no..."
 
                    $downloadSession = New-Object WinSCP.Session
                    $downloadSession.Open($using:sessionOptions)
 
                    while ($True)
                    {
                        [System.Threading.Monitor]::Enter($using:filesEnumerator)
                        try
                        {
                            if (!($using:filesEnumerator).MoveNext())
                            {
                                break
                            }
 
                            $file = ($using:filesEnumerator).Current
                            ($using:stats).bytes += $file.Length
                            ($using:stats).count++
                            $remoteFilePath = $file.FullName
                        }
                        finally
                        {
                            [System.Threading.Monitor]::Exit($using:filesEnumerator)
                        }
 
                        $localFilePath =
                            [WinSCP.RemotePath]::TranslateRemotePathToLocal(
                                $remoteFilePath, $using:remotePath, $using:localPath)
                        
                        $localFileDir = (Split-Path -Parent $localFilePath)
						if($remoteFilePath -notlike "*CDN*"){
							Write-Host "Downloading $remoteFilePath to $localFilePath in $no..."
							New-Item -ItemType directory -Path $localFileDir -Force | Out-Null
							$downloadSession.GetFileToDirectory($remoteFilePath, $localFileDir) |
								Out-Null
						}
                    }
 
                    Write-Host "Download $no done"
                }
                finally
                {
                    $downloadSession.Dispose()
                }
            } | Out-Null
        }
 
        Write-Host "Waiting for downloads to complete..."
        Get-Job | Receive-Job -Wait
 
        Write-Host "Done"
 
        $ended = Get-Date
        Write-Host "Took $(New-TimeSpan -Start $started -End $ended)"
        Write-Host ("Downloaded $($stats.count) files, " +
                    "totaling $($stats.bytes.ToString("N0")) bytes")
    }
    finally
    {
        # Disconnect, clean up
        $session.Dispose()
Write-Host "BuildPath = $localPath" -ForegroundColor Green
        Write-Host "##vso[task.setvariable variable=BuildPath]$localPath"
    }
 
    exit 0
}
catch
{
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
}

############OLD Get-Files#########

    #$FTP = "ftp://XX.XX.XX.XX"
    #$user = 'NAME' 
    #$pass = 'Pass'
    #$Folder = "$(RepositoryFolder)"
	#
    #$DateTime = get-date -format ddMMyyyyHHmm
    #Write-Host "##vso[task.setvariable variable=DateTime]$DateTime"
	#
    #$Target = "C:\neogames\Builds\$Folder\$DateTime\"
    #Write-Host "##vso[task.setvariable variable=Target]$Target"
	#
    #$CreateTarget = New-Item -Path $Target -ItemType directory -force
	#
    ##SET CREDENTIALS
    #$credentials = new-object System.Net.NetworkCredential($user, $pass)
	#
    #function Get-FtpDir ($url,$credentials) {
    #    $request = [Net.WebRequest]::Create($url)
    #    $request.Method = [System.Net.WebRequestMethods+FTP]::ListDirectory
    #    if ($credentials) { $request.Credentials = $credentials }
    #    $response = $request.GetResponse()
    #    $reader = New-Object IO.StreamReader $response.GetResponseStream() 
    #    while(-not $reader.EndOfStream) {
    #        $reader.ReadLine()
    #    }
    #    #$reader.ReadToEnd()
    #    $reader.Close()
    #    $response.Close()
    #}
	#
    ##SET FOLDER PATH
    #$folderPath= $ftp + "/" + $folder + "/"
	#
    #$files = Get-FTPDir -url $folderPath -credentials $credentials
	#
    #$webclient = New-Object System.Net.WebClient 
    #$webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass) 
    #$counter = 0
    #foreach ($file in ($files | where {$_ -notlike "CDN_*"})){
	#	$source=$folderPath + $file  
	#	$destination = $target + $file 
	#	$webclient.DownloadFile($source,$destination)
	#
	#	#PRINT FILE NAME AND COUNTER
	#	Write-host "$counter - $source"
	#	$counter++
    #}
	#
    #    Write-Host "BuildPath = $Target" -ForegroundColor Green
    #    Write-Host "##vso[task.setvariable variable=BuildPath]$Target"
