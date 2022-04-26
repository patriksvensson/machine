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
Function Enter-DefaultSourceLocation { Enter-SourceLocation -Provider "Default" -Path $Global:SourceLocation }
Function Enter-GitHubLocation { Enter-SourceLocation -Provider "GitHub" -Path $Global:GitHubSourceLocation }
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

Function View-On-GitHub {
    &gh repo view --web
}

# For fun
Function Get-DadJoke {
    # Created by @steviecoaster
    $header = @{ Accept = "application/json" }
    $joke = Invoke-RestMethod -Uri "https://icanhazdadjoke.com/" -Method Get -Headers $header 
    return $joke.joke
}

# Aliases
Set-Alias gs Enter-DefaultSourceLocation
Set-Alias github Enter-GitHubLocation
Set-Alias azure Enter-AzureDevOpsLocation
Set-Alias bitbucket Enter-BitBucketLocation
Set-Alias gitlab Enter-GitLabLocation

Set-Alias open start
Set-Alias sudo gsudo
Set-Alias ccl Copy-CurrentLocation
Set-Alias mcd New-Directory
Set-Alias ghv View-On-GitHub

Set-Alias dad-joke Get-DadJoke
