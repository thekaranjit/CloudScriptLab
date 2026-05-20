<#
.SYNOPSIS
    Shuts down Azure VMs based on user-specified tag criteria after confirmation.

.DESCRIPTION
    This script prompts the user to specify a tag key and value, then retrieves all Virtual Machines
    in the current Azure subscription that match the specified tag criteria. It displays the count and
    list of matching VMs, and prompts for confirmation before proceeding with the shutdown operation.

.PARAMETERS
    Force
        Switch parameter to skip the confirmation prompt and proceed directly with shutdown.

.NOTES
    Prerequisites:
    - PowerShell 5.1 or later
    - Azure PowerShell module (Az) installed
    - User must be authenticated to Azure (Connect-AzAccount or az login)

.EXAMPLE
    .\Invoke-VMAutoShutdownByTag.ps1
    # Prompts for tag key and value, then shows matching VMs before shutdown

.EXAMPLE
    .\Invoke-VMAutoShutdownByTag.ps1 -Force
    # Prompts for tag key and value, then proceeds with shutdown without confirmation

.AUTHOR
    Azure Automation Team

.VERSION
    1.1
#>

param(
    [switch]$Force
)

# Enable verbose preference for detailed output
$VerbosePreference = "Continue"

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Azure VM Auto-Shutdown by Tag" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

try {
    # Check if user is authenticated to Azure
    $context = Get-AzContext
    if ($null -eq $context) {
        Write-Host "Not authenticated to Azure. Please run 'Connect-AzAccount' first." -ForegroundColor Red
        exit 1
    }
    
    Write-Host "Current Azure Account: $($context.Account.Id)" -ForegroundColor Green
    Write-Host "Subscription: $($context.Subscription.Name)" -ForegroundColor Green
    Write-Host ""
    
    # Prompt user for tag key and value
    Write-Host "Please provide the tag filter criteria:" -ForegroundColor Cyan
    $tagKey = Read-Host "Enter tag key (e.g., OffPeakShutdown)"
    $tagValue = Read-Host "Enter tag value (e.g., true)"
    
    if ([string]::IsNullOrWhiteSpace($tagKey) -or [string]::IsNullOrWhiteSpace($tagValue)) {
        Write-Host "Tag key and value cannot be empty." -ForegroundColor Red
        exit 1
    }
    
    Write-Host ""
    Write-Host "Searching for VMs with tag '$tagKey=$tagValue'..." -ForegroundColor Yellow
    
    $vms = Get-AzVM | Where-Object {
        $_.Tags -and $_.Tags.ContainsKey($tagKey) -and $_.Tags[$tagKey] -eq $tagValue
    }
    
    $vmCount = $vms.Count
    
    # Handle the case when no VMs are found
    if ($vmCount -eq 0) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Yellow
        Write-Host "No VM with tag key '$tagKey' and value '$tagValue' found." -ForegroundColor Yellow
        Write-Host "========================================" -ForegroundColor Yellow
        Write-Host ""
        exit 0
    }
    
    # Display the count of VMs that will be shutdown
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "IMPORTANT: The following $vmCount VM(s) will be shut down:" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Display VM details in a formatted table
    $vms | Select-Object @{Name="VM Name"; Expression={$_.Name}},
                         @{Name="Resource Group"; Expression={$_.ResourceGroupName}},
                         @{Name="Status"; Expression={
                             $vmStatus = Get-AzVM -ResourceGroupName $_.ResourceGroupName -Name $_.Name -Status
                             $powerState = $vmStatus.Statuses | Where-Object {$_.Code -like "PowerState/*"}
                             $powerState.DisplayStatus
                         }} | Format-Table -AutoSize
    
    Write-Host ""
    Write-Host "Total VMs to shutdown: $vmCount" -ForegroundColor Yellow
    Write-Host ""
    
    # Prompt for confirmation unless Force switch is used
    if (-not $Force) {
        $response = Read-Host "Do you want to proceed with shutting down these VMs? (yes/no)"
        
        if ($response -ne "yes" -and $response -ne "y") {
            Write-Host "Shutdown cancelled by user." -ForegroundColor Yellow
            exit 0
        }
    }
    
    Write-Host ""
    Write-Host "Proceeding with shutdown of $vmCount VM(s)..." -ForegroundColor Green
    Write-Host ""
    
    $successCount = 0
    $failureCount = 0
    $failedVMs = @()
    
    # Shutdown each VM
    foreach ($vm in $vms) {
        try {
            Write-Host "Stopping VM: $($vm.Name) in Resource Group: $($vm.ResourceGroupName)" -ForegroundColor Cyan
            
            # Stop the VM with NoWait to improve performance for multiple VMs
            Stop-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Force -NoWait -ErrorAction Stop | Out-Null
            
            Write-Host "  ✓ Successfully initiated shutdown for $($vm.Name)" -ForegroundColor Green
            $successCount++
        }
        catch {
            Write-Host "  ✗ Failed to stop $($vm.Name): $($_.Exception.Message)" -ForegroundColor Red
            $failureCount++
            $failedVMs += $vm.Name
        }
    }
    
    # Summary
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Shutdown Operation Summary" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Total VMs processed: $vmCount" -ForegroundColor White
    Write-Host "Successfully shutdown initiated: $successCount" -ForegroundColor Green
    Write-Host "Failed: $failureCount" -ForegroundColor $(if ($failureCount -gt 0) { "Red" } else { "Green" })
    
    if ($failedVMs.Count -gt 0) {
        Write-Host "Failed VMs:" -ForegroundColor Red
        $failedVMs | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    }
    
    Write-Host ""
    Write-Host "Note: Shutdown operations are initiated asynchronously." -ForegroundColor Yellow
    Write-Host "VMs may take a few minutes to fully power down." -ForegroundColor Yellow
    Write-Host ""
}
catch {
    Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
