[CmdletBinding(DefaultParameterSetName='Granular')]
Param(
    [Parameter(ParameterSetName='Everything')]
    [switch]$All,
    [Parameter(ParameterSetName='Granular')]
    [switch]$Windows,
    [Parameter(ParameterSetName='Granular')]
    [switch]$WSL,
    [Parameter(ParameterSetName='Granular')]
    [switch]$Apps,
    [Parameter(ParameterSetName='Granular')]
    [switch]$Sandbox,
    [Parameter(ParameterSetName='Granular')]
    [switch]$VisualStudio,
    [Parameter(ParameterSetName='Granular')]
    [switch]$Rust,
    [Parameter(ParameterSetName='Granular')]
    [switch]$Starship
)

# Nothing selected? Show help screen.
if (!$Windows.IsPresent -and !$WSL.IsPresent -and !$Apps.IsPresent -and !$Sandbox.IsPresent `
    -and !$VisualStudio.IsPresent -and !$Rust.IsPresent -and !$Starship.IsPresent `
    -and !$All.IsPresent)
{
    Get-Help .\Install.ps1
    Exit;
}

# Load some utilities
. (Join-Path $PSScriptRoot "./Utilities/Utilities.ps1")

# Assert that we're running as administrators
Assert-Administrator -FailMessage "This script must be run as administrator.";

# Install BoxStarter + Chocolatey if missing
if (!(Assert-CommandExists -CommandName "Install-BoxstarterPackage")) {
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1')); 
    Get-Boxstarter -Force
}

if ($Windows.IsPresent -or $All.IsPresent) {
    Install-BoxstarterPackage ./Setup/Windows.ps1
    RefreshEnv
}
if ($WSL.IsPresent -or $All.IsPresent) {
    Install-BoxstarterPackage ./Setup/WSL.ps1
    RefreshEnv
}
if ($Apps.IsPresent -or $All.IsPresent) {
    Install-BoxstarterPackage ./Setup/Apps.ps1 -DisableReboots
    RefreshEnv
}
if ($Sandbox.IsPresent -or $All.IsPresent) {
    Install-BoxstarterPackage ./Setup/Sandbox.ps1
    RefreshEnv
}
if ($VisualStudio.IsPresent -or $All.IsPresent) {
    Install-BoxstarterPackage ./Setup/VisualStudio.ps1
    RefreshEnv
}
if ($Rust.IsPresent -or $All.IsPresent) {
    Install-BoxstarterPackage ./Setup/Rust.ps1
    RefreshEnv
}
if ($Starship.IsPresent -or $All.IsPresent) {
    Install-BoxstarterPackage ./Setup/Starship.ps1
    RefreshEnv
}