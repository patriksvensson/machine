##########################################################################
# Utility methods
##########################################################################

Function Test-Rust() {
    return Test-Path -Path (Join-Path $env:USERPROFILE ".cargo");
}

Function Test-Starship() {
    return Test-Path -Path (Join-Path $env:USERPROFILE ".cargo/bin/starship.exe");
}

##########################################################################
# Install Starship
##########################################################################

if (!(Test-Rust)) {
    Write-Host "Rust is not installed so can't install Starship."
    Return;
}

if (!(Test-Starship)) {
    Write-Host "Installing Starship..."
    & "cargo" "install" "starship";
    RefreshEnv
}
