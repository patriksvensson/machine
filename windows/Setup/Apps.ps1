##########################################################################
# Disable UAC (temporarily)
##########################################################################

Disable-UAC

##########################################################################
# Utility methods
##########################################################################

Function Test-Rust() {
    return Test-Path -Path (Join-Path $env:USERPROFILE ".cargo");
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

choco upgrade --cache="$ChocoCachePath" --yes steam
choco upgrade --cache="$ChocoCachePath" --yes uplay
choco upgrade --cache="$ChocoCachePath" --yes origin
choco upgrade --cache="$ChocoCachePath" --yes slack
choco upgrade --cache="$ChocoCachePath" --yes spotify
choco upgrade --cache="$ChocoCachePath" --yes microsoft-edge
choco upgrade --cache="$ChocoCachePath" --yes docker-for-windows
choco upgrade --cache="$ChocoCachePath" --yes geforce-experience
choco upgrade --cache="$ChocoCachePath" --yes vscode
choco upgrade --cache="$ChocoCachePath" --yes sysinternals
choco upgrade --cache="$ChocoCachePath" --yes git
choco upgrade --cache="$ChocoCachePath" --yes ghostscript.app
choco upgrade --cache="$ChocoCachePath" --yes 7zip.install
choco upgrade --cache="$ChocoCachePath" --yes nodejs
choco upgrade --cache="$ChocoCachePath" --yes office365business
choco upgrade --cache="$ChocoCachePath" --yes cmake
choco upgrade --cache="$ChocoCachePath" --yes screentogif
choco upgrade --cache="$ChocoCachePath" --yes paint.net
choco upgrade --cache="$ChocoCachePath" --yes chocolateygui
choco upgrade --cache="$ChocoCachePath" --yes curl
choco upgrade --cache="$ChocoCachePath" --yes powershell-core
choco upgrade --cache="$ChocoCachePath" --yes ripgrep
choco upgrade --cache="$ChocoCachePath" --yes starship
choco upgrade --cache="$ChocoCachePath" --yes microsoft-windows-terminal
choco upgrade --cache="$ChocoCachePath" --yes visualstudio2019professional --package-parameters "--add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended --norestart --passive --locale en-US"

##########################################################################
# Install VSCode extensions
##########################################################################

code --install-extension cake-build.cake-vscode
code --install-extension matklad.rust-analyzer
code --install-extension ms-vscode.powershell
code --install-extension bungcip.better-toml

code --install-extension jolaleye.horizon-theme-vscode
code --install-extension vscode-icons-team.vscode-icons

##########################################################################
# Install Rust
##########################################################################

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

##########################################################################
# Restore Temporary Settings
##########################################################################

Enable-UAC
Enable-MicrosoftUpdate