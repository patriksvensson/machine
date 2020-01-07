Function Get-WindowsStoreAppPath([string]$App) {
    $Packages = Join-Path $Env:LOCALAPPDATA "Packages";
    return Join-Path $Packages $App;
}