function Get-tptADComputers {
    <#
    .SYNOPSIS
        Obtiene computadoras Active Directory con información detallada.

    .DESCRIPTION
        Función pública que recupera computadoras AD con propiedades clave,
        soporta filtrado opcional por nombre, unidad organizativa y servidor.

    .PARAMETER Name
        Array opcional de nombres de computadoras. Permite comodines.

    .PARAMETER OrganizationalUnit
        DN o nombre de OU opcional para filtrar computadoras.

    .PARAMETER Server
        Controlador de dominio opcional para la conexión.

    .PARAMETER Credential
        Credenciales de administrador de dominio.
    #>
    [CmdletBinding()]
    [OutputType([System.Object])]
    param(
        [string[]]$Name = @(),
        [string]$OrganizationalUnit = $null,
        [string]$Server = $null,
        [ValidateNotNull()]
        [PSCredential]$Credential = $null
    )

    Test-tptADModule

    $params = @{}
    if ($Server) { $params.Server = $Server }
    if ($Credential) { $params.Credential = $Credential }

    $properties = 'OperatingSystem', 'LastLogonDate', 'ManagedBy'

    $filter = @{}
    if ($Name) { $filter.Name = $Name }

    $computers = Get-ADComputer -Filter $filter -Properties $properties @params

    if (-not $computers) {
        Write-Warning 'No se encontraron computadoras.'
        return
    }

    foreach ($computer in $computers) {
        $ou = $null
        if ($OrganizationalUnit) {
            try {
                if ($OrganizationalUnit -like "*") {
                    $ou = Get-ADOrganizationalUnit -Filter { Name -eq $OrganizationalUnit } -Properties DistinguishedName @params
                } else {
                    $ou = Get-ADOrganizationalUnit -Identity $OrganizationalUnit -Properties DistinguishedName @params
                }
                if ($ou) {
                    $ouDN = $ou.DistinguishedName
                } else {
                    $ouDN = $OrganizationalUnit
                }
            } catch {
                $ouDN = $OrganizationalUnit
            }
        }

        [PSCustomObject]@{
            Name           = $computer.Name
            OperatingSystem = $computer.OperatingSystem
            LastLogon      = $computer.LastLogonDate
            ManagedBy      = $computer.ManagedBy
            OU             = $ouDN
            Enabled        = $computer.Enabled
        }
    }
}