<#
.DESCRIPTION
  Updates the installed developer environment based on the input configuration file
#>
function Update-CknDevEnv
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [string]$ChocoConfigPath
  )

  # Download remote config files
  if ($ChocoConfigPath.StartsWith("http"))
  {
    $TempConfigPath = Join-Path ([System.IO.Path]::GetTempPath()) "CknDevEnv-$([System.IO.Path]::GetRandomFileName()).config"
    try
    {
      $Headers = @{'Cache-Control'='no-store'}
      Write-Host "Downloading $ChocoConfigPath -> $TempConfigPath"
      Invoke-WebRequest -Headers $Headers -Uri $ChocoConfigPath -OutFile $TempConfigPath
      $FileHash = (Get-FileHash $TempConfigPath -Algorithm SHA256).Hash
      Write-Host " > Downloaded, SHA256 = $FileHash"
    }
    catch
    {
      Write-Host -ForegroundColor Red "Unable to download Chocolatey configuration file from $ChocoConfigPath"
      return
    }
    
    # Continue with the actual file path
    $ChocoConfigPath = $TempConfigPath
  }

  Install-Chocolatey
  Install-ChocolateyPackageConfig -Path $ChocoConfigPath

  # === add more auto-setup commands here ===

}
