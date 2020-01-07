. (Join-Path $PSScriptRoot "Store.ps1")

Function Assert-WindowsTerminalInstalled() {
    if (!(Test-WindowsTerminal)) {
        Throw "Windows Terminal have not been installed."
    }
}

Function Test-WindowsTerminal() {
    $Path = Get-WindowsStoreAppPath -App "Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState";
    return Test-Path -Path $Path -PathType Container;
}
