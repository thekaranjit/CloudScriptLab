<#
.SYNOPSIS
Adds a new extension property to the tenant dictionary application.

.PARAMETER appName
Name of the dictionary application (created with `New-TenantExtensionDictionary`).
.PARAMETER propertyName
The extension property name (without the extension app prefix).
.PARAMETER dataType
The data type for the extension (e.g. String, Integer, Boolean).
.PARAMETER targetObjects
Which directory object types the extension targets (e.g. User).

.NOTES
- Performance: If creating many properties, call `Connect-MgGraph` once and
  reuse the session. Cache the application Id locally to avoid repeated
  lookups.
#>
function New-TenantExtensionDictionaryProperty {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string]$appName = 'Tenant Extensions Dictionary',
        [ValidateNotNullOrEmpty()]
        [string]$propertyName = 'LicenseModel',
        [ValidateNotNullOrEmpty()]
        [string]$dataType = 'String',
        [ValidateNotNullOrEmpty()]
        [string[]]$targetObjects = @('User')
    )
    
    $app = Get-MgApplication -Filter "displayName eq '$appName'"

    $applicationObjectId = $app.Id

    $ext = New-MgApplicationExtensionProperty `
        -ApplicationId $applicationObjectId `
        -Name $propertyName  `
        -DataType $dataType `
        -TargetObjects $targetObjects `
        -IsMultiValued:$false

    $ext | Format-List Id, Name, DataType, TargetObjects
}