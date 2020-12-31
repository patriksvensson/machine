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
    [switch]$OhMyPosh,
    [switch]$Force
)

. (Join-Path $PSScriptRoot "../Utilities/Fonts.ps1")
. (Join-Path $PSScriptRoot "../Utilities/Starship.ps1")
. (Join-Path $PSScriptRoot "../Utilities/Store.ps1")
. (Join-Path $PSScriptRoot "../Utilities/Terminal.ps1")
. (Join-Path $PSScriptRoot "../Utilities/Utilities.ps1")

# Nothing selected? Show help screen.
if (!$PowerShellProfile.IsPresent -and !$Fonts.IsPresent -and !$WindowsTerminalProfile.IsPresent `
    -and !$OhMyPosh.IsPresent -and !$All.IsPresent)
{
    Get-Help .\Install.ps1
    Exit;
}

$Architecture = (Get-WmiObject Win32_OperatingSystem).OSArchitecture;
$IsArm = $false;
if($Architecture.StartsWith("ARM")) {
    $IsArm = $true;
}

#################################################################
# POWERSHELL
#################################################################

if($All.IsPresent -or $PowerShellProfile.IsPresent) {
    if(!(Test-Path $PROFILE) -or $Force.IsPresent -or $All.IsPresent) {
        # Update PowerShell profile
        Write-Host "Adding PowerShell profile...";
        $MachinePath = (Get-Item (Join-Path $PSScriptRoot "../../")).FullName
        $PowerShellProfileTemplatePath = Join-Path $PSScriptRoot "PowerShell/Profile.template";
        $PowerShellProfilePath = (Join-Path $PSScriptRoot "PowerShell/Roaming.ps1");
        $PowerShellPromptPath = (Join-Path $PSScriptRoot "PowerShell/Prompt.ps1");
        $PowerShellLocalProfilePath = Join-Path (Get-Item $PROFILE).Directory.FullName "LocalProfile.ps1"
        Copy-Item -Path $PowerShellProfileTemplatePath -Destination $PROFILE;
        # Replace placeholder values
        (Get-Content -path $PROFILE -Raw) -Replace '<<MACHINE>>', $MachinePath | Set-Content -Path $PROFILE
        (Get-Content -path $PROFILE -Raw) -Replace '<<PROFILE>>', $PowerShellProfilePath | Set-Content -Path $PROFILE
        (Get-Content -path $PROFILE -Raw) -Replace '<<PROMPT>>', $PowerShellPromptPath | Set-Content -Path $PROFILE
        (Get-Content -path $PROFILE -Raw) -Replace '<<LOCALPROFILE>>', $PowerShellLocalProfilePath | Set-Content -Path $PROFILE
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
    $TerminalProfileSource = Join-Path $PWD "../../config/windows_terminal.json"
    $TerminalPath = Get-WindowsStoreAppPath -App "Microsoft.WindowsTerminal_8wekyb3d8bbwe";
    $TerminalProfileDestination = Join-Path $TerminalPath "LocalState/settings.json";
    if(Test-Path $TerminalProfileDestination) {
        Remove-Item -Path $TerminalProfileDestination;
    }

    Write-Host "Creating symlink to Windows terminal settings..."
    New-Item -Path $TerminalProfileDestination -ItemType SymbolicLink -Value $TerminalProfileSource | Out-Null;

    # Set a user environment variable that contains the path to console images
    Write-Host "Setting environment 'WINDOWSTERMINAL_IMAGES' variable..."
    $ImagesPath = Join-Path $PWD "Images";
    [Environment]::SetEnvironmentVariable("WINDOWSTERMINAL_IMAGES", "$ImagesPath", "User")

    Write-Host "Setting environment 'WINDOWSTERMINAL_ICONS' variable..."
    $IconsPath = Join-Path $PWD "Icons";
    [Environment]::SetEnvironmentVariable("WINDOWSTERMINAL_ICONS", "$IconsPath", "User")
}

#################################################################
# FONTS
#################################################################

if($All.IsPresent -or $Fonts.IsPresent) {
    # Install RobotoMono font
    Write-Host "Installing RobotoMono nerd font..."
    $FontPath = Join-Path $PWD "Fonts/CaskaydiaCoveMono.ttf";
    Install-Font -FontPath $FontPath;
}

#################################################################
# OH-MY-POSH
#################################################################

if($All.IsPresent -or $OhMyPosh.IsPresent) {
    if($IsArm) {
        # Not yet supported on ARM
        Write-Host "Oh-My-Posh is not supported on ARM"
    } else {
        $OhMyPoshPath = "$env:LOCALAPPDATA\Oh-My-Posh"
        $OhMyPoshExe = Join-Path $OhMyPoshPath "oh-my-posh.exe"
    
        # Download?
        if(!(Test-Path $OhMyPoshExe) -or $Force.IsPresent) {
            Write-Host "Downloading Oh-My-Posh..."
            New-Item -Path $env:LOCALAPPDATA\Oh-My-Posh -ItemType Directory -ErrorAction Ignore | Out-Null
    
            if(Test-Path $OhMyPoshExe) {
                Remove-Item $OhMyPoshExe | Out-Null
            }
    
            Invoke-Webrequest "https://github.com/JanDeDobbeleer/oh-my-posh3/releases/latest/download/posh-windows-amd64.exe" -OutFile $OhMyPoshExe
        } else {
            Write-Debug "Oh-My-Posh already installed"
        }
        
        # Add to PATH?
        $CurrentPath = [System.Environment]::GetEnvironmentVariable("PATH", "User");
        if(!($CurrentPath -like "*$OhMyPoshPath*")) {
            Write-Host "Setting PATH variable..."
            [Environment]::SetEnvironmentVariable("PATH", "$CurrentPath;$OhMyPoshPath", "User")
        } else {
            Write-Debug "PATH variable already set"
        }
    }
}