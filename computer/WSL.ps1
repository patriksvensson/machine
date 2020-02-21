##########################################################################
# Running in Windows Sandbox?
##########################################################################

if ($env:UserName -eq "WDAGUtilityAccount") {
    Write-Host "Sorry, can't install WSL in a Windows Sandbox.";
    Return;
}

##########################################################################
# Create temporary directory
##########################################################################

# Workaround choco / boxstarter path too long error
# https://github.com/chocolatey/boxstarter/issues/241
$ChocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
New-Item -Path $ChocoCachePath -ItemType Directory -Force

##########################################################################
# Install Windows subsystem for Linux
##########################################################################

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

choco install --cache="$ChocoCachePath" --yes Microsoft-Hyper-V-All -source windowsFeatures
choco install --cache="$ChocoCachePath" --yes Microsoft-Windows-Subsystem-Linux -source windowsfeatures

##########################################################################
# Install Ubuntu
##########################################################################

Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile ~/Downloads/Ubuntu.appx -UseBasicParsing
Add-AppxPackage -Path ~/Downloads/Ubuntu.appx
RefreshEnv

Ubuntu1804 install --root
Ubuntu1804 run apt-get update -y
Ubuntu1804 run apt-get upgrade -y