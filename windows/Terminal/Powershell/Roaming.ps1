Function Find-Files([string]$Pattern) {
    if ($null -ne $Pattern -and $Pattern -ne "") {
        Get-Childitem -Include $Pattern -File -Recurse -ErrorAction SilentlyContinue `
        | ForEach-Object { Resolve-Path -Relative $_ | Write-Host }
    }
}

Function Test-Arm() {
    $Architecture = (Get-WmiObject Win32_OperatingSystem).OSArchitecture;
    if ($Architecture.StartsWith("ARM")) {
        return $true;
    }
    return $false;
}

Function Set-As([Parameter(Mandatory = $true)][string]$Name) {
    New-PSDrive -PSProvider FileSystem -Name $Name -Root . -Scope Global | Out-Null
    Set-Location -LiteralPath "$($Name):"
}

# Add virtual drives for projects
Function Add-VirtualDrive([string]$Path, [string]$Name) {
    Push-Location
    Set-Location $Path
    Set-As $Name
    Pop-Location
}

Function Clear-Docker() {
    & docker ps -a -q | ForEach-Object { docker rm $_ }
    & docker images -q | ForEach-Object { docker rmi $_ }
    & docker system prune --all --force
}

# Copies the current location to the clipboard
Function Copy-CurrentLocation() {
    $Result = (Get-Location).Path | clip.exe
    Write-Host "Copied current location to clipboard."
    return $Result
}

# Creates a new directory and enters it
Function New-Directory([string]$Name) {
    $Directory = New-Item -Path $Name -ItemType Directory;
    if (Test-Path $Directory) {
        Set-Location $Name;
    }
}

# Source location shortcuts
Function Enter-GitHubLocation { Enter-SourceLocation -Provider "GitHub" -Path $Global:SourceLocation }
Function Enter-AzureDevOpsLocation { Enter-SourceLocation -Provider "Azure DevOps" -Path $Global:AzureDevOpsSourceLocation }
Function Enter-BitBucketLocation { Enter-SourceLocation -Provider "BitBucket" -Path $Global:BitBucketSourceLocation }
Function Enter-GitLabLocation { Enter-SourceLocation -Provider "GitLab" -Path $Global:GitLabSourceLocation }
Function Enter-SourceLocation([string]$Provider, [string]$Path) {
    if ([string]::IsNullOrWhiteSpace($Path)) {
        Write-Host "The source location for $Provider have not been set."
        return
    }
    Set-Location $Path
}

# Set window title
Function Set-WindowTitle([string]$Title) {
    $host.ui.RawUI.WindowTitle = $Title
}

# For fun
Function Get-DadJoke {
    # Created by @steviecoaster
    $header = @{ Accept = "application/json" }
    $joke = Invoke-RestMethod -Uri "https://icanhazdadjoke.com/" -Method Get -Headers $header 
    return $joke.joke
}

# Aliases
Set-Alias open start
Set-Alias ccl Copy-CurrentLocation
Set-Alias github Enter-GitHubLocation
Set-Alias gs Enter-GitHubLocation
Set-Alias azure Enter-AzureDevOpsLocation
Set-Alias bitbucket Enter-BitBucketLocation
Set-Alias gitlab Enter-GitLabLocation
Set-Alias mcd New-Directory
Set-Alias back popd
Set-Alias sw Set-WindowTitle
Set-Alias f Find-Files
Set-Alias dad-joke Get-DadJoke
