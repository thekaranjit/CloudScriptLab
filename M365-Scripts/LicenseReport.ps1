# This PowerShell script checks whether users in a CSV file are assigned a specific Microsoft 365 license SKU
# (in this example, the E3 license).
#
# It uses Microsoft Graph PowerShell to query each user’s license details and generates a report showing:
#
# - ✔ User has the license
# - ✖ User does not have the license
# - ⚠ Error occurred while checking the user
#
# The final results are exported to a CSV file for easy review or compliance reporting.


# Path to the CSV file containing the list of users (with UserPrincipalName column)
$csvPath = "C:\UsersList.csv"     

# The SKU ID you want to check (E3 license in this example)
$skuIdToCheck = "6fd2c87f-b296-42f0-b197-1e91e994b900"  

# Path where the final report will be exported
$reportPath = "C:\E3LicenseReport.csv"

# Import the CSV and process each user
Import-Csv $csvPath | ForEach-Object {
    try {
        # Retrieve assigned license details for the user
        $licenses = Get-MgUserLicenseDetail -UserId $_.UserPrincipalName
        $hasLicense = $false

        # Check if the user has the specified SKU assigned
        if ($licenses.SkuId -contains $skuIdToCheck) {
            $hasLicense = $true
        }

        # Output result object for successful license check
        [PSCustomObject]@{
            User        = $_.UserPrincipalName
            HasLicense  = if ($hasLicense) { "Yes" } else { "No" }
        }
    }
    catch {
        # Output result object if an error occurs (e.g., user not found)
        [PSCustomObject]@{
            User       = $_.UserPrincipalName
            HasLicense = "Error"
            Error      = $_.Exception.Message
        }
    }
} | Export-Csv $reportPath -NoTypeInformation   # Export results to CSV

# Notify user where the report was saved
Write-Host "Report saved to $reportPath"