# Initialisation

$PROFILE_DIR = Split-Path -parent $PROFILE;
$env:POSH_GIT_ENABLED = $true

Set-Alias g git -Option AllScope
Set-PSReadLineOption -HistoryNoDuplicates -PredictionSource HistoryAndPlugin -PredictionViewStyle ListView

Import-Module -Name Posh-Git
oh-my-posh init pwsh --config "$PROFILE_DIR/hotstick.minimal.omp.json" | Invoke-Expression


# Directory shortcuts

Remove-Item -force alias:ls
function .. { Set-Location .. }
function cdl ([string] $dir = '.') {
  Set-Location $dir
  Get-ChildItem | Format-Wide -AutoSize
}
function l { Get-ChildItem $args | Format-Wide -AutoSize }
function ls { Get-ChildItem $args | Format-Wide -AutoSize }
function la { Get-ChildItem -Force $args | Format-Wide -AutoSize }
function ll { Get-ChildItem -Force $args }
function lt { Get-ChildItem -Force $args | Sort-Object LastWriteTime -Descending }


# Git command shortcuts

function GitPushBranch { git push -u origin (git branch --show) }
function GitOpenRemote {
  $url = git config --get remote.origin.url
  if ($url -Match "@") {
    Start-Process "https://$($url.Split("@")[1])" # Fix for Azure Devops repos with config url like https://{org}@{url}
  }
  else {
    Start-Process $url
  }
}
function GitWhoAmI {
  Write-Host "Name: $(git config --global user.name)"
  Write-Host "Email: $(git config --global user.email)"
}

Set-Alias gitpb GitPushBranch -Option AllScope
Set-Alias gitor GitOpenRemote -Option AllScope


# Docker command shortcuts

function DockerConnectContainer { docker exec -it $args bash }
function DockerComposeLogs { docker-compose logs -f }
function DockerComposePull { docker-compose pull }
function DockerComposeRestart {
  docker-compose stop
  docker-compose up -d
}
function DockerComposeRemove { docker-compose rm -f -s }
function DockerComposeStop { docker-compose stop }
function DockerComposeUp { docker-compose up -d }

Set-Alias dce DockerConnectContainer -Option AllScope
Set-Alias dcl DockerComposeLogs -Option AllScope
Set-Alias dcp DockerComposePull -Option AllScope
Set-Alias dcr DockerComposeRestart -Option AllScope
Set-Alias dcrm DockerComposeRemove -Option AllScope
Set-Alias dcs DockerComposeStop -Option AllScope
Set-Alias dcup DockerComposeUp -Option AllScope


# Other command shortcuts

function OpenCodeHere { code . }
function OpenCodeInsidersHere { code-insiders . }
function OpenExplorerHere { explorer . }
function GetMyIp { Write-Host (Invoke-WebRequest ifconfig.me/ip).Content.Trim() }
function UseNvimOrVim {
  if (Get-Command nvim -errorAction SilentlyContinue) {
    nvim $args
  }
  else {
    vim $args
  }
}
function GetVisualStudioLocation {
  # Determining Installed Visual Studio Path for 2017 https://stackoverflow.com/a/54729540
  return Get-ItemPropertyValue -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\devenv.exe" -Name "(Default)";
}
function OpenVisualStudioHere { Start-Process (GetVisualStudioLocation) . }
function OpenVisualStudioProjectHere {
  $sln = Get-ChildItem *.sln
  if (!$sln) {
    Write-Error "No solution file found"
  }
  else {
    Start-Process (GetVisualStudioLocation) $($sln)[0]
  }
}
function OpenWindowsTerminalHere { wt -d . }
function ReloadPSEnvironment {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

Set-Alias c. OpenCodeHere -Option AllScope
Set-Alias ci. OpenCodeInsidersHere -Option AllScope
Set-Alias e. OpenExplorerHere -Option AllScope
Set-Alias ipme GetMyIp -Option AllScope
Set-Alias pn pnpm -Option AllScope
Set-Alias vi UseNvimOrVim -Option AllScope
Set-Alias vim UseNvimOrVim -Option AllScope
Set-Alias vs. OpenVisualStudioHere -Option AllScope
Set-Alias vsp. OpenVisualStudioProjectHere -Option AllScope
Set-Alias wt. OpenWindowsTerminalHere -Option AllScope


if (Test-Path -Path "$PROFILE_DIR\Microsoft.PowerShell_profile.local.ps1" -PathType Leaf) {
  # Check for a local profile
  . "$PROFILE_DIR\Microsoft.PowerShell_profile.local.ps1"
}
