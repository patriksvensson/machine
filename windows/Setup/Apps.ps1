##########################################################################
# Disable UAC (temporarily)
##########################################################################

Disable-UAC

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

choco upgrade --cache="$ChocoCachePath" --yes slack
choco upgrade --cache="$ChocoCachePath" --yes spotify
choco upgrade --cache="$ChocoCachePath" --yes microsoft-edge
choco upgrade --cache="$ChocoCachePath" --yes docker-for-windows
choco upgrade --cache="$ChocoCachePath" --yes geforce-experience
choco upgrade --cache="$ChocoCachePath" --yes vscode
choco upgrade --cache="$ChocoCachePath" --yes sysinternals
choco upgrade --cache="$ChocoCachePath" --yes git
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

##########################################################################
# Install VSCode extensions
##########################################################################

code --install-extension cake-build.cake-vscode

##########################################################################
# Restore Temporary Settings
##########################################################################

Enable-UAC
Enable-MicrosoftUpdate