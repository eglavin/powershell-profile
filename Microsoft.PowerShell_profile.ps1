$PROFILE_DIR = (Get-Item $PROFILE).DirectoryName;

# Initialisation
#

# https://github.com/devblackops/Terminal-Icons
Import-Module -Name Terminal-Icons

Set-Alias g git -Option AllScope
# https://github.com/dahlbyk/posh-git/#installation
Import-Module -Name Posh-Git

# https://learn.microsoft.com/en-us/powershell/module/psreadline/set-psreadlineoption
$PSReadLineOptions = @{
  EditMode                      = "Windows"
  PredictionSource              = "History"
  PredictionViewStyle           = "ListView"
  HistoryNoDuplicates           = $true
  HistorySearchCursorMovesToEnd = $true
  MaximumHistoryCount           = 5
}
Set-PSReadLineOption @PSReadLineOptions

# https://github.com/dahlbyk/posh-git
$env:POSH_GIT_ENABLED = $true

# https://ohmyposh.dev/
oh-my-posh init pwsh --config "$PROFILE_DIR/hotstick.minimal.omp.json" | Invoke-Expression


# Delete default powershell aliases that conflict with git bash commands
if (get-command git) {
  Remove-Item -force alias:cat
  Remove-Item -force alias:clear
  Remove-Item -force alias:cp
  Remove-Item -force alias:diff
  Remove-Item -force alias:echo
  Remove-Item -force alias:kill
  Remove-Item -force alias:ls
  Remove-Item -force alias:mv
  Remove-Item -force alias:ps
  Remove-Item -force alias:pwd
  Remove-Item -force alias:rm
  Remove-Item -force alias:sleep
  Remove-Item -force alias:tee
}

# Reload powershell environment
function rldpsenv {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# Bash style list directory listing
#

function l {
  param ([string] $dir)
  Get-ChildItem $dir
}
function ls {
  param ([string] $dir)
  Get-ChildItem $dir | Format-Wide -AutoSize
}
function ll {
  param ([string] $dir)
  Get-ChildItem -Force $dir
}
function la {
  param ([string] $dir)
  Get-ChildItem -Force $dir | Format-Wide -AutoSize
}
function .. {
  Set-Location ..
}
function e. {
  explorer .
}

# Change into directory and list content
function cl {
  param ([string] $dir)
  if (!$dir) {
    $dir = Get-Location
  }
  Set-Location $dir
  Get-ChildItem | Format-Wide -AutoSize
}

# Make directory and change into it
function mkcd {
  param ([string] $dir)
  if ($dir) {
    New-Item -Path $dir -ItemType Directory
    Set-Location -Path $dir
  }
  else {
    Write-Error "No directory name provided"
  }
}


# Application commands
#

Set-Alias winfetch pwshfetch-test-1 # https://github.com/lptstr/winfetch
function c. {
  code .
}
function ci. {
  code-insiders .
}
function Get-VisualStudio-Location {
  # Determining Installed Visual Studio Path for 2017
  # https://stackoverflow.com/a/54729540
  $regKey = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\devenv.exe"
  $visualStudioDir = Get-ItemPropertyValue -Path $regKey -Name "(Default)"
  return $visualStudioDir;
}
function vs. {
  Start-Process (Get-VisualStudio-Location) .
}
function vsp. {
  $sln = Get-ChildItem *.sln
  if (!$sln) {
    Write-Error "No solution file found"
  }
  else {
    Write-Host "Opening $(($sln)[0])"
    Start-Process (Get-VisualStudio-Location) $($sln)[0]
  }
}
function wt. {
  wt -d "$(get-item .)"
}
function ipme {
  $ipaddr = Invoke-WebRequest ifconfig.me/ip
  Write-Host $ipaddr.Content.Trim()
}


# Common Node command shortcuts
#

function ns {
  npm start
}
function ys {
  yarn start
}
function yd {
  yarn dev
}
function yu {
  yarn upgrade-interactive --latest
}
function yt {
  yarn test
}
function yta {
  yarn test:all
}
function ytc {
  yarn test:cover
}
function ytca {
  yarn test:cover:all
}
function yts {
  yarn test:snap
}
Set-Alias pn pnpm -Option AllScope


# Common Git command shortcuts
#

function gitp {
  git pull
}
function gitb {
  git branch
}
function gita {
  param ([Parameter(ValueFromRemainingArguments = $true)] [string[]] $files)
  if ($files) {
    git add $files
  }
  else {
    Write-Error "No files provided"
  }
}
function gitc {
  param ([string] $branch)
  if ($branch) {
    git checkout $branch
  }
  else {
    Write-Error "No branch provided"
  }
}
function gbpush {
  $branch = git rev-parse --abbrev-ref HEAD
  git push -u origin $branch
}
function gitor {
  $url = git config --get remote.origin.url
  Start-Process $url
}
function gitwhoami {
  Write-Host "Name: $(git config --global user.name)"
  Write-Host "Email: $(git config --global user.email)"
}


# Common Docker command shortcuts
#

function dcp {
  docker-compose pull
}
function dcs {
  docker-compose stop
}
function dcup {
  docker-compose up -d
}
function dcrm {
  docker-compose rm -f -s
}


# Helper function to show Unicode character
function U {
  param ([int] $Code)

  if ((0 -le $Code) -and ($Code -le 0xFFFF)) {
    return [char] $Code
  }
  if ((0x10000 -le $Code) -and ($Code -le 0x10FFFF)) {
    return [char]::ConvertFromUtf32($Code)
  }
  throw "Invalid character code $Code"
}


# Check if a local profile override is set and invoke it if so.
if (Test-Path -Path "$PROFILE_DIR\Microsoft.PowerShell_profile.local.ps1" -PathType Leaf) {
  . "$PROFILE_DIR\Microsoft.PowerShell_profile.local.ps1"
}

# Clear-Host
