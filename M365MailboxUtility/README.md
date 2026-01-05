# 📬 Exchange Mailbox Utility Menu

A handy PowerShell-driven menu for Exchange administrators to quickly inspect, manage, and troubleshoot mailbox settings. This interactive script streamlines common tasks like viewing mailbox statistics, retention settings, folder sizes, and running the Managed Folder Assistant.

---

## 🚀 Features

This script provides a menu-driven interface to perform the following actions:

1. **Get mailbox details**  
   View key attributes like Litigation Hold, Retention Policy, Single Item Recovery, and more.

2. **Get folder statistics (sorted by item count)**  
   Analyze mailbox folder sizes and item counts in descending order.

3. **Get mailbox retention settings**  
   Retrieve retention-related configurations.

4. **Get Recoverable Items folder stats**  
   Inspect the size and item count of the Recoverable Items folder.

5. **Get Inbox folder stats**  
   View statistics for the Inbox folder.

6. **Get mailbox storage statistics**  
   Check total item size, deleted item size, and item counts.

7. **Run Managed Folder Assistant**  
   Trigger MRM processing for the mailbox.

8. **Run Managed Folder Assistant (Full Crawl)**  
   Force a full crawl of the mailbox for MRM processing.

9. **Set RetainDeletedItemsFor to 0**  
   Reset retention of deleted items to zero days.

10. **Get Single Item Recovery and RetainDeletedItemsFor**  
    Review recovery and retention settings.

11. **Get Delay Hold status**  
    Check DelayHoldApplied and DelayReleaseHoldApplied flags.

0. **Exit**  
   Close the script.

---

## 🧰 Requirements

- Exchange Management Shell or Exchange Online PowerShell
- Appropriate permissions to run mailbox-related cmdlets
- PowerShell 5.1+ recommended

---

## 📦 Usage

1. Open PowerShell with administrative privileges.
2. Run the script:
   ```powershell
   .\ExchangeMailboxUtilityMenu.ps1
   
- Enter the target user's email address when prompted.
- Select an option from the menu to perform the desired action.
