function Get-tptADGroups {
    <#
    .SYNOPSIS
        Enumera grupos Active Directory con propiedades clave.

    .DESCRIPTION
        Función pública que recupera grupos AD, soporta filtrado opcional por
        nombre, unidad organizativa y conexión al servidor. El recuento de miembros
        usa Get-ADGroupMember (puede ser lento para muchos grupos).

    .PARAMETER Name
        Array opcional de nombres de grupos. Permite comodines.

    .PARAMETER OrganizationalUnit
        DN o nombre de OU opcional para filtrar grupos.

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

    $properties = 'Name', 'SamAccountName', 'Description', 'GroupScope', 'Category'

    $filter = @{}
    if ($Name) { $filter.Name = $Name }

    $groups = Get-ADGroup -Filter $filter -Properties $properties @params

    if (-not $groups) {
        Write-Warning 'No se encontraron grupos.'
        return
    }

    foreach ($group in $groups) {
        $memberCount = 0
        try {
            $memberCount = (Get-ADGroupMember -Identity $group.SamAccountName @params -ErrorAction SilentlyContinue).Count
        } catch {
            $memberCount = 0
        }

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
            Name           = $group.Name
            SamAccountName = $group.SamAccountName
            Scope          = $group.GroupScope
            Category       = $group.Category
            Description    = $group.Description
            MemberCount    = $memberCount
            OU             = $ouDN
        }
    }
}