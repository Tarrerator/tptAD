function Get-tptADDomains {
    <#
    .SYNOPSIS
        Enumera los dominios Active Directory disponibles.

    .DESCRIPTION
        Función pública que recupera todos los dominios AD (o filtra por nombre)
        y devuelve propiedades clave para cada uno. Soporta parámetros opcionales
        de filtrado por nombre y conexión al servidor.

    .PARAMETER Name
        Array opcional de nombres de dominios (DNS) a devolver. Permite
        comodines (por ejemplo, "*.corpo.local"). Si está vacío, devuelve todos
        los dominios.

    .PARAMETER Server
        Controlador de dominio opcional para la conexión.

    .PARAMETER Credential
        Credenciales de administrador de dominio.
    #>
    [CmdletBinding()]
    [OutputType([System.Object])]
    param(
        [string[]]$Name = @(),
        [string]$Server = $null,
        [ValidateNotNull()]
        [PSCredential]$Credential = $null
    )

    Test-tptADModule

    $params = @{}
    if ($Server) { $params.Server = $Server }
    if ($Credential) { $params.Credential = $Credential }

    $filter = @{}
    if ($Name) { $filter.Name = $Name }

    $domains = Get-ADDomain -Filter $filter @params

    if (-not $domains) {
        Write-Warning 'No se encontraron dominios.'
        return
    }

    foreach ($domain in $domains) {
        [PSCustomObject]@{
            Name        = $domain.Name
            NetBIOSName = $domain.NetBIOSName
            DomainMode   = $domain.DomainMode
            Forest       = $domain.Forest
            Connected    = $true
        }
    }
}