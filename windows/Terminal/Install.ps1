[CmdletBinding(DefaultParameterSetName='Granular')]
Param(
    [Parameter(ParameterSetName='All')]
    [switch]$All,
    [Parameter(ParameterSetName='Granular')]
    [switch]$PowerShellProfile,
    [Parameter(ParameterSetName='Granular')]
    [switch]$Fonts,
    [Parameter(ParameterSetName='Granular')]
    [switch]$WindowsTerminalProfile,
    [Parameter(ParameterSetName='Granular')]
    [switch]$StarshipProfile,
    [Parameter(ParameterSetName='Granular')]
    [switch]$Force
)

. (Join-Path $PSScriptRoot "../Utilities/Fonts.ps1")
. (Join-Path $PSScriptRoot "../Utilities/Starship.ps1")
. (Join-Path $PSScriptRoot "../Utilities/Store.ps1")
. (Join-Path $PSScriptRoot "../Utilities/Terminal.ps1")
. (Join-Path $PSScriptRoot "../Utilities/Utilities.ps1")

# Nothing selected? Show help screen.
if (!$PowerShellProfile.IsPresent -and !$Fonts.IsPresent -and !$WindowsTerminalProfile.IsPresent `
    -and !$StarshipProfile.IsPresent -and !$All.IsPresent)
{
    Get-Help .\Install.ps1
    Exit;
}

#################################################################
# POWERSHELL
#################################################################

if($All.IsPresent -or $PowerShellProfile.IsPresent) {
    if(!(Test-Path $PROFILE) -or $Force.IsPresent -or $All.IsPresent) {
        # Update PowerShell profile
        Write-Host "Adding PowerShell profile...";
        $PowerShellProfileTemplatePath = Join-Path $PWD "PowerShell/Profile.template";
        $PowerShellProfilePath = (Join-Path $PWD "PowerShell/Roaming.ps1");
        Copy-Item -Path $PowerShellProfileTemplatePath -Destination $PROFILE;
        # Replace placeholder values
        (Get-Content -path $PROFILE -Raw) -Replace '<<PROFILE>>', $PowerShellProfilePath | Set-Content -Path $PROFILE
        (Get-Content -path $PROFILE -Raw) -Replace '<<SOURCELOCATION>>', "$($Global:SourceLocation)" | Set-Content -Path $PROFILE
        (Get-Content -path $PROFILE -Raw) -Replace '<<AZURELOCATION>>', "$($Global:AzureDevOpsSourceLocation)" | Set-Content -Path $PROFILE
        (Get-Content -path $PROFILE -Raw) -Replace '<<BITBUCKETLOCATION>>', "$($Global:BitBucketSourceLocation)" | Set-Content -Path $PROFILE
        (Get-Content -path $PROFILE -Raw) -Replace '<<GITLABLOCATION>>', "$($Global:GitLabSourceLocation)" | Set-Content -Path $PROFILE
    } else {
        Write-Host "PowerShell profile already exist.";
        Write-Host "Use the -Force switch to overwrite.";
    }
}

#################################################################
# WINDOWS TERMINAL
#################################################################

if($All.IsPresent -or $WindowsTerminalProfile.IsPresent) {
    Assert-Administrator -FailMessage "Installing Windows Terminal profile requires administrator privilegies.";
    Assert-WindowsTerminalInstalled;

    # Create symlink to Windows Terminal settings
    $TerminalProfileSource = Join-Path $PWD "Windows Terminal/profiles.json"
    $TerminalPath = Get-WindowsStoreAppPath -App "Microsoft.WindowsTerminal_8wekyb3d8bbwe";
    $TerminalProfileDestination = Join-Path $TerminalPath "LocalState/profiles.json";
    if(Test-Path $TerminalProfileDestination) {
        Remove-Item -Path $TerminalProfileDestination;
    }

    Write-Host "Creating symlink to Windows terminal settings..."
    New-Item -Path $TerminalProfileDestination -ItemType SymbolicLink -Value $TerminalProfileSource | Out-Null;

    # Set a user environment variable that contains the path to console images
    Write-Host "Setting environment 'WINDOWSTERMINAL_IMAGES' variable..."
    $ImagesPath = Join-Path $PWD "Images";
    [Environment]::SetEnvironmentVariable("WINDOWSTERMINAL_IMAGES", "$ImagesPath", "User")
}

#################################################################
# FONTS
#################################################################

if($All.IsPresent -or $Fonts.IsPresent) {
    # Install RobotoMono font
    Write-Host "Installing RobotoMono nerd font..."
    $FontPath = Join-Path $PWD "Windows Terminal/RobotoMono.ttf";
    Install-Font -FontPath $FontPath;
}

#################################################################
# STARSHIP
#################################################################

if($All.IsPresent -or $StarshipProfile.IsPresent) {
    Assert-Administrator -FailMessage "Installing Starship profile requires administrator privilegies.";
    Assert-StarshipInstalled;

    # Create symlink to Starship profile
    $StarshipSource = Join-Path $PWD "../shared/starship.toml";
    $StarshipConfigDirectory = Join-Path $env:USERPROFILE ".config";
    $StarshipConfigDestination = Join-Path $StarshipConfigDirectory "starship.toml";
    if(!(Test-Path $StarshipConfigDirectory)) {
        Write-Host "Creating ~/.config directory...";
        New-Item $StarshipConfigDirectory -ItemType Directory;
    }
    if(Test-Path $StarshipConfigDestination) {
        Remove-Item -Path $StarshipConfigDestination;
    }
    Write-Host "Creating symlink to Starship profile..."
    New-Item -Path $StarshipConfigDestination -ItemType SymbolicLink -Value $StarshipSource | Out-Null;
}