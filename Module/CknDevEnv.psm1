
$Paths = @($PSScriptRoot)

# Load each file and export it as a function from the module
$Paths | Where-Object { Test-Path $_ } | Get-ChildItem -File -Filter "*.ps1" | ForEach-Object { . $_.FullName ; Export-ModuleMember -Function ([System.IO.Path]::GetFileNameWithoutExtension($_.Name)) }
