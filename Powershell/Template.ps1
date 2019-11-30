$Global:SourceLocation = ""
$Global:AzureDevOpsSourceLocation = ""
$Global:BitBucketSourceLocation = ""
$Global:GitLabSourceLocation = ""

. D:/Source/github/patriksvensson/posh-profile/Profile.ps1
#. D:/Source/github/patriksvensson/posh-profile/Prompt.ps1

Enter-GitHubLocation
Clear-Host
Invoke-Expression (&starship init powershell)