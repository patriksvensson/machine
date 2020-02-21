Function Assert-StarshipInstalled() {
    if (!(Test-Starship)) {
        Throw "Starship have not been installed."
    }
}

Function Test-Starship() {
    return Test-Path -Path (Join-Path $env:USERPROFILE ".cargo/bin/starship.exe");
}