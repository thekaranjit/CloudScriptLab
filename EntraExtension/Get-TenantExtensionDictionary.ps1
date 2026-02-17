<#
.SYNOPSIS
Finds the tenant extension dictionary application by display name.

.DESCRIPTION
Returns the application used to host tenant extension properties. Useful to
retrieve the AppId/Id when creating or querying extension properties.
#>
function Get-TenantExtensionDictionary {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string]$appName = 'Tenant Extensions Dictionary'
    )

    $app = Get-MgApplication -Filter "displayName eq '$appName'"

    $app | Format-List Id, AppId, DisplayName

}