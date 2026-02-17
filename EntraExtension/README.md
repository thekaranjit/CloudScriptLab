# Entra ID Extension Scripts

Small helper scripts to create and manage a tenant-level
"extension dictionary" (an Entra ID application that hosts extension
properties) and to set/read those extension values on users.

IMPORTANT: Dot-source the scripts in this directory before running the
examples below so the functions load into your current PowerShell session.

From the directory containing these scripts run the individual dot-source
commands below (run once per PowerShell session):

```powershell
# Dot-source each script (relative paths)
. .\New-TenantExtensionDictionary.ps1
. .\New-TenantExtensionDictionaryProperty.ps1
. .\Get-TenantExtensionDictionary.ps1
. .\Get-TenantExtensionDictionaryProperty.ps1
. .\Add-TenantExtensionUserProperty.ps1
. .\Get-TenantExtensionUserProperty.ps1
```

Or dot-source all scripts at once with a single command (convenient):

```powershell
Get-ChildItem -Filter '*.ps1' | ForEach-Object { . $_.FullName }
```

Run order
1) `New-TenantExtensionDictionary.ps1` — create the dictionary app and service principal.
2) `New-TenantExtensionDictionaryProperty.ps1` — add one or more extension properties to the app.
3) `Get-TenantExtensionDictionary.ps1` — verify the application exists (optional).
4) `Get-TenantExtensionDictionaryProperty.ps1` — list extension properties defined on the app (optional).
5) `Add-TenantExtensionUserProperty.ps1` — set an extension property value on a user.
6) `Get-TenantExtensionUserProperty.ps1` — read the extension property value from a user.

Prerequisites
- PowerShell with the Microsoft Graph module (e.g. `Install-Module Microsoft.Graph`).
- Appropriate permissions to manage applications and users (scopes used by the scripts include `Application.ReadWrite.All`, `Directory.ReadWrite.All`, `User.ReadWrite.All`).
- An interactive `Connect-MgGraph` session is used by each script; for bulk work, authenticate once and reuse the session.

```powershell
# Ensure an authenticated Graph session. Scopes required for app and
# extension property management are requested here.
Connect-MgGraph -Scopes 'Application.ReadWrite.All', 'Directory.ReadWrite.All' -NoWelcome
```

Examples (after dot-sourcing)

1) Create the tenant extension dictionary application

```powershell
# Create an app named "Tenant Extensions Dictionary"
New-TenantExtensionDictionary -appName 'Tenant Extensions Dictionary'
```

2) Add a new extension property (example: `LicenseModel` targeting `User`)

```powershell
New-TenantExtensionDictionaryProperty `
        -appName 'Tenant Extensions Dictionary' `
        -propertyName 'LicenseModel' `
        -dataType 'String' `
        -targetObjects @('User')
```

3) Verify the dictionary application

```powershell
Get-TenantExtensionDictionary -appName 'Tenant Extensions Dictionary'
```

4) List extension properties on the dictionary application

```powershell
Get-TenantExtensionDictionaryProperty -appName 'Tenant Extensions Dictionary'
```

5) Set an extension property value on a user

```powershell
Add-TenantExtensionUserProperty `
        -extName 'extension_<appId>_LicenseModel' `
        -extValue 'M365E5' `
        -upn 'alice@example.com'
```

Note: replace `<appId>` with the application id prefix created for extension properties. You can obtain the correct `extension_...` prefix from `Get-TenantExtensionDictionaryProperty` output.

6) Read back a user's extension property

```powershell
Get-TenantExtensionUserProperty `
        -extName 'extension_<appId>_LicenseModel' `
        -upn 'alice@example.com'
```

Performance & usage notes
- Always test on a single user or a test tenant before running wide-scale updates.
