Function Install-RemoteFile {
    [CmdletBinding()]
    param(
        [string]$Url,
        [string]$Filename,
        [string]$Arguments,
        [switch]$RefreshEnvVars
    )

    $DownloadDirectory = "$HOME/Downloads";
    $DownloadedFile = "$DownloadDirectory/$Filename";

    # Download the file
    $Client = New-Object System.Net.WebClient;
    $Client.DownloadFile($Url, $DownloadedFile);

    # Run the file.
    Start-Process -FilePath $DownloadedFile -NoNewWindow -Wait -ArgumentList $Arguments;

    # Refresh environemnt variables?
    if ($RefreshEnvVars.IsPresent)
    {
        RefreshEnv | Out-Null;
    }
}