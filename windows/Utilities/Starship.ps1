Function Assert-StarshipInstalled() {
    $StarshipVersion = starship --version;
    $IsInstalled = $null -ne $StarshipVersion -and $StarshipVersion -ne "";
    if (!$IsInstalled) {
        Throw "Starship have not been installed.";
    }
}