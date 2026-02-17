<#
.SYNOPSIS
Creates an Azure AD application used as the "Tenant Extensions Dictionary".

.DESCRIPTION
This helper creates a lightweight application used to host extension properties
for tenant-scoped custom attributes. The app's AppId is used when creating
extension properties (schema extensions) that target directory objects such as
users.

.NOTES
- Performance: Avoid calling `Connect-MgGraph` repeatedly in tight loops; call
  it once and reuse the connection when creating multiple properties.
#>
function New-TenantExtensionDictionary {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string]$appName = 'Tenant Extensions Dictionary'
    )

    # Create the application (dictionary) that will own extension properties.
    $app = New-MgApplication -DisplayName $appName

    # Create a service principal for the application so it is visible in the
    # tenant (optional but commonly useful).
    New-MgServicePrincipal -AppId $app.AppId

    # Output the created application object. For automation, prefer the object
    # (not formatted text) so callers can inspect properties programmatically.
    $app | Format-List Id, AppId, DisplayName

}