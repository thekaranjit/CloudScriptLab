# PowerShell Script: Exchange Mailbox Utility Menu

function Show-Menu {
    Clear-Host
    Write-Host "Exchange Mailbox Utility Menu" -ForegroundColor Cyan
    Write-Host "----------------------------------"
    Write-Host "1. Get mailbox details"
    Write-Host "2. Get folder statistics (sorted by item count)"
    Write-Host "3. Get mailbox retention settings"
    Write-Host "4. Get Recoverable Items folder stats"
    Write-Host "5. Get Inbox folder stats"
    Write-Host "6. Get mailbox storage statistics"
    Write-Host "7. Run Managed Folder Assistant"
    Write-Host "8. Run Managed Folder Assistant (Full Crawl)"
    Write-Host "9. Set RetainDeletedItemsFor to 0"
    Write-Host "10. Get Single Item Recovery and RetainDeletedItemsFor"
    Write-Host "11. Get Delay Hold status"
    Write-Host "0. Exit"
    Write-Host ""
}

# Prompt for user email
$userEmail = Read-Host "Enter the user's email address"

do {
    Show-Menu
    $choice = Read-Host "Select an option (0-11)"

    switch ($choice) {
        '1' {
            Get-Mailbox -Identity $userEmail | Format-List DisplayName,Name,IsInactiveMailbox,LitigationHoldEnabled,LitigationHoldDuration,InPlaceHolds,RetentionHoldEnabled,RetentionPolicy,*single*,*ret*,*delay*,ElcProcessingDisabled
        }
        '2' {
            Get-MailboxFolderStatistics -Identity $userEmail | Sort-Object ItemsInFolder -Descending | Format-Table FolderPath,ItemsInFolder,FolderSize
        }
        '3' {
            Get-Mailbox -Identity $userEmail | Format-List *RET*
        }
        '4' {
            Get-MailboxFolderStatistics -Identity $userEmail -FolderScope RecoverableItems | Select-Object Name,FolderAndSubFolderSize,ItemsInFolderAndSubfolders
        }
        '5' {
            Get-MailboxFolderStatistics -Identity $userEmail -FolderScope Inbox | Select-Object Name,FolderAndSubFolderSize,ItemsInFolderAndSubfolders
        }
        '6' {
            Get-MailboxStatistics -Identity $userEmail | Format-List StorageLimitStatus,TotalItemSize,TotalDeletedItemSize,ItemCount,DeletedItemCount
        }
        '7' {
            Start-ManagedFolderAssistant -Identity $userEmail
        }
        '8' {
            Start-ManagedFolderAssistant -Identity $userEmail -FullCrawl
        }
        '9' {
            Set-Mailbox -Identity $userEmail -RetainDeletedItemsFor 0
        }
        '10' {
            Get-Mailbox -Identity $userEmail | Format-List SingleItemRecoveryEnabled,RetainDeletedItemsFor
        }
        '11' {
            Get-Mailbox -Identity $userEmail | Format-List DelayHoldApplied,DelayReleaseHoldApplied
        }
        '0' {
            Write-Host "Exiting script. Goodbye!" -ForegroundColor Yellow
        }
        default {
            Write-Host "Invalid selection. Please choose a valid option." -ForegroundColor Red
        }
    }

    if ($choice -ne '0') {
        Write-Host ""
        Read-Host "Press Enter to continue..."
    }

} while ($choice -ne '0')