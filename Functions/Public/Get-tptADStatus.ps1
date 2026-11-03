function Get-tptADStatus {
    <#
    .SYNOPSIS
        Muestra el estado actual de conexión y metadata del módulo tptAD.

    .DESCRIPTION
        Función pública de solo lectura que devuelve información sobre el estado
        actual de conexión al dominio (si hay alguna), la versión del módulo
        ActiveDirectory y el estado general del módulo tptAD.

    .PARAMETER Server
        Controlador de dominio opcional para verificar conectividad.

    .PARAMETER Credential
        Credenciales de administrador de dominio para la conexión.
    #>
    [CmdletBinding()]
    [OutputType([System.Object])]
    param(
        [string]$Server = $null,
        [ValidateNotNull()]
        [PSCredential]$Credential = $null
    )

    Test-tptADModule

    $params = @{}
    if ($Server) { $params.Server = $Server }
    if ($Credential) { $params.Credential = $Credential }

    try {
        $domain = Get-ADDomain @params
        $connected = $true
        $domainName = $domain.NetBIOSName
    } catch {
        $connected = $false
        $domainName = $null
    }

    $adModule = Get-Module -Name 'ActiveDirectory'
    $adVersion = if ($adModule) { $adModule.Version } else { $null }

    [PSCustomObject]@{
        Server          = if ($Server) { $Server } else { $env:COMPUTERNAME }
        Domain          = $domainName
        Connected       = $connected
        ModuleVersion   = $adVersion
    }
}