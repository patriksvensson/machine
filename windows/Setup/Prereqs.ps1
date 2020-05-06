##########################################################################
# Disable UAC (temporarily)
##########################################################################

Disable-UAC

##########################################################################
# Utility stuff
##########################################################################

$Architecture = (Get-WmiObject Win32_OperatingSystem).OSArchitecture;
$IsArm = $false;
if($Architecture.StartsWith("ARM")) {
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
# Enable Windows subsystem for Linux
##########################################################################

if($env:UserName -ne "WDAGUtilityAccount") { # Can't install this on Sandbox
    choco install --cache="$ChocoCachePath" --yes Microsoft-Windows-Subsystem-Linux -source windowsfeatures
    choco install --cache="$ChocoCachePath" --yes VirtualMachinePlatform -source windowsfeatures

    if(!$IsArm) {
        choco install --cache="$ChocoCachePath" --yes Microsoft-Hyper-V-All -source windowsFeatures
    }
}

##########################################################################
# Install Windows Sandbox
##########################################################################

if(!$IsArm) { # Can't install Windows Sandbox on ARM devices
    if($env:UserName -ne "WDAGUtilityAccount") { # Can't install this on Sandbox
        Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online
    }
}

##########################################################################
# Windows settings
##########################################################################

Disable-BingSearch
Disable-GameBarTips

Set-ItemProperty -Path "HKLM:SYSTEM\CurrentControlSet\Control\FileSystem" -Name LongPathsEnabled -Type DWord -Value 1
Set-WindowsExplorerOptions -EnableShowFileExtensions
Set-TaskbarOptions -Size Large -Dock Bottom -Combine Full -Lock

##########################################################################
# Power settings
##########################################################################

powercfg /change monitor-timeout-ac 0 # Don't turn off monitor
powercfg /change standby-timeout-ac 0 # Don't ever sleep

##########################################################################
# Uninstall bloatware
##########################################################################

Get-AppxPackage Microsoft.3DBuilder | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsAlarms | Remove-AppxPackage
Get-AppxPackage *Autodesk* | Remove-AppxPackage
Get-AppxPackage *BubbleWitch* | Remove-AppxPackage
Get-AppxPackage *CandyCrush* | Remove-AppxPackage
Get-AppxPackage Microsoft.MicrosoftOfficeHub | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsMaps | Remove-AppxPackage
Get-AppxPackage *Netflix* | Remove-AppxPackage
Get-AppxPackage Microsoft.BingWeather | Remove-AppxPackage
Get-AppxPackage Microsoft.SkypeApp | Remove-AppxPackage
Get-AppxPackage Microsoft.Microsoft3DViewer | Remove-AppxPackage
Get-AppxPackage Microsoft.MixedReality.Portal | Remove-AppxPackage
Get-AppxPackage Microsoft.ZuneMusic | Remove-AppxPackage
Get-AppxPackage Microsoft.YourPhone | Remove-AppxPackage
Get-AppxPackage Microsoft.MSPaint | Remove-AppxPackage
Get-AppxPackage Microsoft.MicrosoftSolitaireCollection | Remove-AppxPackage

##########################################################################
# Privacy
##########################################################################

# Privacy: Let apps use my advertising ID: Disable
If (-Not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo")) {
    New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo | Out-Null
}
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -Type DWord -Value 0

# WiFi Sense: HotSpot Sharing: Disable
If (-Not (Test-Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
    New-Item -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting | Out-Null
}
Set-ItemProperty -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting -Name value -Type DWord -Value 0

# WiFi Sense: Shared HotSpot Auto-Connect: Disable
Set-ItemProperty -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots -Name value -Type DWord -Value 0

##########################################################################
# User interface
##########################################################################

# Change Explorer home screen back to "This PC"
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Type DWord -Value 1

# Start Menu: Disable Bing Search Results
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Type DWord -Value 0

# Turn off People in Taskbar
If (-Not (Test-Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
    New-Item -Path HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People | Out-Null
}
Set-ItemProperty -Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name PeopleBand -Type DWord -Value 0

# Disable the Lock Screen (the one before password prompt - to prevent dropping the first character)
If (-Not (Test-Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization)) {
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows -Name Personalization | Out-Null
}
Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization -Name NoLockScreen -Type DWord -Value 1

##########################################################################
# Restore Temporary Settings
##########################################################################

Enable-UAC
Enable-MicrosoftUpdate