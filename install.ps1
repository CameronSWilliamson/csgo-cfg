<#
.SYNOPSIS
Configures The `autoexec.cfg` file

.DESCRIPTION
The `install.ps1` script creates a symbolic link between autoexec.cfg in this repository and an autoexec.cfg in the 
Counter-Strike folder.

Provide the root Counter-Strike folder (such as `steam\steamapps\common\Counter-Strike Global Offensive`) to the 
`RootCsDir` parameter.

Provide the exact path to the folder where the file should be linked to the `CfgDir` parameter.

By default, this script will install the file to the Counter-Strike 2 config folder. To install for Counter-Strike 
Global Offensive, use the `CSGO` flag.

.EXAMPLE
./install.ps1 -RootCSDir 'D:\SteamLibrary\steamapps\common\Counter-Strike Global-Offensive'

Demonstrates installing `autoexec.cfg` to a Counter-Strike folder on the `D:` drive.

.EXAMPLE 
./install.ps1

Demonstrates installing `autoexec.cfg` to the default location.

.EXAMPLE
./install.ps1 -CfgDir 'D:\SteamLibrary\steamapps\common\Counter-Strike Global Offensive\game\csgo\cfg'

Demonstrates installing `autoexec.cfg` to a custom config location.

.EXAMPLE
./install.ps1 -CSGO

Demonstrates installing `autoexec.cfg` to the Counter-Strike Global Offensive config folder.
#>
[CmdletBinding(DefaultParameterSetName='rootdir')]
param(
    # The root Counter-Strike folder. For CSGO this is `steam/steamapps/common/Counter-Strike Global Offensive`
    [Parameter(Mandatory, ParameterSetName='rootdir')]
    [path] $RootCSDir = 'C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive',

    # The directory for the Counter-Strike config dir
    [Parameter(Mandatory, ParameterSetName= 'cfgdir')]
    [path] $CfgDir,

    # If installing for CSGO, use this switch.
    [Parameter(ParameterSetName='rootdir')]
    [switch] $CSGO
)

$autoexecPath = Join-Path $PSScriptRoot -ChildPath 'autoexec.cfg'

if (-not (Test-Path -Path $autoexecPath)) {
    Write-Error -Message 'Unable to find autoexec.cfg' 
}

if (-not $CfgDir -and -not $CSGO) {
    $CfgDir = Join-Path -Path $RootCSDir -ChildPath './game/csgo/cfg'
} elseif (-not $CfgDir -and $CSGO) {
    $CfgDir = Join-Path -Path $RootCSDir -ChildPath './csgo/cfg'
}

if (-not (Test-Path -Path $CfgDir -PathType Container)) {
    Write-Error -Message 'Unable to find cs2 config location'
}

New-Item -Path (Join-Path -Path $CfgDir -ChildPath 'autoexec.cfg') -ItemType SymbolicLink -Value $autoexecPath
Write-Information -MessageData "Symbolic link created between ``./autoexec.cfg`` and ``${CfgDir}``"
