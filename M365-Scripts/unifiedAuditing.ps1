# ================================
# Unified Audit Log Utility Script
# ================================

Write-Host "Connecting to Exchange Online..."
Connect-ExchangeOnline

function Check-UnifiedAuditStatus {
    $status = (Get-AdminAuditLogConfig).UnifiedAuditLogIngestionEnabled
    Write-Host "`nUnified Audit Log Enabled: $status"
}

function Enable-UnifiedAudit {
    Write-Host "`nEnabling Unified Audit Log..."
    Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $true
    Write-Host "Unified Audit Log has been enabled. It may take several minutes to take effect."
}

function Run-AuditForUser {
    $user = Read-Host "Enter the User Principal Name (UPN)"
    Write-Host "`nRunning Unified Audit Log for user: $user"

    Search-UnifiedAuditLog `
        -StartDate (Get-Date).AddDays(-30) `
        -EndDate (Get-Date) `
        -RecordType AzureActiveDirectory `
        -UserIds $user |
        Where-Object { $_.AuditData -like "*RemovedLicenses*" } |
        Format-Table -AutoSize
}

function Run-AuditForTenant {
    Write-Host "`nRunning Unified Audit Log for entire tenant (last 30 days)..."

    Search-UnifiedAuditLog `
        -StartDate (Get-Date).AddDays(-30) `
        -EndDate (Get-Date) `
        -RecordType AzureActiveDirectory |
        Format-Table -AutoSize
}

function Run-AuditMailboxActions {
    Write-Host "`nRunning mailbox audit actions (SendAs, SendOnBehalf, MailboxLogin)..."

    Search-UnifiedAuditLog `
        -StartDate (Get-Date).AddDays(-30) `
        -EndDate (Get-Date) `
        -RecordType ExchangeAdmin |
        Format-Table -AutoSize
}

function Show-Menu {
    Clear-Host
    Write-Host "==============================="
    Write-Host " Unified Audit Log Menu"
    Write-Host "==============================="
    Write-Host "1. Check if Unified Auditing is Enabled"
    Write-Host "2. Enable Unified Auditing"
    Write-Host "3. Run Audit Log for Entire Tenant"
    Write-Host "4. Run Audit Log for Specific User"
    Write-Host "5. Run Common Mailbox Audit Actions"
    Write-Host "6. Exit"
}

do {
    Show-Menu
    $choice = Read-Host "Select an option"

    switch ($choice) {
        "1" { Check-UnifiedAuditStatus }
        "2" { Enable-UnifiedAudit }
        "3" { Run-AuditForTenant }
        "4" { Run-AuditForUser }
        "5" { Run-AuditMailboxActions }
        "6" { Write-Host "Exiting script..." }
        default { Write-Host "Invalid selection. Try again." }
    }

    if ($choice -ne "6") {
        Write-Host "`nPress Enter to return to the menu..."
        Read-Host
    }

} while ($choice -ne "6")