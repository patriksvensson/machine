# Wrap the prompt by default
$Global:WrapPrompt = $true;
$Global:WindowTitle = $null;

# The prompt
Function Global:Prompt() {
    # Store the last exit code
    $REALLASTEXITCODE = $LASTEXITCODE

    # Not at top row? Check if we should insert a blank space
    if ($host.UI.RawUI.CursorPosition.Y -ge 1) {
        $previousY = $host.UI.RawUI.CursorPosition.Y - 1
        $rect = New-Object System.Management.Automation.Host.Rectangle(0, $previousY, $host.UI.RawUI.BufferSize.Width, $previousY)
        $content = $host.UI.RawUI.GetBufferContents($rect)
        $writeNewLine = $false;
        for ($i = 0; $i -lt $host.UI.RawUI.BufferSize.Width; $i++) {
            $character = $content[$i, 0].Character
            if ($character -ne ' ' -and $null -ne $character) {
                $writeNewLine = $true;
                break;
            }
        }
        if ($writeNewLine) {
            Write-Host "  "
        }
    }

    # User and computer name
    Write-Host ([Environment]::UserName) -n -f ([ConsoleColor]::Cyan)
    Write-Host "@" -n
    Write-Host ([net.dns]::GetHostName()) -n -f ([ConsoleColor]::Green)

    # Current path
    Write-Host " " -n
    Write-Host "[" -nonewline -f ([ConsoleColor]::Yellow)
    Write-Host($pwd.Path) -nonewline
    Write-Host "]" -n -f ([ConsoleColor]::Yellow)

    # Git status
    if ($Global:PoShGitInstalled) {
        Write-VcsStatus
    }

    # Show stack
    if ((get-location -stack).Count -gt 0) {
        write-host " " -NoNewLine
        write-host (("+" * ((get-location -stack).Count))) -NoNewLine -ForegroundColor Cyan
    }

    # New line
    Write-Host ""

    # Print exit code
    if ($REALLASTEXITCODE -ne 0) {
        write-host " X $REALLASTEXITCODE " -NoNewLine -BackgroundColor DarkRed -ForegroundColor Yellow
        write-host " " -NoNewline
    }

    # Prompt
    $windowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $windowsPrincipal = new-object 'System.Security.Principal.WindowsPrincipal' $windowsIdentity
    $IsAdministrator = $windowsPrincipal.IsInRole("Administrators") -eq 1;
    $PromptColor = if ($IsAdministrator) {[ConsoleColor]::Red} Else {[ConsoleColor]::Green}
    Write-Host (get-date).ToString('HH:mm:ss') -n -f DarkYellow
    Write-Host " " -n
    Write-Host "" -n -f ($PromptColor)

    # Set the window title
    if ($null -eq $Global:WindowTitle) {
        $CurrentPath = $pwd.ProviderPath
        $CustomWindowTitle = if ($IsAdministrator) {"[Admin] " + $CurrentPath} Else {$CurrentPath}
        $host.UI.RawUI.WindowTitle = $CustomWindowTitle;
    }
    else {
        $CustomWindowTitle = if ($IsAdministrator) {"[Admin] " + $Global:WindowTitle} Else {$Global:WindowTitle}
        $host.UI.RawUI.WindowTitle = $CustomWindowTitle;
    }

    $global:LASTEXITCODE = $REALLASTEXITCODE
    return " "
}
