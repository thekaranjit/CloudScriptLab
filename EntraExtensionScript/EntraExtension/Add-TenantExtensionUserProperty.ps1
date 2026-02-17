<#
.SYNOPSIS
Sets an extension property value on a user.

.PARAMETER extName
Fully-qualified extension property name (including the extension_<appId>_ prefix).
.PARAMETER extValue
Value to assign for the extension property.
.PARAMETER upn
UserPrincipalName of the user to update.

.NOTES
- Validation: `extName` must include the extension prefix when used with
  `Update-MgUser` as AdditionalProperties.
#>
function Add-TenantExtensionUserProperty {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string]$extName = '',
        [ValidateNotNullOrEmpty()]
        [string]$extValue = '',
        [ValidateNotNullOrEmpty()]
        [string]$upn = ''
    )

    Update-MgUser -UserId $upn -AdditionalProperties @{
        $extName = $extValue
    }
}