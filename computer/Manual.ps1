. (Join-Path $PSScriptRoot "../utilities/PowerShell/Rust.ps1")
. (Join-Path $PSScriptRoot "../utilities/PowerShell/Starship.ps1")

# Now install other stuff
if (!(Test-Rust)) {
    Write-Host "Installing Rust..."
    Install-RemoteFile -Url "https://win.rustup.rs/x86_64" -Filename "rustup-init.exe" -Arguments "-y" -RefreshEnvVars;
}

# Install Starship
if (!(Test-Starship)) {
    Write-Host "Installing Starship..."
    & "cargo" "install" "starship";
}

# Install Hexyl
& "cargo" "install" "hexyl"
& "choco" "install" "ripgrep"