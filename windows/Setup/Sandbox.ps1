##########################################################################
# Install Windows Sandbox
##########################################################################

if($env:UserName -eq "WDAGUtilityAccount") {
    Write-Host "Sorry, can't install Windows Sandbox in a Windows Sandbox.";
    Return;
}

Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online