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

## Installation

To install this profile, use the following command to clone it into your Powershell profile directory and then restart your terminal to begin using:

```ps1
git clone https://github.com/eglavin/powershell-profile.git (Split-Path -parent $PROFILE)
```

The following Powershell modules are also required to be installed:

- Terminal-Icons
- Posh-Git

```ps1
Install-Module -Name "Terminal-Icons" -Scope CurrentUser -Force
Install-Module -Name "posh-git" -Scope CurrentUser -Force
```

## Fonts (Optional)

Setup terminal fonts using Oh-My-Posh in an administrator window.

Fonts to install:

- FiraCode
- Meslo

```ps1
oh-my-posh font install FiraCode
oh-my-posh font install Meslo
```


## Local Overrides

Creating the following file in this folder allows adding local overrides to this profile.

`Microsoft.PowerShell_profile.local.ps1`
