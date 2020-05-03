# Terminal stuff

Don't run this before cloning the machine repository properly.

## Prerequisites

* [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal-preview/9n0dx20hk701) (Installed from Windows Store)
* [Starship](https://starship.rs/) (Installed via Cargo)

## Installation

To install, run the following script from an administrator PowerShell prompt:

```
> .\Install.ps1 -PowerShellProfile -WindowsTerminalProfile -StarshipProfile -Fonts -Force
```

Or, to install everything:

```
> .\Install.ps1 -All
```