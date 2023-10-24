function Install-CknDevEnv
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [string]$ZipFilePath
  )

    # If the zip file path provided specifies a URL, download the file
    if ($ZipFilePath.StartsWith("http"))
    {
        $TempZipPath = Join-Path ([System.IO.Path]::GetTempPath()) "CknDevEnv-$([System.IO.Path]::GetRandomFileName()).zip"
        try
        {
          $Headers = @{'Cache-Control'='no-store'}
          Write-Host "Downloading $ZipFilePath -> $TempZipPath"
          Invoke-WebRequest -UseBasicParsing -Headers $Headers -Uri $ZipFilePath -OutFile $TempZipPath
          $ZipFileHash = (Get-FileHash $TempZipPath -Algorithm SHA256).Hash
          Write-Host " > Downloaded, SHA256 = $ZipFileHash"
        }
        catch
        {
          Write-Host -ForegroundColor Red "Unable to download host repository ZIP file from $ZipFilePath"
          return
        }
        
        # Continue with the zip path so we can extract the module locally
        $ZipFilePath = $TempZipPath
    }
  
    # Install to this folder, deleting anything that exists if necessary
    $InstalledModuleName = "CknDevEnv"
    $ModulesFolder = Join-Path ($env:PSModulePath -split ';')[0] $InstalledModuleName
    Write-Host "Install $ZipFilePath/Module/** as a PowerShell module named $InstalledModuleName into $ModulesFolder"
    if (Test-Path $ModulesFolder) { Remove-Item -Recurse -Force $ModulesFolder }
    

    # If the path provided specifies a directory, assume that is the module directory and copy it. This
    # is useful for debugging. Otherwise, this is a zip file that contains the entire repository.
    if ((Get-Item $ZipFilePath).PSIsContainer)
    {
        Copy-Item $ZipFilePath $ModulesFolder -Recurse
    }
    else
    {
        # This is Expand-ZipFileDirectory to pull out the modules folder, but that function doesn't exist the first time
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $DirectoryInZipFile = "Module"
        $DirectoryRegex = "\/" + ($DirectoryInZipFile.Trim('/\') -replace "/","\/") + "\/(.*)"
        try
        {
          $Zip = [System.IO.Compression.ZipFile]::OpenRead($ZipFilePath)
          $Zip.Entries | 
            Where-Object { $_.Name -ne "" } |
            ForEach-Object {
              $Match = [RegEx]::Match($_.FullName, $DirectoryRegex)
              if ($Match.Success)
              {
                $OutputFilePath = Join-Path $ModulesFolder $Match.Groups[1].Value
                $OutputDirectoryPath = Split-Path -Parent $OutputFilePath
                Write-Host " > Extracting $($_.FullName)"
                if (-not (Test-Path $OutputDirectoryPath)) { New-Item $OutputDirectoryPath -ItemType Directory | Out-Null }
                [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, $OutputFilePath, $true) | Out-Null
              }
            }
        }
        finally
        {
          $Zip.Dispose()
        }
    }

    # Grab the newer version of the module
    Import-Module $InstalledModuleName -Force

}

