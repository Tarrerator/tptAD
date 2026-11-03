function Get-tptADUsers {
    <#
    .SYNOPSIS
        Obtiene usuarios Active Directory con información detallada.

    .DESCRIPTION
        Función pública que recupera usuarios AD con propiedades seleccionadas,
        soporta filtrado por nombre, unidad organizativa y conexión al servidor.

    .PARAMETER Name
        Array opcional de nombres de usuarios a devolver. Permite comodines.

    .PARAMETER OrganizationalUnit
        DN o nombre de OU opcional para filtrar usuarios.

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

    $properties = 'SamAccountName', 'DisplayName', 'EmailAddress', 'Enabled', 'LastLogonDate', 'Manager'

    $filter = @{}
    if ($Name) { $filter.SamAccountName = $Name }

    $users = Get-ADUser -Filter $filter -Properties $properties @params

    if (-not $users) {
        Write-Warning 'No se encontraron usuarios.'
        return
    }

    foreach ($user in $users) {
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
            SamAccountName = $user.SamAccountName
            DisplayName    = $user.DisplayName
            Email          = $user.EmailAddress
            Enabled        = $user.Enabled
            LastLogon      = $user.LastLogonDate
            Manager        = $user.Manager
            OU            = $ouDN
        }
    }
}