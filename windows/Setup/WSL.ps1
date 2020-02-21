##########################################################################
# Disable UAC (temporarily)
##########################################################################

Disable-UAC

##########################################################################
# Running in Windows Sandbox?
##########################################################################

if ($env:UserName -eq "WDAGUtilityAccount") {
    Write-Host "Sorry, can't install Ubuntu in a Windows Sandbox.";
    Return;
}

##########################################################################
# Install Ubuntu
##########################################################################

Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile ~/Downloads/Ubuntu.appx -UseBasicParsing
Add-AppxPackage -Path ~/Downloads/Ubuntu.appx
RefreshEnv

Ubuntu1804 install --root
Ubuntu1804 run apt-get update -y
Ubuntu1804 run apt-get upgrade -y

##########################################################################
# Restore Temporary Settings
##########################################################################

Enable-UAC
Enable-MicrosoftUpdate