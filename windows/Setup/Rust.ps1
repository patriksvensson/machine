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
# Install Rust
##########################################################################

if (!(Test-Rust)) {
    Write-Host "Installing Rust..."
    $Client = New-Object System.Net.WebClient;
    $Client.DownloadFile("https://win.rustup.rs/x86_64", "$HOME/Downloads/rustup-init.exe");
    Start-Process -FilePath "$HOME/Downloads/rustup-init.exe" -NoNewWindow -Wait -ArgumentList "-y";
    RefreshEnv
}

##########################################################################
# Restore Temporary Settings
##########################################################################

Enable-UAC
Enable-MicrosoftUpdate