# Azure Scripts

Welcome to the Azure Scripts repository. This folder contains a comprehensive collection of practical and impactful automation scripts tailored for Azure administrators.

## 📁 Folder Structure

```
Azure-Scripts/
├── Entra-Scripts/
│   └── Scripts for Entra ID (Azure AD) automation
├── EntraExtension/
│   ├── Add-TenantExtensionUserProperty.ps1
│   ├── Get-TenantExtensionDictionary.ps1
│   ├── Get-TenantExtensionDictionaryProperty.ps1
│   ├── Get-TenantExtensionUserProperty.ps1
│   ├── New-TenantExtensionDictionary.ps1
│   ├── New-TenantExtensionDictionaryProperty.ps1
│   ├── Update-ExtensionBulk.ps1
│   └── README.md
├── M365-Scripts/
│   ├── LicenseReport.ps1
│   ├── unifiedAuditing.ps1
│   └── [Additional M365 scripts]
├── M365MailboxUtility/
│   ├── MailboxUtility.ps1
│   └── README.md
└── README.md (this file)
```

## 📋 Script Categories

### EntraExtension/
Scripts for managing custom directory extensions in Entra ID (Azure AD)

- **New-TenantExtensionDictionary.ps1** - Create custom extension dictionaries
- **Get-TenantExtensionDictionary.ps1** - Retrieve extension dictionary configurations
- **New-TenantExtensionDictionaryProperty.ps1** - Add properties to extension dictionaries
- **Get-TenantExtensionDictionaryProperty.ps1** - Query extension property definitions
- **New-TenantExtensionUserProperty.ps1** - Assign extension values to users
- **Get-TenantExtensionUserProperty.ps1** - Retrieve user extension property values
- **Update-ExtensionBulk.ps1** - Bulk update extension properties for multiple users

### M365-Scripts/
Scripts for Microsoft 365 administration and reporting

- **LicenseReport.ps1** - Generate license usage reports and analytics
- **unifiedAuditing.ps1** - Query and export unified audit logs

### M365MailboxUtility/
Mailbox management and utilities for Exchange Online

- **MailboxUtility.ps1** - Comprehensive mailbox management tool

### Entra-Scripts/
General Entra ID automation and administrative scripts

## 🚀 Getting Started

### Prerequisites
- PowerShell 5.1 or later
- Required modules:
  - `Microsoft.Graph` or `AzureAD`
  - `ExchangeOnlineManagement`
- Appropriate admin permissions in your Azure/Microsoft 365 tenant

### Installation

1. Install required PowerShell modules:
```powershell
Install-Module -Name Microsoft.Graph -Scope CurrentUser
Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser
```

2. Set PowerShell execution policy if needed:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

3. Navigate to the script folder and run the desired script

## 📖 Usage Examples

### Directory Extension Example
```powershell
cd .\EntraExtension\
.\Get-TenantExtensionDictionary.ps1
```

### License Report Example
```powershell
cd .\M365-Scripts\
.\LicenseReport.ps1
```

## ⚠️ Important Notes

- Always test scripts in a **test environment** before running in production
- Review each script's parameters and documentation before execution
- Ensure you have appropriate **admin permissions** for your tenant
- Some scripts may take time with large datasets
- Enable transcript logging for audit purposes:
```powershell
Start-Transcript -Path ".\logs\audit_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
```

## 📚 Additional Resources

- [Microsoft Graph API Documentation](https://docs.microsoft.com/en-us/graph/api/overview)
- [Exchange Online Management](https://docs.microsoft.com/en-us/powershell/exchange)
- [Azure AD PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/azure/active-directory/overview)

## 📞 Support

For questions or issues:
1. Review the inline script documentation
2. Check individual folder README files for specific script details
3. Refer to Microsoft documentation links above
4. Contact your Azure administrator

---

**Version:** 1.0  
**Last Updated:** May 2026
