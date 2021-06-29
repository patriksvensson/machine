##########################################################################
# Disable UAC (temporarily)
##########################################################################

Disable-UAC

##########################################################################
# Utility stuff
##########################################################################

Function Test-Rust() {
    return Test-Path -Path (Join-Path $env:USERPROFILE ".cargo");
}

$Architecture = (Get-WmiObject Win32_OperatingSystem).OSArchitecture;
$IsArm = $false;
if($Architecture.StartsWith("ARM")) {
    Write-Host "##########################################################################"
    Write-Host "# RUNNING ON ARM COMPUTER"
    Write-Host "##########################################################################"
    $IsArm = $true;
}

##########################################################################
# Create temporary directory
##########################################################################

# Workaround choco / boxstarter path too long error
# https://github.com/chocolatey/boxstarter/issues/241
$ChocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
New-Item -Path $ChocoCachePath -ItemType Directory -Force

##########################################################################
# Install applications
##########################################################################

choco upgrade --cache="$ChocoCachePath" --yes discord
choco upgrade --cache="$ChocoCachePath" --yes slack
choco upgrade --cache="$ChocoCachePath" --yes microsoft-edge
choco upgrade --cache="$ChocoCachePath" --yes git
choco upgrade --cache="$ChocoCachePath" --yes ghostscript.app
choco upgrade --cache="$ChocoCachePath" --yes 7zip.install
choco upgrade --cache="$ChocoCachePath" --yes office365business
choco upgrade --cache="$ChocoCachePath" --yes screentogif
choco upgrade --cache="$ChocoCachePath" --yes paint.net
choco upgrade --cache="$ChocoCachePath" --yes chocolateygui
choco upgrade --cache="$ChocoCachePath" --yes powershell-core
choco upgrade --cache="$ChocoCachePath" --yes ripgrep
choco upgrade --cache="$ChocoCachePath" --yes microsoft-windows-terminal
choco upgrade --cache="$ChocoCachePath" --yes winsnap
choco upgrade --cache="$ChocoCachePath" --yes gsudo

if(!$IsArm) {
    # x86/x64 only
    choco upgrade --cache="$ChocoCachePath" --yes steam
    choco upgrade --cache="$ChocoCachePath" --yes uplay
    choco upgrade --cache="$ChocoCachePath" --yes spotify
    choco upgrade --cache="$ChocoCachePath" --yes nugetpackageexplorer
    choco upgrade --cache="$ChocoCachePath" --yes docker-for-windows
    choco upgrade --cache="$ChocoCachePath" --yes geforce-experience
    choco upgrade --cache="$ChocoCachePath" --yes sysinternals
    choco upgrade --cache="$ChocoCachePath" --yes nodejs
    choco upgrade --cache="$ChocoCachePath" --yes cmake
    choco upgrade --cache="$ChocoCachePath" --yes curl
    choco upgrade --cache="$ChocoCachePath" --yes vscode
    choco upgrade --cache="$ChocoCachePath" --yes visualstudio2019professional --package-parameters "--add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended --norestart --passive --locale en-US"
    choco upgrade --cache="$ChocoCachePath" --yes dotpeek --pre
    choco upgrade --cache="$ChocoCachePath" --yes zoom
    choco upgrade --cache="$ChocoCachePath" --yes poshgit
    choco upgrade --cache="$ChocoCachePath" --yes powertoys
    choco upgrade --cache="$ChocoCachePath" --yes ncrunch-vs2019
    choco upgrade --cache="$ChocoCachePath" --yes streamdeck
}

##########################################################################
# Install VSCode extensions
##########################################################################

if(!$IsArm) {
    # x86/x64 only
    code --install-extension cake-build.cake-vscode
    code --install-extension matklad.rust-analyzer
    code --install-extension ms-vscode.powershell
    code --install-extension bungcip.better-toml
    code --install-extension ms-azuretools.vscode-docker
    code --install-extension octref.vetur
    code --install-extension ms-vscode-remote.remote-wsl
    code --install-extension jolaleye.horizon-theme-vscode
    code --install-extension vscode-icons-team.vscode-icons
    code --install-extension hediet.vscode-drawio
}

##########################################################################
# Install VSCode extensions
##########################################################################

Function Install-VSExtension([String] $PackageName) 
{
    # Based on https://gist.github.com/ScottHutchinson/b22339c3d3688da5c9b477281e258400
    $Uri = "https://marketplace.visualstudio.com/items?itemName=$($PackageName)"
    $VsixLocation = "$($env:Temp)\$([guid]::NewGuid()).vsix"   
    $VSInstallDir = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\resources\app\ServiceHub\Services\Microsoft.VisualStudio.Setup.Service"

    if (-Not $VSInstallDir) {
        Write-Error "Visual Studio InstallDir registry key missing" -ForegroundColor Red
        Exit 1
    }
    
    Write-Host "Grabbing VSIX extension at $($Uri)"
    $HTML = Invoke-WebRequest -Uri $Uri -UseBasicParsing -SessionVariable session
    
    Write-Debug "Attempting to download $($PackageName)..."
    $anchor = $HTML.Links |
    Where-Object { $_.class -eq 'install-button-container' } |
    Select-Object -ExpandProperty href

    if (-Not $anchor) {
        Write-Error "Could not find download anchor tag on the Visual Studio Extensions page" -ForegroundColor Red
        Exit 1
    }

    $href = "https://marketplace.visualstudio.com$($anchor)"
    Write-Debug "Anchor is $($anchor)"
    Write-Debug "Href is $($href)"
    
    Invoke-WebRequest $href -OutFile $VsixLocation -WebSession $session
    if (-Not (Test-Path $VsixLocation)) {
        Write-Error "Downloaded VSIX file could not be located" -ForegroundColor Red
        Exit 1
    }

    Write-Debug "VSInstallDir is $($VSInstallDir)"
    Write-Debug "VsixLocation is $($VsixLocation)"
    Write-Host "Installing $($PackageName)..."
    Start-Process -Filepath "$($VSInstallDir)\VSIXInstaller" -ArgumentList "/q /a $($VsixLocation)" -Wait
    
    Write-Debug "Cleanup..."
    Remove-Item $VsixLocation
    
    Write-Host "Installation of $($PackageName) complete!" -ForegroundColor Green
}

Write-Host "Installing Visual Studio extensions" -ForegroundColor Yellow
Write-Host "NOTE: Script might appear unresponsive"

Install-VSExtension -PackageName "MadsKristensen.Tweaks"

##########################################################################
# Install Rust
##########################################################################

if(!$IsArm) {
    if (!(Test-Rust)) {
        Write-Host "Installing Rust..."
        $Client = New-Object System.Net.WebClient;
        $Client.DownloadFile("https://win.rustup.rs/x86_64", "$HOME/Downloads/rustup-init.exe");
        Start-Process -FilePath "$HOME/Downloads/rustup-init.exe" -NoNewWindow -Wait -ArgumentList "-y";
        RefreshEnv
    } else {
        Write-Host "Updating Rust..."
        rustup update
    }
}

##########################################################################
# Install posh-git
##########################################################################

PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force

##########################################################################
# Restore Temporary Settings
##########################################################################

Enable-UAC
Enable-MicrosoftUpdate