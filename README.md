# Powershell Profile

## Prerequisites

The following things need to be installed to use this without errors being printed to the terminal on launch.

- Terminal-Icons
- Posh-Git

```ps1
Install-Module "Terminal-Icons" -Scope CurrentUser -Force
Install-Module "posh-git" -Scope CurrentUser -Force
```

## Local Overrides

Creating the following file in this folder allows adding local overrides to this profile.

`Microsoft.PowerShell_profile.local.ps1`
