<#
.DESCRIPTION
  Changes the background wallpaper on Windows
#>
function Set-Wallpaper
{
  Param(
    [Parameter(Mandatory)]
    [string]$Path
  )

  $previousValue = $ErrorActionPreference
  $ErrorActionPreference = 'Stop'

  try
  {
    Add-Type -TypeDefinition @"
    using System.Runtime.InteropServices;
    public class MarshalUser32Dll
    {
      public const int kSetDesktopWallpaper = 20;
      public const int kUpdateIniFile = 0x01;
      public const int kSendWinIniChange = 0x02;
      
      [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
      private static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
      
      public static void SetWallpaper(string Path)
      {
        SystemParametersInfo(kSetDesktopWallpaper, 0, Path, kUpdateIniFile | kSendWinIniChange);
      }
    }
    "@
    [MarshalUser32Dll]::SetWallpaper($Path)
    return $True
  }
  catch 
  {
    return $False
  }
  finally
  {
    $ErrorActionPreference = $previousValue
  }

}
