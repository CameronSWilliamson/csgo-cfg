<#
.SYNOPSIS
Configures The `autoexec.cfg` file

.DESCRIPTION

.EXAMPLE
#>
[CmdletBinding(DefaultParameterSetName='rootdir')]
param(
    # The root Counter-Strike folder. For CSGO this is `steam/steamapps/common/Counter-Strike Global-Offensive`
    [Parameter(Mandatory, ParameterSetName='rootdir')]
    [path] $RootCSDir,

    # The directory for the Counter-Strike config dir
    [Parameter(Mandatory, ParameterSetName= 'cfgdir')]
    [path] $CfgDir,

    # If installing for CSGO, use this switch.
    [Parameter(ParameterSetName='rootdir')]
    [switch] $CSGO
)

$cfgPath = Join-Path $PSScriptRoot -ChildPath 'autoexec.cfg'

if (-not (Test-Path -Path $cfgPath)) {
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


