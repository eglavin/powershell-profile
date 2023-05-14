$PROFILE_DIR = Split-Path -parent $PROFILE;

# Initialisation
#

Import-Module -Name Terminal-Icons

Set-Alias g git -Option AllScope
Import-Module -Name Posh-Git

$env:POSH_GIT_ENABLED = $true
oh-my-posh init pwsh --config "$PROFILE_DIR/hotstick.minimal.omp.json" | Invoke-Expression

# https://learn.microsoft.com/en-us/powershell/module/psreadline/set-psreadlineoption
# https://github.com/PowerShell/PSReadLine#usage
$PSReadLineOptions = @{
  PredictionSource              = "HistoryAndPlugin"
  PredictionViewStyle           = "ListView"
  HistoryNoDuplicates           = $true
  HistorySearchCursorMovesToEnd = $true
}
Set-PSReadLineOption @PSReadLineOptions
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadLineKeyHandler -Chord '"', "'" `
  -BriefDescription SmartInsertQuote `
  -LongDescription "Insert paired quotes if not already on a quote" `
  -ScriptBlock {
  param($key, $arg)

  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

  if ($line.Length -gt $cursor -and $line[$cursor] -eq $key.KeyChar) {
    # Just move the cursor
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
  }
  else {
    # Insert matching quotes, move cursor to be in between the quotes
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)" * 2)
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
  }
}


# Bash style directory listing
#

Remove-Item -force alias:ls # Remove powershell ls alias
function l {
  param ([string] $dir)
  Get-ChildItem $dir | Format-Wide -AutoSize
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
function lt {
  param ([string] $dir)
  Get-ChildItem -Force $dir | Sort-Object LastWriteTime -Descending
}


# Application commands
#

# Step up directory
function .. {
  Set-Location ..
}
# Open windows explorer in current directory
function e. {
  explorer .
}
# Open windows terminal in current directory
function wt. {
  wt -d "$(get-item .)"
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
# Show current ip address
function ipme {
  $ipaddr = Invoke-WebRequest ifconfig.me/ip
  Write-Host $ipaddr.Content.Trim()
}
# Reload powershell environment
function Reload-PS-Environment {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}


# Code editor commands
#

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
function Start-NeoVim {
  if (Test-Path $env:LOCALAPPDATA\Programs\Neovim\bin\nvim.exe) {
    nvim $args
  }
  else {
    Write-Error "Couldn't find NeoVim"
  }
}
Set-Alias nvi Start-NeoVim -Option AllScope


# Common Node command shortcuts
#

function ns {
  npm start
}
function nr {
  npm run $args
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
  $branch = git branch --show
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
