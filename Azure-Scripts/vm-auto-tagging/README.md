# 🏷️ TagVault - Azure VM Resource Tagging Assistant

> **Automate consistent resource tagging across your Azure VMs with confidence**

![PowerShell](https://img.shields.io/badge/PowerShell-7.0+-blue.svg?style=flat-square&logo=powershell)
![Azure](https://img.shields.io/badge/Azure-VM%20Management-0078D4.svg?style=flat-square&logo=microsoft-azure)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)
![Version](https://img.shields.io/badge/Version-1.0.0-orange.svg?style=flat-square)

---

## 📋 Table of Contents

1. [About TagVault](#about-tagvault)
2. [Features](#features)
3. [Why Use TagVault](#why-use-tagvault)
4. [Prerequisites](#prerequisites)
5. [Installation](#installation)
6. [Quick Start (5 Minutes)](#quick-start-5-minutes)
7. [Usage Examples](#usage-examples)
8. [Advanced Configuration](#advanced-configuration)
9. [Script Parameters](#script-parameters)
10. [Tagging Standards](#tagging-standards)
11. [How It Works](#how-it-works)
12. [CSV Reporting](#csv-reporting)
13. [Best Practices](#best-practices)
14. [Troubleshooting](#troubleshooting)
15. [FAQ](#faq)
16. [Contributing](#contributing)
17. [License](#license)

---

## 🎯 About TagVault

**TagVault** is a powerful PowerShell script that makes tagging Azure Virtual Machines **simple, safe, and scalable**.

Instead of manually tagging VMs one by one, TagVault automates the entire process while:
- ✅ Preventing tag loss (merges new tags with existing ones)
- ✅ Providing complete auditability (detailed CSV reports)
- ✅ Offering risk-free testing (dry-run mode)
- ✅ Handling errors gracefully (one VM failure doesn't break the entire batch)

**Use TagVault for:**
- 📊 Cost allocation and chargeback
- 🔒 Compliance and governance
- 🏢 Resource organization and discovery
- 💰 Cloud cost optimization
- 🔄 Operational management

---

## ✨ Features

### Core Functionality
- 🎯 **Bulk Tag Application** - Apply tags to multiple VMs in one operation
- 🔀 **Smart Tag Merging** - Preserves existing tags while adding new ones
- 🔍 **Flexible Filtering** - Target VMs by name pattern, resource group, or subscription
- 🧪 **Dry-Run Mode** - Preview changes before applying them
- 📝 **CSV Reporting** - Detailed audit trail of all operations

### Safety & Reliability
- ✔️ **Tag Validation** - Ensures tags follow Azure naming conventions
- 🛡️ **Error Handling** - Individual VM failures don't stop the batch
- 🔐 **Permission Checking** - Validates Azure connection and access
- 📊 **Operation Summary** - Success/failure counts and statistics
- ♻️ **Idempotent** - Running multiple times produces the same result

### User Experience
- 🎨 **Color-Coded Logs** - Easy-to-read status messages
- ⚠️ **Confirmation Prompts** - Prevent accidental mass changes
- 📋 **Detailed Reports** - Track what was done, when, and by whom
- 📚 **Comprehensive Documentation** - This guide covers everything
- 🚀 **Zero Configuration** - Works out of the box

---

## 💡 Why Use TagVault

### Before TagVault ❌
```
Scenario: Tag 50 VMs across 5 resource groups
- Manual tagging in portal: 50 clicks minimum
- Risk of inconsistent tagging
- No audit trail
- Takes 2+ hours
- Error-prone
```

### With TagVault ✅
```
Scenario: Same 50 VMs
- Single PowerShell command
- Consistent tags guaranteed
- Complete audit trail (CSV report)
- Takes 2 minutes
- Error-safe with dry-run testing
```

---

## 📋 Prerequisites

### Required
- ✅ **PowerShell 7.0+** (Windows, macOS, or Linux)
  ```powershell
  $PSVersionTable.PSVersion
  ```

- ✅ **Azure PowerShell Module**
  ```powershell
  Install-Module -Name Az -AllowClobber -Force
  ```

- ✅ **Azure Account** with permissions:
  - `Microsoft.Compute/virtualMachines/read` - View VMs
  - `Microsoft.Resources/tags/write` - Modify tags

### Optional
- 📊 Excel or CSV viewer (to review reports)
- 📝 Text editor (VS Code, Notepad++)

---

## 🚀 Installation

### Step 1: Download TagVault
```bash
# Clone the repository
git clone https://github.com/yourusername/TagVault.git
cd TagVault

# Or download directly
# Download Apply-AzureVMTags.ps1 from the releases page
```

### Step 2: Check Prerequisites
```powershell
# Verify PowerShell version
$PSVersionTable.PSVersion  # Should be 7.0 or higher

# Install Azure PowerShell if needed
Install-Module -Name Az -AllowClobber -Force

# Import the module
Import-Module Az.Compute
Import-Module Az.Resources
```

### Step 3: Authenticate with Azure
```powershell
# Log in to your Azure account
Connect-AzAccount

# Verify you're logged in
Get-AzContext
```

### Step 4: You're Ready! 🎉
```powershell
# Navigate to the script directory
cd C:\Path\To\TagVault

# Run a test with dry-run
.\Apply-AzureVMTags.ps1 -Tags @{"Environment"="Test"} -DryRun
```

---

## ⚡ Quick Start (5 Minutes)

### The Fastest Way to Get Started

```powershell
# 1. Connect to Azure
Connect-AzAccount

# 2. Define your tags
$tags = @{
    "Environment"  = "Production"
    "Owner"        = "DevOpsTeam"
    "CostCenter"   = "Engineering"
}

# 3. Preview the changes (ALWAYS DO THIS FIRST!)
.\Apply-AzureVMTags.ps1 -Tags $tags -DryRun

# 4. Apply the tags (after reviewing dry-run output)
.\Apply-AzureVMTags.ps1 -Tags $tags

# 5. Check the report
cat .\TaggingReport_*.csv
```

**That's it!** Your VMs are now tagged. 🎊

---

## 📚 Usage Examples

### Example 1: Tag All Production VMs

```powershell
$prodTags = @{
    "Environment"     = "Production"
    "Owner"           = "PlatformTeam"
    "CostCenter"      = "Operations"
    "BackupRequired"  = "Yes"
    "MonitoringLevel" = "High"
}

.\Apply-AzureVMTags.ps1 -Tags $prodTags -DryRun
.\Apply-AzureVMTags.ps1 -Tags $prodTags
```

### Example 2: Tag Development VMs Only

```powershell
$devTags = @{
    "Environment"  = "Development"
    "Owner"        = "EngineersTeam"
    "AutoShutdown" = "Yes"
}

.\Apply-AzureVMTags.ps1 `
    -Tags $devTags `
    -VMNameFilter "dev-*" `
    -ResourceGroupName "dev-rg"
```

### Example 3: Add Compliance Tags to Specific Resource Group

```powershell
$complianceTags = @{
    "Compliance"    = "GDPR"
    "DataOwner"     = "PrivacyTeam"
    "RetentionDays" = "365"
}

.\Apply-AzureVMTags.ps1 `
    -Tags $complianceTags `
    -ResourceGroupName "customer-data-rg"
```

### Example 4: Cost Allocation Across Departments

```powershell
# Engineering Department
$engTags = @{ "CostCenter" = "Engineering"; "Department" = "DevOps" }
.\Apply-AzureVMTags.ps1 -Tags $engTags -VMNameFilter "eng-*"

# Marketing Department
$marketingTags = @{ "CostCenter" = "Marketing"; "Department" = "Digital" }
.\Apply-AzureVMTags.ps1 -Tags $marketingTags -VMNameFilter "marketing-*"
```

### Example 5: Dry-Run for Safety

```powershell
# Always test first!
.\Apply-AzureVMTags.ps1 -Tags $tags -DryRun

# Output will show:
# - Which VMs will be tagged
# - What tags will be applied
# - No actual changes made

# Then run for real
.\Apply-AzureVMTags.ps1 -Tags $tags
```

---

## ⚙️ Advanced Configuration

### Tagging Different VM Groups with Different Tags

```powershell
# Production tags
$prodTags = @{ "Environment" = "Production"; "MonitoringLevel" = "High" }
.\Apply-AzureVMTags.ps1 -Tags $prodTags -VMNameFilter "prod-*"

# Development tags
$devTags = @{ "Environment" = "Development"; "AutoShutdown" = "Yes" }
.\Apply-AzureVMTags.ps1 -Tags $devTags -VMNameFilter "dev-*"

# Testing tags
$testTags = @{ "Environment" = "Testing"; "MonitoringLevel" = "Low" }
.\Apply-AzureVMTags.ps1 -Tags $testTags -VMNameFilter "test-*"
```

### Targeting Specific Subscriptions

```powershell
$tags = @{
    "Environment" = "Production"
    "ManagedBy"   = "Terraform"
}

.\Apply-AzureVMTags.ps1 `
    -Tags $tags `
    -SubscriptionId "12345678-1234-1234-1234-123456789012"
```

### Custom Report Location

```powershell
$tags = @{
    "Environment" = "Production"
    "Owner"       = "TeamA"
}

.\Apply-AzureVMTags.ps1 `
    -Tags $tags `
    -ReportPath "C:\Reports\production-tagging-$(Get-Date -Format 'yyyy-MM-dd').csv"
```

---

## 📊 Script Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `Tags` | hashtable | ✅ Yes | - | Tags to apply (key-value pairs) |
| `SubscriptionId` | string | ❌ No | Current | Azure subscription ID |
| `ResourceGroupName` | string | ❌ No | All | Specific resource group |
| `VMNameFilter` | string | ❌ No | `*` | VM name filter (wildcard supported) |
| `DryRun` | switch | ❌ No | False | Preview mode (no changes) |
| `ReportPath` | string | ❌ No | Auto | Custom CSV report location |

### Parameter Examples

```powershell
# Basic usage
.\Apply-AzureVMTags.ps1 -Tags $tags

# With multiple parameters
.\Apply-AzureVMTags.ps1 `
    -Tags $tags `
    -SubscriptionId "your-subscription-id" `
    -ResourceGroupName "your-resource-group" `
    -VMNameFilter "web-*"

# Dry run mode
.\Apply-AzureVMTags.ps1 -Tags $tags -DryRun

# Custom report
.\Apply-AzureVMTags.ps1 -Tags $tags -ReportPath "C:\MyReports\tags.csv"
```

---

## 🏷️ Tagging Standards

### Recommended Tag Set (Best Practices)

For best results, use this base set:

```powershell
$baseTags = @{
    "Environment"        = "Production"           # Production/Development/Testing/Staging
    "Owner"              = "TeamName"             # Person or team responsible
    "CostCenter"         = "Engineering"          # For cost allocation
    "Application"        = "WebServer"            # What app it runs
    "ManagedBy"          = "Terraform"            # Infrastructure as Code tool
    "BackupRequired"     = "Yes"                  # Yes/No
    "MonitoringLevel"    = "High"                 # High/Medium/Low
    "DataClassification" = "Internal"             # Public/Internal/Confidential
}
```

### Tag Naming Conventions

#### ✅ DO:
- Use **PascalCase** for keys: `Environment`, `CostCenter`, `Owner`
- Keep values **descriptive and consistent**
- Document your tagging strategy
- Review the CSV report after each run
- Use dry-run before production changes

#### ❌ DON'T:
- Use spaces in tag keys
- Use special characters (`@`, `#`, `$`, etc.)
- Create tags longer than 256 characters
- Forget to validate tags before applying
- Skip the dry-run step

### Real-World Tagging Scenarios

#### Cost Allocation
```powershell
$costAllocationTags = @{
    "CostCenter"    = "Engineering"
    "Department"    = "DevOps"
    "Project"       = "WebPlatform"
    "BillingCode"   = "CC-2024-001"
}
```

#### Compliance & Governance
```powershell
$complianceTags = @{
    "Environment"         = "Production"
    "DataClassification"  = "Confidential"
    "Owner"               = "SecurityTeam"
    "ApprovalDate"        = "2024-01-15"
    "ComplianceLevel"     = "PCI-DSS"
}
```

#### Operations
```powershell
$operationsTags = @{
    "ManagedBy"         = "Terraform"
    "BackupPolicy"      = "Daily"
    "MaintenanceWindow" = "Sunday-02:00-UTC"
    "AlertingLevel"     = "Critical"
    "DecommissionDate"  = "2025-01-15"
}
```

#### Development/Testing
```powershell
$devTags = @{
    "Environment"  = "Development"
    "Owner"        = "EngineersTeam"
    "AutoShutdown" = "Yes"
    "DeleteIfUnused" = "After-30-days"
}
```

---

## 🔄 How It Works

### Script Workflow

```
1. VALIDATION
   ├─ Check Azure connection
   ├─ Validate tag format
   └─ Verify permissions

2. DISCOVERY
   ├─ Query Azure VMs
   ├─ Apply filters (RG, name pattern, subscription)
   └─ List target VMs

3. PREVIEW
   ├─ Show VMs to be processed
   ├─ Ask for confirmation
   └─ Check dry-run mode

4. PROCESSING
   ├─ For each VM:
   │  ├─ Get existing tags
   │  ├─ Merge with new tags
   │  ├─ Validate merged tags
   │  └─ Apply via Azure API
   └─ Log result (success/failure)

5. REPORTING
   ├─ Generate CSV report
   ├─ Show summary statistics
   └─ List any failures
```

### Tag Merging Logic

TagVault **preserves** existing tags and **adds** new ones:

```powershell
# Before:
VM Tags: { "Owner" = "Team-A"; "Environment" = "Dev" }

# New Tags to Apply:
{ "CostCenter" = "Engineering"; "Environment" = "Testing" }

# After (merged result):
{ "Owner" = "Team-A"; "Environment" = "Testing"; "CostCenter" = "Engineering" }
```

**Key Points:**
- ✅ Existing tag "Owner" is preserved
- ✅ "Environment" tag is updated (overwritten)
- ✅ New "CostCenter" tag is added
- ✅ No tags are lost in the process

---

## 📝 CSV Reporting

The script generates a timestamped CSV file with complete audit trail:

```
Timestamp,VMName,ResourceGroup,Status,Message,TagsApplied
2024-01-15 10:45:32,web-vm-01,prod-rg,SUCCESS,Tags applied successfully,8
2024-01-15 10:45:35,web-vm-02,prod-rg,SUCCESS,Tags applied successfully,8
2024-01-15 10:45:38,db-vm-01,prod-rg,FAILED,Insufficient permissions,0
2024-01-15 10:45:40,cache-vm-01,prod-rg,SUCCESS,Tags applied successfully,8
```

### Report Columns

- **Timestamp**: When the operation occurred
- **VMName**: Name of the VM
- **ResourceGroup**: Resource group containing the VM
- **Status**: SUCCESS or FAILED
- **Message**: Details about the operation
- **TagsApplied**: Number of tags applied to the VM

### Analyzing the Report

```powershell
# Count successes and failures
$report = Import-Csv "TaggingReport_20240115_104500.csv"
$report | Group-Object Status | Select-Object Name, Count

# Find failed VMs
$report | Where-Object { $_.Status -eq "FAILED" } | Select-Object VMName, Message

# Export to Excel for further analysis
$report | Export-Excel "TaggingResults.xlsx"
```

---

## 🎓 Best Practices

### 1. Always Use Dry-Run First
```powershell
# Test before applying
.\Apply-AzureVMTags.ps1 -Tags $tags -DryRun

# Review the output carefully
# Then run for real
.\Apply-AzureVMTags.ps1 -Tags $tags
```

### 2. Start with a Subset of VMs
```powershell
# Tag 5-10 VMs first, verify results
.\Apply-AzureVMTags.ps1 -Tags $tags -VMNameFilter "test-*"

# Then expand to all VMs
.\Apply-AzureVMTags.ps1 -Tags $tags
```

### 3. Keep Tag Keys Consistent Across All VMs
```powershell
# Good - consistent naming
$tags = @{
    "Environment" = "Production"
    "CostCenter"  = "Engineering"
    "Owner"       = "TeamName"
}

# Bad - inconsistent naming
$tags = @{
    "Env"        = "Prod"
    "Cost"       = "Eng"
    "owner_name" = "Team"
}
```

### 4. Document Your Tagging Standards
- Create a tagging policy document
- Share with your team
- Update when standards change
- Keep a record of decisions

### 5. Review Reports After Each Run
- Check for unexpected failures
- Track tag counts
- Audit who applied tags and when
- Keep reports for compliance

### 6. Schedule Regular Tag Audits
```powershell
# Run monthly to ensure consistency
# Verify all VMs have required tags
# Update tags when ownership changes
# Report on tagging compliance
```

### 7. Version Control Your Tag Sets
```powershell
# Keep different tag sets for different purposes
$v1_tags = @{ "Environment" = "Production" }
$v2_tags = @{ "Environment" = "Production"; "BackupPolicy" = "Daily" }

# Document changes over time
# Allows rollback if needed
```

---

## 🐛 Troubleshooting

### Issue: "Not connected to Azure"

**Solution:**
```powershell
Connect-AzAccount
```

### Issue: "No VMs found matching criteria"

**Solution:**
```powershell
# Check available VMs
Get-AzVM | Select-Object Name, ResourceGroupName

# Then verify your filter
.\Apply-AzureVMTags.ps1 -Tags $tags -VMNameFilter "correct-pattern-*"
```

### Issue: "Insufficient permissions"

**Solution:**
```powershell
# Ask your Azure admin to assign these roles:
# - Reader (to see VMs)
# - Tag Contributor (to modify tags)

# Verify your permissions
Get-AzRoleAssignment -SignInName (Get-AzContext).Account.Id
```

### Issue: "Invalid tag key format"

**Solution:**
```powershell
# ❌ WRONG - Keys with spaces or special characters
$tags = @{ "Cost Center" = "Engineering" }
$tags = @{ "env-name" = "prod" }

# ✅ RIGHT - PascalCase, alphanumeric only
$tags = @{ "CostCenter" = "Engineering" }
$tags = @{ "EnvironmentName" = "prod" }
```

### Issue: "Tags not applied"

**Solution:**
```powershell
# Always run DRY RUN first
.\Apply-AzureVMTags.ps1 -Tags $tags -DryRun

# Check the CSV report for errors
Get-Content .\TaggingReport_*.csv | Select-Object -Last 10

# Retry with verbose output
.\Apply-AzureVMTags.ps1 -Tags $tags -Verbose
```

### Issue: "Script execution policy error"

**Solution:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## ✅ Verify Tags Were Applied

### Via Azure Portal
1. Go to **Virtual Machines**
2. Click on a VM
3. Look for **Tags** section in the left sidebar
4. Your new tags should appear there

### Via PowerShell
```powershell
# Get tags for a specific VM
Get-AzVM -Name "my-vm" | Select-Object -ExpandProperty Tags

# Get tags for all VMs in a resource group
Get-AzVM -ResourceGroupName "my-rg" | ForEach-Object {
    Write-Host "$($_.Name):"
    $_.Tags | Format-Table
}
```

---

## 🔧 Advanced Scheduling

### Option 1: Windows Task Scheduler

Create a PowerShell script `schedule-tagging.ps1`:
```powershell
Connect-AzAccount -UseDeviceAuthentication
$tags = @{
    "Environment" = "Production"
    "Owner"       = "AutomationTeam"
}
.\Apply-AzureVMTags.ps1 -Tags $tags
```

Then schedule with Task Scheduler for weekly/monthly runs.

### Option 2: Azure Automation Runbook (Recommended)

1. Create an Automation Account in Azure
2. Create a new runbook with the script code
3. Schedule it to run monthly
4. Configure notifications for success/failure

### Option 3: PowerShell Task Scheduler

```powershell
# Create scheduled task
$action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-ExecutionPolicy Bypass -File C:\scripts\schedule-tagging.ps1"

$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 2AM

Register-ScheduledTask -Action $action -Trigger $trigger `
    -TaskName "TagVault-Weekly" -Description "Weekly VM tagging"
```

---

## ❓ FAQ

**Q: Will TagVault delete my existing tags?**
A: No! TagVault **merges** tags. Existing tags are preserved, new ones are added.

**Q: Is it safe to run on production VMs?**
A: Yes! Always use `-DryRun` first to preview changes. TagVault won't modify anything without your explicit confirmation.

**Q: Can I tag VMs in multiple subscriptions?**
A: Yes, but run the script separately for each subscription (change context with `Set-AzContext`).

**Q: How long does it take?**
A: ~5-10 seconds per VM for the API call. A batch of 50 VMs takes 4-8 minutes.

**Q: What if tagging fails for one VM?**
A: The script continues with other VMs and logs the failure in the CSV report.

**Q: Can I schedule this automatically?**
A: Yes! Use Azure Automation Runbooks or Windows Task Scheduler.

**Q: Does TagVault work on macOS/Linux?**
A: Yes! PowerShell 7+ works on all platforms. The script is platform-agnostic.

**Q: What happens if I run it twice with the same tags?**
A: The script is idempotent - running it twice produces the same result as running once.

**Q: Can I use TagVault with other Azure resources?**
A: Currently designed for VMs. Future versions will support other resources.

**Q: How do I get support?**
A: Check this documentation, review the troubleshooting section, or check GitHub issues.

---

## 🤝 Contributing

Contributions are welcome! Here's how to help:

### Report Bugs
Open an issue with:
- Error message
- Steps to reproduce
- Your environment (PowerShell version, OS, etc.)

### Suggest Features
Ideas for improvements:
- Parallel processing for faster execution
- Tag templates/profiles
- Integration with Azure Policy
- Support for other Azure resources (Storage, DBs, etc.)

### Submit Code
Pull requests:
- Follow PowerShell best practices
- Test with dry-run first
- Update documentation
- Add comments for complex logic

---

## 📄 License

This project is licensed under the MIT License.

You are free to:
- ✅ Use commercially
- ✅ Modify the code
- ✅ Distribute
- ✅ Use privately

Just include the license and don't hold us liable.

---

## 🎁 Project Summary

### What TagVault Solves

| Problem | Solution |
|---------|----------|
| Manual tagging is slow | Bulk tagging in seconds |
| Risk of data loss | Tag merging preserves existing |
| Inconsistent tagging | Enforces standards |
| No audit trail | CSV reporting included |
| Fear of mistakes | Dry-run mode for testing |
| Steep learning curve | Simple, documented interface |

### ROI

```
Time Saved:      1-2 hours per 50 VMs
Cost Clarity:    Better cost allocation
Risk Reduction:  Safe, tested operations
Compliance:      Easier auditing
Repeatability:   Schedule and automate
```

### Key Strengths

1. **Safety First**
   - Dry-run mode prevents mistakes
   - Preserves existing tags
   - Error recovery built-in
   - Confirmation prompts

2. **Easy to Use**
   - Simple PowerShell syntax
   - Works out of the box
   - Minimal configuration
   - Clear error messages

3. **Professional Quality**
   - Enterprise-grade code
   - Comprehensive documentation
   - Extensive examples
   - Best practices included

4. **Well Documented**
   - Complete README (this file!)
   - Real-world examples
   - Troubleshooting section
   - FAQ section

---

## 🚀 Getting Started Checklist

- [ ] Install PowerShell 7.0+
- [ ] Install Azure PowerShell Module
- [ ] Run `Connect-AzAccount`
- [ ] Download `Apply-AzureVMTags.ps1`
- [ ] Define your tags (choose from examples above)
- [ ] Run with `-DryRun` first
- [ ] Review the output
- [ ] Run for real (without `-DryRun`)
- [ ] Check the CSV report
- [ ] Verify tags in Azure Portal

---

## 📞 Support & Resources

- 📖 This README for complete documentation
- 🐛 GitHub Issues for bug reports
- 💬 GitHub Discussions for questions
- 📧 Contact maintainer for urgent issues

---

## 🎉 Acknowledgments

Built for Azure professionals who value efficiency and safety.

Made with ❤️ for the DevOps community.

---

**Last Updated: January 2024 | Version 1.0.0**

**Status: Active Development & Maintenance ✅**

---

## 📊 Quick Reference Card

### Connect to Azure
```powershell
Connect-AzAccount
```

### Define Tags
```powershell
$tags = @{
    "Environment" = "Production"
    "Owner" = "TeamName"
    "CostCenter" = "Engineering"
}
```

### Dry Run (Test)
```powershell
.\Apply-AzureVMTags.ps1 -Tags $tags -DryRun
```

### Apply Tags
```powershell
.\Apply-AzureVMTags.ps1 -Tags $tags
```

### With Filters
```powershell
.\Apply-AzureVMTags.ps1 -Tags $tags -VMNameFilter "web-*" -ResourceGroupName "prod-rg"
```

### Verify Tags
```powershell
Get-AzVM -Name "vm-name" | Select-Object -ExpandProperty Tags
```

---

**Ready to tag your Azure VMs? Start with the Quick Start section above! 🚀**