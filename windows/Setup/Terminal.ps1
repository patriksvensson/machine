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
# Create temporary directory
##########################################################################

# Workaround choco / boxstarter path too long error
# https://github.com/chocolatey/boxstarter/issues/241
$ChocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
New-Item -Path $ChocoCachePath -ItemType Directory -Force

##########################################################################
# Install Windows terminal
##########################################################################

choco upgrade --cache="$ChocoCachePath" --yes microsoft-windows-terminal
RefreshEnv

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
