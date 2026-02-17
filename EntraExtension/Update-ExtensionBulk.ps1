# Path to CSV (same folder as script)
$csvPath = ".\users.csv"

# Output report path
$reportPath = ".\TenantExtensionUpdateReport.csv"

# Extension attribute details
$extName  = 'extension_290bec36719a47b5aad492b8e5c515bb_LicenseModel'
$extValue = 'M365E555'

# Import CSV
$users = Import-Csv -Path $csvPath

# Create results array
$results = @()

foreach ($user in $users) {
    $upn = $user.UPN

    try {
        Add-TenantExtensionUserProperty `
            -extName $extName `
            -extValue $extValue `
            -upn $upn

        # Log success
        $results += [PSCustomObject]@{
            UPN     = $upn
            Status  = "Success"
            Message = "Attribute updated"
        }
    }
    catch {
        # Log failure
        $results += [PSCustomObject]@{
            UPN     = $upn
            Status  = "Failed"
            Message = $_.Exception.Message
        }
    }
}

# Export report
$results | Export-Csv -Path $reportPath -NoTypeInformation

Write-Host "Processing complete. Report saved to $reportPath"