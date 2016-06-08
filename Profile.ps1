# Wrap the prompt by default.
$Global:WrapPrompt = $true;

# Load PoSh-Git.
$Global:PoShGitInstalled = (Get-Module -ListAvailable -Name posh-git)
if($Global:PoShGitInstalled) {
    Import-Module posh-git
    Pop-Location
    Start-SshAgent -Quiet
    Push-Location
} else {
    Write-Host "PoSh-Git has not been installed."
}

# The prompt
Function Global:Prompt()
{
    # Store the last exit code.
    $REALLASTEXITCODE = $LASTEXITCODE

    # User and computer name
    Write-Host ([Environment]::UserName) -n -f ([ConsoleColor]::Cyan)
    Write-Host "@" -n
    Write-Host ([net.dns]::GetHostName()) -n -f ([ConsoleColor]::Green)

    # Current path
    Write-Host " " -n
    Write-Host "[" -nonewline -f ([ConsoleColor]::Yellow)
    Write-Host($pwd.ProviderPath) -nonewline
    Write-Host "]" -n -f ([ConsoleColor]::Yellow)

    # Git status
    if($Global:PoShGitInstalled) {
        Write-VcsStatus
    }

    # Define the prompt.
    $Prompt = " >";

    # Should we add a line break before the prompt?
    if($Global:WrapPrompt -eq $true) {
        $CursorPosition = $host.ui.rawui.CursorPosition.X
        $BufferWidth = $Host.UI.RawUI.BufferSize.Width
        $Threshold = $BufferWidth / 4;
        if($CursorPosition -gt ($BufferWidth - $Threshold)) {
            $Prompt = "$";
            Write-Host ""
        }
    }

    # Prompt
    Write-Host $Prompt -n -f ([ConsoleColor]::Green)
    $global:LASTEXITCODE = $REALLASTEXITCODE
    return " "
}

# Copies the current location to the clipboard.
Function Copy-CurrentLocation()
{
    $Result = (Get-Location).Path | clip.exe
    Write-Host "Copied current location to clipboard."
    return $Result
}

# Creates a new directory and enters it.
Function New-Directory([string]$Name)
{
    $Directory = New-Item -Path $Name -ItemType Directory;
    if(Test-Path $Directory) {
        Set-Location $Name;
    }
}

# Goes to the git repository directory.
Function Enter-SourceLocation()
{
    if([string]::IsNullOrWhiteSpace($Global:SourceLocation)) {
        Write-Host "Source location has not been set."
        return
    }
    Set-Location $Global:SourceLocation
}

# Aliases
Set-Alias open start
Set-Alias ccl Copy-CurrentLocation
Set-Alias gs Enter-SourceLocation
Set-Alias mcd New-Directory
Set-Alias build ./build.ps1