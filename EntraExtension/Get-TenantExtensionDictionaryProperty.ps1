<#
.SYNOPSIS
Lists extension properties defined on the tenant dictionary application.

.PARAMETER appName
Display name of the dictionary application to query.
.PARAMETER propertyName
Optional. If specified, callers may filter on the returned property list.
#>
function Get-TenantExtensionDictionaryProperty {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string]$appName = 'Tenant Extensions Dictionary',
        [string]$propertyName
    )
    
    $app = Get-MgApplication -Filter "displayName eq '$appName'"

    $applicationObjectId = $app.Id

    $ext = Get-MgApplicationExtensionProperty `
        -ApplicationId $applicationObjectId

    $ext | Format-List Id, Name, DataType, TargetObjects
}