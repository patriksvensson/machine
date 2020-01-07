Function Assert-Administrator([string]$FailMessage) {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if(!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
        Throw $FailMessage
    }
}

Function Assert-CommandExists([string]$CommandName) {
    $Old = $ErrorActionPreference;
    try {
        if (Get-Command $CommandName) {
            Return $true;
        }
        Return $false;
    } catch {
        Return $false;
    } finally {
        $ErrorActionPreference = $Old;
    }
}