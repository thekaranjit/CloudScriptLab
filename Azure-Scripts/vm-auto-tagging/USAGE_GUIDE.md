# Azure VM Tagging Script - Usage Guide

## Overview
This PowerShell script applies consistent resource tags across multiple Azure VMs with validation, error handling, and detailed reporting.

---

## Prerequisites

1. **PowerShell 7.0+** (or Windows PowerShell 5.1)
2. **Azure PowerShell Module** installed:
   ```powershell
   Install-Module -Name Az -AllowClobber -Force
   ```

3. **Azure Account** with permissions:
   - `Microsoft.Compute/virtualMachines/write` (to update VM tags)
   - `Microsoft.Resources/tags/write` (to manage tags)

4. **Connected to Azure**:
   ```powershell
   Connect-AzAccount
   ```

---

## Script Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `Tags` | hashtable | Yes | Tags to apply (key-value pairs) |
| `SubscriptionId` | string | No | Azure subscription ID (uses current if not specified) |
| `ResourceGroupName` | string | No | Limit to specific resource group |
| `VMNameFilter` | string | No | VM name filter (wildcards supported, default: "*") |
| `DryRun` | switch | No | Preview changes without applying |
| `ReportPath` | string | No | Custom path for CSV report (auto-generated if not specified) |

---

## Usage Examples

### Example 1: Apply Tags to All VMs (Dry Run)
Preview what would happen without making changes:

```powershell
$tags = @{
    "Environment"  = "Production"
    "Owner"        = "DevOps-Team"
    "CostCenter"   = "Engineering"
    "Application"  = "WebServer"
    "ManagedBy"    = "Terraform"
}

.\Apply-AzureVMTags.ps1 -Tags $tags -DryRun
```

**Output:**
```
[2024-01-15 10:30:45] [INFO] Checking Azure connection...
[2024-01-15 10:30:46] [SUCCESS] Successfully connected to Azure
[2024-01-15 10:30:46] [INFO] Validating tag format...
[2024-01-15 10:30:46] [SUCCESS] Tag format validation passed
[2024-01-15 10:30:46] [INFO] Discovering target VMs...
[2024-01-15 10:30:47] [SUCCESS] Found 3 VM(s) to process
[2024-01-15 10:30:47] [INFO] Running in DRY RUN mode...
```

---

### Example 2: Apply Tags to Specific Resource Group

```powershell
$tags = @{
    "Environment" = "Development"
    "Owner"       = "TeamA"
}

.\Apply-AzureVMTags.ps1 `
    -Tags $tags `
    -ResourceGroupName "my-resource-group" `
    -SubscriptionId "12345678-1234-1234-1234-123456789012"
```

---

### Example 3: Apply Tags to VMs Matching a Pattern

```powershell
$tags = @{
    "Environment"  = "Staging"
    "BackupPolicy" = "Daily"
}

.\Apply-AzureVMTags.ps1 `
    -Tags $tags `
    -VMNameFilter "web-vm-*" `
    -DryRun
```

This applies tags only to VMs with names matching `web-vm-*` pattern.

---

### Example 4: Apply Tags to Production VMs (With Confirmation)

```powershell
$prodTags = @{
    "Environment"   = "Production"
    "Owner"         = "PlatformTeam"
    "CostCenter"    = "Operations"
    "MonitoringLevel" = "High"
    "BackupRequired" = "Yes"
    "CreatedDate"   = (Get-Date -Format "yyyy-MM-dd")
}

.\Apply-AzureVMTags.ps1 `
    -Tags $prodTags `
    -ResourceGroupName "production-rg" `
    -VMNameFilter "prod-*"
```

The script will show you all VMs and ask for confirmation before applying:
```
Preview of VMs to be processed:
  • prod-api-01 (RG: production-rg)
  • prod-api-02 (RG: production-rg)
  • prod-web-01 (RG: production-rg)

PRODUCTION MODE - Changes will be applied
Are you sure you want to continue? (yes/no): yes
```

---

## Real-World Tagging Standards

### For Cost Allocation
```powershell
$costAllocationTags = @{
    "CostCenter"    = "Engineering"
    "Department"    = "DevOps"
    "Project"       = "WebPlatform"
    "BillingCode"   = "CC-2024-001"
}
```

### For Compliance & Governance
```powershell
$complianceTags = @{
    "Environment"      = "Production"
    "DataClassification" = "Confidential"
    "Owner"            = "SecurityTeam"
    "ApprovalDate"     = "2024-01-15"
    "ComplianceLevel"  = "PCI-DSS"
}
```

### For Operations
```powershell
$operationsTags = @{
    "ManagedBy"       = "Terraform"
    "BackupPolicy"    = "Daily"
    "MaintenanceWindow" = "Sunday-02:00-UTC"
    "AlertingLevel"   = "Critical"
    "DecommissionDate" = "2025-01-15"
}
```

---

## Understanding the Report

The script generates a CSV report like:

```
Timestamp,VMName,ResourceGroup,Status,Message,TagsApplied
2024-01-15 10:45:32,web-vm-01,prod-rg,SUCCESS,Tags applied successfully,8
2024-01-15 10:45:35,web-vm-02,prod-rg,SUCCESS,Tags applied successfully,8
2024-01-15 10:45:38,db-vm-01,prod-rg,FAILED,Insufficient permissions,0
2024-01-15 10:45:40,cache-vm-01,prod-rg,SUCCESS,Tags applied successfully,8
```

**Columns:**
- **Timestamp**: When the operation occurred
- **VMName**: Name of the VM
- **ResourceGroup**: Resource group containing the VM
- **Status**: SUCCESS or FAILED
- **Message**: Details about the operation
- **TagsApplied**: Number of tags applied to the VM

---

## Key Features Explained

### 1. Tag Validation
The script validates that:
- Tag keys contain only alphanumeric characters, hyphens, and underscores
- Tag values are not empty
- Tags follow Azure naming conventions

### 2. Tag Merging
- Existing tags on VMs are **preserved**
- New tags are **added** or **override** existing ones with the same key
- No tags are lost in the process

### 3. Dry Run Mode
- Preview all changes before applying
- Perfect for testing and validation
- Use this FIRST before production runs

### 4. Error Handling
- Individual VM failures don't stop the script
- All failures are logged to the report
- Easy to retry failed VMs

### 5. Detailed Reporting
- CSV export for analysis and auditing
- Success/failure counts
- Timestamp for all operations
- Error messages for troubleshooting

---

## Common Scenarios

### Scenario 1: Tagging All VMs in a Subscription
```powershell
$tags = @{
    "ManagedBy"  = "CloudTeam"
    "CreatedDate" = (Get-Date -Format "yyyy-MM-dd")
}

.\Apply-AzureVMTags.ps1 -Tags $tags -DryRun
# Review the output, then run without -DryRun
.\Apply-AzureVMTags.ps1 -Tags $tags
```

### Scenario 2: Update Only Development VMs
```powershell
$tags = @{
    "Environment" = "Development"
    "AutoShutdown" = "Yes"
}

.\Apply-AzureVMTags.ps1 `
    -Tags $tags `
    -VMNameFilter "dev-*"
```

### Scenario 3: Add Compliance Tags to Specific Resource Group
```powershell
$tags = @{
    "Compliance"     = "GDPR"
    "DataOwner"      = "PrivacyTeam"
    "RetentionDays"  = "365"
}

.\Apply-AzureVMTags.ps1 `
    -Tags $tags `
    -ResourceGroupName "customer-data-rg"
```

---

## Troubleshooting

### Error: "Not connected to Azure"
**Solution:** Run `Connect-AzAccount` first

```powershell
Connect-AzAccount
# Then run the script
```

---

### Error: "Insufficient permissions"
**Solution:** Ensure your Azure account has the required roles
- Ask your Azure admin to assign: `Tag Contributor` or `Owner` role

---

### Error: "No VMs found matching criteria"
**Solution:** Check your filters
```powershell
# List available VMs
Get-AzVM | Select-Object Name, ResourceGroupName

# Then use correct names/patterns
```

---

### Tags not applied to all VMs
**Solution:** Check the report for failed VMs
```powershell
# Open the generated CSV report
Invoke-Item "TaggingReport_20240115_104500.csv"
```

---

## Best Practices

1. **Always use DryRun first**
   ```powershell
   .\Apply-AzureVMTags.ps1 -Tags $tags -DryRun
   ```

2. **Start with a subset of VMs**
   ```powershell
   .\Apply-AzureVMTags.ps1 -Tags $tags -VMNameFilter "test-*"
   ```

3. **Keep tag keys consistent across all VMs**
   - Use PascalCase: `Environment`, `CostCenter`, `Owner`
   - Avoid spaces and special characters

4. **Document your tagging standards**
   - Share with your team
   - Update when standards change

5. **Review the report after each run**
   - Check for failures
   - Track tag counts
   - Audit who applied tags and when

6. **Schedule regular tag audits**
   - Run the script periodically
   - Ensure consistency
   - Update tags when ownership changes

---

## Scheduling Regular Tag Updates

### Option 1: Windows Task Scheduler (Windows)
1. Create a batch file `run-tagging.bat`:
```batch
powershell -ExecutionPolicy Bypass -File "C:\scripts\Apply-AzureVMTags.ps1" `
  -Tags @{"Environment"="Production"} `
  -ResourceGroupName "prod-rg"
```

2. Schedule via Task Scheduler for weekly runs

### Option 2: Azure Automation Runbook (Recommended)
Create an automation account and schedule the PowerShell script to run monthly.

---

## Support & Questions

- Check the report for detailed error messages
- Validate tag format before running
- Use DryRun mode for testing
- Review Azure tagging best practices: https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources

---

## Version History

- **v1.0** (Jan 2024): Initial release
  - Basic VM tagging functionality
  - Dry run support
  - CSV reporting
  - Error handling

---
