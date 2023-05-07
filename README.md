# Powershell Profile

## Prerequisites

This powershell profile has been designed for Powershell 7+, which can be installed using:

```ps1
winget install --id=Microsoft.PowerShell
```

And [Oh-My-Posh](https://ohmyposh.dev) which can be installed using:

```ps1
winget install --id=JanDeDobbeleer.OhMyPosh
```

## Installation

To install this profile, use the following command to clone it into your Powershell profile directory and then restart your terminal to begin using:

```ps1
git clone https://github.com/eglavin/powershell-profile.git (Split-Path -parent $PROFILE)
```

**Warning**: This command won't work if you currently have an existing profile setup.

## Post-Install Powershell Modules

The following Powershell Modules are also required to be installed:

- [Terminal-Icons](https://github.com/devblackops/Terminal-Icons)
- [Posh-Git](https://github.com/dahlbyk/posh-git)

```ps1
Install-Module -Name "Terminal-Icons" -Scope CurrentUser -Force
Install-Module -Name "posh-git" -Scope CurrentUser -Force
```

## Fonts (Optional)

Setup terminal fonts using Oh-My-Posh in an administrator window.

Fonts to install:

- [FiraCode](https://github.com/tonsky/FiraCode)
- [Meslo](https://github.com/andreberg/Meslo-Font)

```ps1
oh-my-posh font install FiraCode
oh-my-posh font install Meslo
```


## Local Overrides

Creating the following file in this folder allows adding local overrides to this profile.

`Microsoft.PowerShell_profile.local.ps1`
