[CmdletBinding(DefaultParameterSetName='Prereqs')]
Param(
    [Parameter(ParameterSetName='Prereqs')]
    [switch]$Prereqs,
    [Parameter(ParameterSetName='Software')]
    [switch]$Ubuntu,
    [Parameter(ParameterSetName='Software')]
    [switch]$Apps,
    [Parameter(ParameterSetName='Software')]
    [switch]$VisualStudioExtensions
)

# Nothing selected? Show help screen.
if (!$Prereqs.IsPresent -and !$Ubuntu.IsPresent -and !$Apps.IsPresent `
    -and !$VisualStudioExtensions.IsPresent)
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

if ($Prereqs.IsPresent) {
    Install-BoxstarterPackage ./Setup/Prereqs.ps1 -DisableReboots
    RefreshEnv
}
if ($Apps.IsPresent) {
    Install-BoxstarterPackage ./Setup/Apps.ps1 -DisableReboots
    RefreshEnv
}
if ($VisualStudioExtensions.IsPresent) {
    Install-BoxstarterPackage ./Setup/VS-Extensions.ps1 -DisableReboots
    RefreshEnv
}
if ($Ubuntu.IsPresent) {
    Install-BoxstarterPackage ./Setup/Ubuntu.ps1 -DisableReboots
    RefreshEnv
}