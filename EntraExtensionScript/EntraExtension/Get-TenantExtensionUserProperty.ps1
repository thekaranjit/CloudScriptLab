<#
.SYNOPSIS
Retrieves a specific extension property value for a user.

.PARAMETER extName
Fully-qualified extension property name to read.
.PARAMETER upn
UserPrincipalName of the user to query.
#>
function Get-TenantExtensionUserProperty {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string]$extName = '',
        [ValidateNotNullOrEmpty()]
        [string]$upn = ''
    )
    
    # Request the extension property explicitly so it is present in AdditionalProperties.
    $user = Get-MgUser -UserId $upn -Property "id,displayName,$extName"

    $user.AdditionalProperties[$extName]
}