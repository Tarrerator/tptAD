# tptAD

Módulo PowerShell que envuelve el módulo Windows ActiveDirectory (RSAT) para gestionar dominios, usuarios, grupos, ordenadores y el estado de conexión: inventario y estado básico.

Parte de la suite *tarre pwsh tools* (TPT): prefijo `tpt` en módulos y funciones para evitar colisiones.

## Requisitos

- Windows con RSAT ActiveDirectory instalado (`Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-Lite.Tools.Windows.Installer~32~*~0.0`)
- PowerShell 7.2 o superior (también compatible con Windows PowerShell 5.1)

## Instalación

```powershell
# Desde este repositorio (desarrollo)
git clone https://github.com/Tarrerator/tptAD.git
Import-Module ./tptAD/tptAD.psd1
```

## Uso básico

```powershell
Import-Module tptAD

# Conectar a un controlador de dominio
Connect-tptAD -Server dc01.corp.local -Credential (Get-Credential)

# Estado de la conexión
Get-tptADStatus

# Inventario de dominios
Get-tptADDomains

# Inventario de usuarios
Get-tptADUsers

# Inventario de grupos
Get-tptADGroups

# Inventario de ordenadores
Get-tptADComputers
```

## Configuración

El módulo usa parámetros opcionales de Server y Credential para cada función. No hay configuración YAML por ahora.

Aviso de seguridad: no guardar credenciales en scripts; las credenciales se piden en tiempo de ejecución con `Get-Credential` (o el gestor de credenciales del sistema operativo).

## Advertencia sobre la plataforma

**SOLO Windows**: Este módulo requiere Windows con el módulo ActiveDirectory (RSAT) instalado. No funciona en Linux o macOS.

## Estructura

```
tptAD/
├── tptAD.psd1            # Manifiesto: metadatos, exports, dependencias
├── tptAD.psm1            # Cargador: importa Functions/Public y Functions/Private
├── README.md
├── LICENSE               # GPL-3.0
├── CHANGELOG.md
├── Functions/
│   ├── Public/           # Funciones exportadas al usuario
│   │   ├── Connect-tptAD.ps1
│   │   ├── Get-tptADDomains.ps1
│   │   ├── Get-tptADUsers.ps1
│   │   ├── Get-tptADGroups.ps1
│   │   ├── Get-tptADComputers.ps1
│   │   └── Get-tptADStatus.ps1
│   └── Private/          # Funciones internas, no exportadas
│       └── Test-tptADModule.ps1
└── docs/
    └── ROADMAP.md        # Funciones planificadas
```

## Funciones públicas actuales

| Función | Descripción |
|---------|-------------|
| `Connect-tptAD` | Establece una conexión con un controlador de dominio y devuelve información del dominio. |
| `Get-tptADDomains` | Enumera los dominios AD disponibles con propiedades clave. |
| `Get-tptADUsers` | Obtiene usuarios AD con nombre, correo, estado, último inicio de sesión y gestor. |
| `Get-tptADGroups` | Enumera grupos AD con nombre, scope, categoría, descripción y recuento de miembros. |
| `Get-tptADComputers` | Obtiene computadoras AD con nombre, sistema operativo, último inicio de sesión y gestor. |
| `Get-tptADStatus` | Muestra el estado actual de conexión y metadata del módulo. |

## Desarrollo

```powershell
# Lint
Install-Module PSScriptAnalyzer
Invoke-ScriptAnalyzer -Path . -Recurse

# Probar en sesión limpia
pwsh -NoProfile -Command 'Import-Module ./tptAD.psd1; (Get-Command -Module tptAD).Name -join ","'
```

Las funciones públicas van una por fichero en `Functions/Public/` y las privadas en `Functions/Private/`. El manifiesto lista explícitamente `FunctionsToExport`; nada se exporta con comodines.

## Licencia

[GPL-3.0](LICENSE).