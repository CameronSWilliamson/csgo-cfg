<#
.SYNOPSIS
Configures The `autoexec.cfg` file

.DESCRIPTION
The `install.ps1` script creates a symbolic link between autoexec.cfg in this repository and an autoexec.cfg in the 
Counter-Strike folder.

Provide the RootCSDir to the `RootCsDir` parameter.

.EXAMPLE
./install.ps1 -RootCSDir 'D:\SteamLibrary\steamapps\common\Counter-Strike Global-Offensive'

Demonstrates installing `autoexec.cfg` to a Counter-Strike folder on the `D:` drive.

.EXAMPLE 
./install.ps1

Demonstrates installing `autoexec.cfg` to the default location.

.EXAMPLE

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
Write-Information -MessageData "Copied ./autoexec.cfg to $($CfgDir)"
