#=============================================================================
# Azure VM Tagging Script
# Author: DevOps Team
# Description: Apply consistent resource tags across multiple Azure VMs
#              with validation, error handling, and reporting
#=============================================================================

param(
    [Parameter(Mandatory = $false)]
    [string]$SubscriptionId,
    
    [Parameter(Mandatory = $false)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory = $true)]
    [hashtable]$Tags,
    
    [Parameter(Mandatory = $false)]
    [string]$VMNameFilter = "*",
    
    [Parameter(Mandatory = $false)]
    [switch]$DryRun,
    
    [Parameter(Mandatory = $false)]
    [string]$ReportPath = ".\TaggingReport_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
)

#=============================================================================
# Logging Functions
#=============================================================================

function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("INFO", "SUCCESS", "WARNING", "ERROR")]
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = @{
        "INFO"    = "Cyan"
        "SUCCESS" = "Green"
        "WARNING" = "Yellow"
        "ERROR"   = "Red"
    }
    
    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color[$Level]
}

#=============================================================================
# Validation Functions
#=============================================================================

function Test-AzureConnection {
    Write-Log "Checking Azure connection..." "INFO"
    
    try {
        $context = Get-AzContext
        if (!$context) {
            Write-Log "Not connected to Azure. Please run: Connect-AzAccount" "ERROR"
            exit 1
        }
        Write-Log "Successfully connected to Azure" "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Failed to connect to Azure: $_" "ERROR"
        exit 1
    }
}

function Test-TagFormat {
    param([hashtable]$TagsToValidate)
    
    Write-Log "Validating tag format..." "INFO"
    
    if (!$TagsToValidate -or $TagsToValidate.Count -eq 0) {
        Write-Log "No tags provided" "ERROR"
        return $false
    }
    
    foreach ($key in $TagsToValidate.Keys) {
        # Validate key format (alphanumeric, hyphens, underscores only)
        if ($key -notmatch '^[a-zA-Z0-9_-]+$') {
            Write-Log "Invalid tag key format: '$key'. Use alphanumeric, hyphens, or underscores only" "ERROR"
            return $false
        }
        
        # Validate value is not empty
        if ([string]::IsNullOrWhiteSpace($TagsToValidate[$key])) {
            Write-Log "Tag value for key '$key' cannot be empty" "ERROR"
            return $false
        }
    }
    
    Write-Log "Tag format validation passed" "SUCCESS"
    return $true
}

function Set-Subscription {
    param([string]$SubId)
    
    try {
        if ($SubId) {
            Write-Log "Setting subscription to: $SubId" "INFO"
            Set-AzContext -SubscriptionId $SubId | Out-Null
        } else {
            Write-Log "Using current subscription context" "INFO"
        }
        return $true
    }
    catch {
        Write-Log "Failed to set subscription: $_" "ERROR"
        return $false
    }
}

#=============================================================================
# VM Discovery Functions
#=============================================================================

function Get-TargetVMs {
    param(
        [string]$RGName,
        [string]$VMFilter
    )
    
    Write-Log "Discovering target VMs..." "INFO"
    
    try {
        if ($RGName) {
            Write-Log "Filtering by Resource Group: $RGName" "INFO"
            $vms = Get-AzVM -ResourceGroupName $RGName -Name $VMFilter -ErrorAction SilentlyContinue
        } else {
            Write-Log "Filtering across all Resource Groups" "INFO"
            $vms = Get-AzVM -Name $VMFilter -ErrorAction SilentlyContinue
        }
        
        if (!$vms) {
            Write-Log "No VMs found matching criteria" "WARNING"
            return @()
        }
        
        # Convert single VM to array
        if ($vms -isnot [array]) {
            $vms = @($vms)
        }
        
        Write-Log "Found $($vms.Count) VM(s) to process" "SUCCESS"
        return $vms
    }
    catch {
        Write-Log "Error discovering VMs: $_" "ERROR"
        return @()
    }
}

#=============================================================================
# Tag Merge & Application Functions
#=============================================================================

function Merge-Tags {
    param(
        [hashtable]$ExistingTags,
        [hashtable]$NewTags
    )
    
    $merged = @{}
    
    # Copy existing tags
    if ($ExistingTags) {
        foreach ($key in $ExistingTags.Keys) {
            $merged[$key] = $ExistingTags[$key]
        }
    }
    
    # Add/override with new tags
    foreach ($key in $NewTags.Keys) {
        $merged[$key] = $NewTags[$key]
    }
    
    return $merged
}

function Apply-VMTags {
    param(
        [object]$VM,
        [hashtable]$TagsToApply,
        [bool]$IsDryRun
    )
    
    try {
        $existingTags = $VM.Tags
        $mergedTags = Merge-Tags -ExistingTags $existingTags -NewTags $TagsToApply
        
        if ($IsDryRun) {
            Write-Log "[$($VM.Name)] DRY RUN: Would apply tags: $($mergedTags | ConvertTo-Json)" "INFO"
            return @{
                Success = $true
                Message = "Dry run - no changes applied"
                NewTagCount = $mergedTags.Count
            }
        } else {
            # Apply tags to VM
            Update-AzTag -ResourceId $VM.Id -Tag $mergedTags -Operation Merge | Out-Null
            
            Write-Log "[$($VM.Name)] Successfully applied tags" "SUCCESS"
            return @{
                Success = $true
                Message = "Tags applied successfully"
                NewTagCount = $mergedTags.Count
            }
        }
    }
    catch {
        Write-Log "[$($VM.Name)] Failed to apply tags: $_" "ERROR"
        return @{
            Success = $false
            Message = $_.Exception.Message
            NewTagCount = 0
        }
    }
}

#=============================================================================
# Reporting Functions
#=============================================================================

function New-ReportEntry {
    param(
        [string]$VMName,
        [string]$ResourceGroup,
        [bool]$Success,
        [string]$Message,
        [int]$TagCount
    )
    
    return [PSCustomObject]@{
        Timestamp       = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        VMName          = $VMName
        ResourceGroup   = $ResourceGroup
        Status          = if ($Success) { "SUCCESS" } else { "FAILED" }
        Message         = $Message
        TagsApplied     = $TagCount
    }
}

function Save-Report {
    param(
        [array]$ReportData,
        [string]$Path
    )
    
    try {
        $ReportData | Export-Csv -Path $Path -NoTypeInformation -Force
        Write-Log "Report saved to: $Path" "SUCCESS"
    }
    catch {
        Write-Log "Failed to save report: $_" "ERROR"
    }
}

function Show-Summary {
    param(
        [array]$ReportData,
        [hashtable]$NewTags,
        [bool]$IsDryRun
    )
    
    Write-Host "`n" + ("=" * 70) -ForegroundColor Cyan
    Write-Host "TAGGING OPERATION SUMMARY" -ForegroundColor Cyan
    Write-Host ("=" * 70) -ForegroundColor Cyan
    
    $mode = if ($IsDryRun) { "DRY RUN" } else { "APPLIED" }
    Write-Host "Mode: $mode" -ForegroundColor Yellow
    
    Write-Host "`nTags to be $mode`:" -ForegroundColor Cyan
    foreach ($key in $NewTags.Keys) {
        Write-Host "  • $key = $($NewTags[$key])" -ForegroundColor White
    }
    
    $successful = ($ReportData | Where-Object { $_.Status -eq "SUCCESS" }).Count
    $failed = ($ReportData | Where-Object { $_.Status -eq "FAILED" }).Count
    
    Write-Host "`nResults:" -ForegroundColor Cyan
    Write-Host "  ✓ Successful: $successful" -ForegroundColor Green
    Write-Host "  ✗ Failed: $failed" -ForegroundColor Red
    Write-Host "  → Total Processed: $($ReportData.Count)" -ForegroundColor Yellow
    
    if ($failed -gt 0) {
        Write-Host "`nFailed VMs:" -ForegroundColor Red
        $ReportData | Where-Object { $_.Status -eq "FAILED" } | ForEach-Object {
            Write-Host "  ✗ $($_.VMName) - $($_.Message)" -ForegroundColor Red
        }
    }
    
    Write-Host "`n" + ("=" * 70) -ForegroundColor Cyan
}

#=============================================================================
# Main Execution
#=============================================================================

function Main {
    Write-Log "========================================" "INFO"
    Write-Log "Azure VM Tagging Script Started" "INFO"
    Write-Log "========================================" "INFO"
    
    # Step 1: Validate prerequisites
    if (!(Test-AzureConnection)) {
        exit 1
    }
    
    if (!(Test-TagFormat -TagsToValidate $Tags)) {
        exit 1
    }
    
    if (!(Set-Subscription -SubId $SubscriptionId)) {
        exit 1
    }
    
    # Step 2: Discover VMs
    $vms = Get-TargetVMs -RGName $ResourceGroupName -VMFilter $VMNameFilter
    
    if ($vms.Count -eq 0) {
        Write-Log "No VMs found to process. Exiting." "WARNING"
        exit 0
    }
    
    # Step 3: Show preview
    Write-Log "`nPreview of VMs to be processed:" "INFO"
    $vms | ForEach-Object {
        Write-Log "  • $($_.Name) (RG: $($_.ResourceGroupName))" "INFO"
    }
    
    if ($DryRun) {
        Write-Log "Running in DRY RUN mode - no changes will be applied" "WARNING"
    } else {
        Write-Log "PRODUCTION MODE - Changes will be applied" "WARNING"
        $confirmation = Read-Host "Are you sure you want to continue? (yes/no)"
        if ($confirmation -ne "yes") {
            Write-Log "Operation cancelled by user" "WARNING"
            exit 0
        }
    }
    
    # Step 4: Apply tags
    Write-Log "Starting tag application process..." "INFO"
    $reportData = @()
    
    foreach ($vm in $vms) {
        Write-Log "Processing VM: $($vm.Name)" "INFO"
        
        $result = Apply-VMTags -VM $vm -TagsToApply $Tags -IsDryRun $DryRun.IsPresent
        
        $reportEntry = New-ReportEntry `
            -VMName $vm.Name `
            -ResourceGroup $vm.ResourceGroupName `
            -Success $result.Success `
            -Message $result.Message `
            -TagCount $result.NewTagCount
        
        $reportData += $reportEntry
    }
    
    # Step 5: Generate report
    Save-Report -ReportData $reportData -Path $ReportPath
    
    # Step 6: Show summary
    Show-Summary -ReportData $reportData -NewTags $Tags -IsDryRun $DryRun.IsPresent
    
    Write-Log "========================================" "INFO"
    Write-Log "Script Execution Completed" "INFO"
    Write-Log "========================================" "INFO"
}

# Run main function
Main
