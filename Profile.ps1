# Load PoShGit
$Global:PoShGitInstalled = (Get-Module -ListAvailable -Name posh-git)
if($Global:PoShGitInstalled) {
    Import-Module posh-git
    Pop-Location
    Start-SshAgent -Quiet
    Push-Location
} else {
    Write-Host "PoSh-Git has not been installed."
}

# Load PoShFuck
$Global:PoShFuckInstalled = (Get-Module -ListAvailable -Name PoShFuck)
if($Global:PoShFuckInstalled) {
    Import-Module PoShFuck
} else {
    Write-Host "PoShFuck has not been installed.";
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
    
    # Prompt
    Write-Host " >" -n
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

# Goes to the git repository directory.
Function Enter-GitLocation()
{
    if([string]::IsNullOrWhiteSpace($Global:GitLocation)) {
        Write-Host "Git location has not been set."
        return
    }
    Set-Location $Global:GitLocation
}

# Aliases
Set-Alias open start
Set-Alias ccl Copy-CurrentLocation
Set-Alias gg Enter-GitLocation
Set-Alias fan fuck
Set-Alias helvete fuck
Set-Alias fan! fuck!
Set-Alias helvete! fuck!
Set-Alias build ./build.ps1