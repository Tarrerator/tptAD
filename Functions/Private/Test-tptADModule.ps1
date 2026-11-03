function Test-tptADModule {
    <#
    .SYNOPSIS
        Verifica que el módulo ActiveDirectory (RSAT) está disponible.

    .DESCRIPTION
        Función privada. Si el módulo ActiveDirectory no está instalado,
        lanza un error con instrucciones de instalación. Devuelve true si está disponible.
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $adModule = Get-Module -ListAvailable -Name 'ActiveDirectory'

    if (-not $adModule) {
        throw 'El módulo ActiveDirectory no está disponible. Requiere Windows con RSAT instalado: Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-Lite.Tools.Windows.Installer~32~*~0.0'
    }

    Import-Module ActiveDirectory -Force

    $true
}