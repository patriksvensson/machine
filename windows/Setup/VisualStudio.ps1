##########################################################################
# Create temporary directory
##########################################################################

# Workaround choco / boxstarter path too long error
# https://github.com/chocolatey/boxstarter/issues/241
$ChocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
New-Item -Path $ChocoCachePath -ItemType Directory -Force

##########################################################################
# Install Visual Studio
##########################################################################

# We're only interested in the MSVC stuff so we can compile the Rust
# dependencies. The actual VS workloads varies between computers.

Write-Host "Installing Visual Studio..."
choco install visualstudio2019professional `
      --package-parameters "--add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended --norestart --passive --locale en-US"

RefreshEnv
