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
    [switch]$Terminal
)

# Nothing selected? Show help screen.
if (!$Windows.IsPresent -and !$WSL.IsPresent -and !$Apps.IsPresent -and !$Sandbox.IsPresent `
    -and !$VisualStudio.IsPresent -and !$Rust.IsPresent -and !$Terminal.IsPresent `
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
    Install-BoxstarterPackage ./Setup/Windows.ps1 -DisableReboots
    RefreshEnv
}
if ($WSL.IsPresent -or $All.IsPresent) {
    Install-BoxstarterPackage ./Setup/WSL.ps1 -DisableReboots
    RefreshEnv
}
if ($Apps.IsPresent -or $All.IsPresent) {
    Install-BoxstarterPackage ./Setup/Apps.ps1 -DisableReboots
    RefreshEnv
}
if ($Sandbox.IsPresent -or $All.IsPresent) {
    Install-BoxstarterPackage ./Setup/Sandbox.ps1 -DisableReboots
    RefreshEnv
}
if ($VisualStudio.IsPresent -or $All.IsPresent) {
    Install-BoxstarterPackage ./Setup/VisualStudio.ps1 -DisableReboots
    RefreshEnv
}
if ($Rust.IsPresent -or $All.IsPresent) {
    Install-BoxstarterPackage ./Setup/Rust.ps1 -DisableReboots
    RefreshEnv
}
if ($Terminal.IsPresent -or $All.IsPresent) {
    Install-BoxstarterPackage ./Setup/Terminal.ps1 -DisableReboots
    RefreshEnv

    # Install Powershell profile
    Push-Location
    Set-location terminal
    Invoke-Expression "./Install.ps1 -PowerShellProfile -Fonts -WindowsTerminalProfile -StarshipProfile"
    Pop-Location
}