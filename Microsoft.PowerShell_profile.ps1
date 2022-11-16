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
oh-my-posh init pwsh | Invoke-Expression
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/atomic.omp.json" | Invoke-Expression


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


# Bash style list directory listing
#

function l {
  Get-ChildItem
}
function ls {
  Get-ChildItem | Format-Wide -AutoSize
}
function ll { 
  Get-ChildItem -Force
}
function la {
  Get-ChildItem -Force | Format-Wide -AutoSize
}
function .. { 
  Set-Location .. 
}
function e. {
  explorer . 
}

# Change into directory and list content
function cl {
  param ([string]$dir)
  Set-Location $dir
  Get-ChildItem | Format-Wide -AutoSize
}

# Make directory and change into it
function mkcd {
  param ([string]$dir)
  New-Item -Path $dir -ItemType Directory
  Set-Location -Path $dir
}


# Application commands
#

Set-Alias winfetch pwshfetch-test-1 # https://github.com/lptstr/winfetch
function c. {
  code . 
}
function ipme {
  Invoke-WebRequest ifconfig.me 
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
function ytc {
  yarn test:cover
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
  param ([string]$file)
  git add $file
}
function gitc {
  param ([string]$branch)
  git checkout $branch
}
function gbpush {
  $branch = git rev-parse --abbrev-ref HEAD
  git push -u origin $branch
}
function gitor {
  $url = git config --get remote.origin.url
  Start-Process $url
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
$PROFILE_DIR = (Get-Item $PROFILE).DirectoryName;
$LOCAL_PROFILE_OVERRIDES = "$PROFILE_DIR\Microsoft.PowerShell_profile.local.ps1";

if (Test-Path -Path $LOCAL_PROFILE_OVERRIDES -PathType Leaf) {
  . $LOCAL_PROFILE_OVERRIDES
}

# Clear-Host
