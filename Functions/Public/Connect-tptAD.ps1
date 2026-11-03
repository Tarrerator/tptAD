function Connect-tptAD {
    <#
    .SYNOPSIS
        Establece una conexión con un controlador de dominio y verifica la conectividad.

    .DESCRIPTION
        Función pública que crea una conexión al módulo ActiveDirectory,
        valida que el controlador de dominio está disponible y devuelve la
        información del dominio consultado. Usa los parámetros comunes Server y Credential.

    .PARAMETER Server
        Controlador de dominio (FQDN o IP). Si es nulo, usa el controlador predeterminado
        del equipo o el último servidor conectado guardado en el módulo.

    .PARAMETER Credential
        Credenciales de administrador de dominio para autenticar la conexión.
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

    $domain = Get-ADDomain @params

    [PSCustomObject]@{
        Server      = if ($Server) { $Server } else { $env:COMPUTERNAME }
        Domain      = $domain.NetBIOSName
        DnsRoot     = $domain.DnsRoot
        Forest      = $domain.Forest
        Connected   = $true
    }
}