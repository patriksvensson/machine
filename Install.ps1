Param(
    [switch]$SkipFont,
    [switch]$SkipWindowsTerminalProfile,
    [switch]$SkipStarship,
    [switch]$ForceProfile
)

# Load utilities.
. ./Scripts/Utilities.ps1

# Make sure all prereqs are there.
if (!(Test-WindowsTerminal)) {
    Throw "Windows Terminal have not been installed."
}
if (!(Test-Starship)) {
    Throw "Starship have not been installed."
}

# Make sure we're running as administrator.
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if(!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Throw "This script requires administrator permissions."
}

if(!(Test-Path $PROFILE) -or $ForceProfile.IsPresent) {
    # Update PowerShell profile
    Write-Host "Adding PowerShell profile..."
    $PowerShellProfileTemplate = Join-Path $PWD "PowerShell/Profile.template";
    $PowerShellProfile = Join-Path $PWD "PowerShell/Roaming.ps1"
    (Get-Content -path $PowerShellProfileTemplate -Raw) -replace '<<PROFILE>>', $PowerShellProfile `
        | Set-Content -Path $PROFILE
}

if(!$SkipWindowsTerminalProfile.IsPresent) {
    # Create symlink to Windows Terminal settings.
    $TerminalProfileSource = Join-Path $PWD "Windows Terminal/profiles.json"
    $TerminalPath = Get-WindowsStoreAppPath -App "Microsoft.WindowsTerminal_8wekyb3d8bbwe";
    $TerminalProfileDestination = Join-Path $TerminalPath "LocalState/profiles.json";
    if(Test-Path $TerminalProfileDestination) {
        Remove-Item -Path $TerminalProfileDestination;
    }
    Write-Host "Creating symlink to Windows terminal settings..."
    New-Item -Path $TerminalProfileDestination -ItemType SymbolicLink -Value $TerminalProfileSource | Out-Null;
}

if(!$SkipFont.IsPresent) {
    # Install RobotoMono font.
    Write-Host "Installing RobotoMono nerd font..."
    $FontPath = Join-Path $PWD "Windows Terminal/RobotoMono.ttf";
    Install-Font -FontPath $FontPath;
}

if(!$SkipStarship.IsPresent) {
    # Create symlink to Starship profile.
    $StarshipSource = Join-Path $PWD "Starship/starship.toml";
    $StarshipConfigDirectory = Join-Path $env:USERPROFILE ".config";
    $StarshipConfigDestination = Join-Path $StarshipConfigDirectory "starship.toml";
    if(!(Test-Path $StarshipConfigDirectory)) {
        Write-Host "Creating ~/.config directory..."
        New-Item $StarshipConfigDirectory -ItemType Directory;
    }
    if(Test-Path $StarshipConfigDestination) {
        Remove-Item -Path $StarshipConfigDestination;
    }
    Write-Host "Creating symlink to Starship profile..."
    New-Item -Path $StarshipConfigDestination -ItemType SymbolicLink -Value $StarshipSource | Out-Null;
}