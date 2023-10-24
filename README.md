# CKN Developer Environment

CKN dev pc auto-setup scripts. For a standard Win10Pro dev PC with space for this project on the `D:` drive and installed applications/OS on `C:` drive. Adapt as necessary.

<details>
<summary><h3>First time setup</h3></summary>

1. `Win + x` , `a`, `enter`

2. Accept prompt to start admin-mode PowerShell

3. Run in PowerShell to bootstrap the developer environment:

```
cd ~/Downloads ; Set-ExecutionPolicy Bypass -Scope Process -Force ; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072 ; (Invoke-WebRequest -UseBasicParsing -Method Get -Uri "https://raw.githubusercontent.com/karlgluck/ckn-devenv/main/Bootstrap/Install-CknDevEnv.ps1" -Headers @{'Cache-Control'='no-store'}).Content | Invoke-Expression ; Install-CknDevEnv -ZipFilePath "https://github.com/karlgluck/ckn-devenv/archive/refs/heads/main.zip" ; Update-CknDevEnv "https://github.com/karlgluck/ckn-devenv/raw/main/ckn-win10.config"
```

4. Set up Git for yourself:

```
git config --global user.name "FIRST_NAME LAST_NAME"
git config --global user.email "MY_NAME@example.com"
```

5. Run in PowerShell to clone the project:

```
$ProjPath = "D:\ckn" ; if (-not (Test-Path $ProjPath)) { New-Item $ProjPath -ItemType Directory | Out-Null } ; Set-Location $ProjPath ; git clone https://github.com/karlgluck/ckn-ueproj
```

6. Open the project

```
Start-Process "D:\ckn\ckn-ueproj\Crowknuckles\Crowknuckles.uproject"
```

</details>

### Updating/starting the editor

Getting started with work is the same as updating the project.

1. Close any open editors (Unreal, etc)

2. `Win + x` , `a`, `enter`

3. Accept prompt to start admin powershell

4. Run in PowerShell to update & relaunch:

```
Set-ExecutionPolicy Bypass -Scope Process -Force ; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072 ; Update-CknDevEnv "https://github.com/karlgluck/ckn-devenv/raw/main/ckn-win10.config" ; Set-Location "D:\ckn\ckn-ueproj" ; git pull ; if ($LASTEXITCODE -eq 0) { Start-Process "D:\ckn\ckn-ueproj\Crowknuckles\Crowknuckles.uproject" }
```

