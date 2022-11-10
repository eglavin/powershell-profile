# https://github.com/joonro/Get-ChildItemColor
Import-Module Get-ChildItemColor

# https://ohmyposh.dev/
oh-my-posh init pwsh | Invoke-Expression
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/hotstick.minimal.omp.json" | Invoke-Expression

# https://github.com/dahlbyk/posh-git
$env:POSH_GIT_ENABLED = $true 

# https://github.com/lptstr/winfetch
Set-Alias winfetch pwshfetch-test-1 


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

Set-Alias l Get-ChildItemColor -option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -option AllScope
function ll { 
  Get-ChildItemColor -Force 
}
function la {
  Get-ChildItemColorFormatWide -Force
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
  Get-ChildItemColorFormatWide -Force
}

# Make directory and change into it
function mkcd {
  param ([string]$dir)
  New-Item -Path .\$dir -ItemType Directory
  Set-Location -Path .\$dir
}


# Application commands
#

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
#

function U {
  param
  (
    [int] $Code
  )
 
  if ((0 -le $Code) -and ($Code -le 0xFFFF)) {
    return [char] $Code
  }
 
  if ((0x10000 -le $Code) -and ($Code -le 0x10FFFF)) {
    return [char]::ConvertFromUtf32($Code)
  }
 
  throw "Invalid character code $Code"
}


Clear-Host
