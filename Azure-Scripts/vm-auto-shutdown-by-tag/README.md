# 🕐 VM Auto Shutdown by Tag

Automatically shuts down Azure Virtual Machines during off-hours based on a custom tag — helping you cut compute costs on non-production workloads without any manual intervention.

---

## 📋 What It Does

This script scans your Azure environment for VMs tagged with `OffPeakShutdown: true` and gracefully shuts them down on a schedule. Perfect for dev, test, and sandbox environments that don't need to run overnight or on weekends.

---

## ✅ Prerequisites

| Requirement | Details |
|---|---|
| **Azure Automation Account** | Used to host and run the script on a schedule |
| **Managed Identity** | Assigned to the Automation Account (no stored credentials needed) |
| **RBAC Role** | Managed Identity needs `Virtual Machine Contributor` on target subscriptions/resource groups |
| **PowerShell** | Az module (`Az.Compute`, `Az.Accounts`) imported into the Automation Account |

---

## 🏷️ Tag Convention

Apply the following tag to any VM you want included:

| Tag Key | Tag Value |
|---|---|
| `OffPeakShutdown` | `true` |

VMs **without** this tag are ignored entirely, so you're always in control of what gets touched.

---

## ⚙️ Configuration

Before running, set these variables at the top of the script:

```powershell
$SubscriptionId  = "your-subscription-id"
$ShutdownTimeUTC = "18:00"   # 6 PM UTC — adjust to your timezone
$TagKey          = "OffPeakShutdown"
$TagValue        = "true"
```

---

## 🚀 How to Deploy

1. **Import the script** into your Azure Automation Account as a new Runbook (PowerShell type).
2. **Enable the System-assigned Managed Identity** on the Automation Account.
3. **Grant the Managed Identity** `Virtual Machine Contributor` role on the relevant scope (subscription or resource group).
4. **Create a Schedule** in the Automation Account (e.g. daily at 6 PM UTC) and link it to this Runbook.
5. **Tag your VMs** with `OffPeakShutdown = true`.
6. **Test manually** by running the Runbook once with `WhatIf` mode enabled before activating the schedule.

---

## 🔒 Security Notes

- Uses **Managed Identity** — no passwords or secrets stored anywhere.
- Script includes a `WhatIf` dry-run switch so you can preview which VMs would be shut down before committing.
- All shutdown actions are logged to the Automation Account job output for audit purposes.

---

## 📁 Files in This Folder

```
vm-auto-shutdown-by-tag/
├── README.md                  ← You are here
└── Invoke-VMAutoShutdownByTag.ps1
```

---

## 🏷️ Metadata

| Field | Value |
|---|---|
| **Difficulty** | Intermediate |
| **Language** | PowerShell |
| **Azure Services** | Azure Automation, Azure Compute, Managed Identity |
| **Estimated Setup Time** | ~30 minutes |
