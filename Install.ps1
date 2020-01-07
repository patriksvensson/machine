[CmdletBinding(DefaultParameterSetName='Granular')]
Param(
    [Parameter(ParameterSetName='All')]
    [switch]$All,
    [Parameter(ParameterSetName='Granular')]
    [switch]$Boxstarter,
    [Parameter(ParameterSetName='Granular')]
    [switch]$Other,
    [Parameter(ParameterSetName='Granular')]
    [switch]$Terminal
)

if (!$Terminal.IsPresent -and !$Other.IsPresent -and !$Boxstarter.IsPresent -and !$All.IsPresent)
{
    Get-Help .\Install.ps1
    Exit;
}

# Load some utilities
. (Join-Path $PSScriptRoot "./utilities/PowerShell/Utilities.ps1")
. (Join-Path $PSScriptRoot "./utilities/PowerShell/Files.ps1")

# Assert that we're running as administrators
Assert-Administrator -FailMessage "This script must be run as administrator.";

# Install BoxStarter + Chocolatey if missing
if (!(Assert-CommandExists -CommandName "Install-BoxstarterPackage")) {
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1')); 
    Get-Boxstarter -Force
}

# Run the boxstarter installation?
if ($Boxstarter.IsPresent -or $All.IsPresent) {
    Install-BoxstarterPackage ./Computer/Boxstarter.ps1 -DisableReboots
}

# Install terminal settings?
if ($Other.IsPresent -or $All.IsPresent) {
    Push-Location
    Set-location computer
    Invoke-Expression "./Manual.ps1"
    Pop-Location
}

# Install terminal settings?
if ($Terminal.IsPresent -or $All.IsPresent) {
    Push-Location
    Set-location terminal
    Invoke-Expression "./Install.ps1 -PowerShellProfile -Fonts -WindowsTerminalProfile -StarshipProfile"
    Pop-Location
}