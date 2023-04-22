# Powershell Profile

## Prerequisites

This powershell profile has been designed for Powershell 7+, which can be installed using:

```ps1
winget install --id=Microsoft.PowerShell
```

Once Powershell 7+ has been installed, Oh-My-Posh can be installed using:

```ps1
winget install --id=JanDeDobbeleer.OhMyPosh
```

The following Powershell modules are also required to be installed:

- Terminal-Icons
- Posh-Git

```ps1
Install-Module -Name "Terminal-Icons" -Scope CurrentUser -Force
Install-Module -Name "posh-git" -Scope CurrentUser -Force
```

## Local Overrides

Creating the following file in this folder allows adding local overrides to this profile.

`Microsoft.PowerShell_profile.local.ps1`
