@{
    # Identidad del módulo
    RootModule           = 'tptAD.psm1'
    ModuleVersion        = '0.0.1'
    GUID                 = '2d2ad8e9-da3d-4327-8e2f-51a646d4db14'
    Author               = 'Tarrerator'
    CompanyName          = 'Tarrerator'
    Copyright            = '(c) 2026 Tarrerator'

    # Descripción
    Description          = 'Módulo PowerShell que envuelve el módulo Windows ActiveDirectory (RSAT) para gestionar dominios, usuarios, grupos, ordenadores y el estado de conexión: inventario y estado básico. Requiere Windows con RSAT instalado. Parte de la suite *tarre pwsh tools* (TPT): prefijo `tpt` en módulos y funciones para evitar colisiones.'

    # Compatibilidad
    PowerShellVersion    = '7.2'
    CompatiblePSEditions = @('Desktop', 'Core')

    # Dependencias
    # ActiveDirectory (Windows RSAT) es dependencia SUAVE:
    # el módulo se carga sin el módulo subyacente y las funciones
    # fallan con un mensaje claro al ejecutarse.
    # RequiredModules = @(
    #     @{ ModuleName = 'ActiveDirectory'; ModuleVersion = '1.0' }
    # )

    # Exports explícitos: nada de comodines
    FunctionsToExport    = @(
        'Connect-tptAD'
        'Get-tptADDomains'
        'Get-tptADUsers'
        'Get-tptADGroups'
        'Get-tptADComputers'
        'Get-tptADStatus'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()

    PrivateData          = @{
        PSData = @{
            Tags         = @('ActiveDirectory', 'RSAT', 'Windows', 'Inventario', 'TDP')
            ProjectUri   = 'https://github.com/Tarrerator/tptAD'
            ReleaseNotes = 'Esqueleto del módulo con inventario básico.'
            # LicenseUri = ''
            # IconUri    = ''
            # ReleaseNotes file: CHANGELOG.md
        }
    }
}