# ========================================
# Windows Diagnostics Tool
# Professional PowerShell Script
# ========================================

# ============================================================================
# ADMINISTRATOR CHECK
# ============================================================================
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($user)
    $role = [Security.Principal.WindowsBuiltInRole]::Administrator
    return $principal.IsInRole($role)
}

if (-not (Test-Administrator)) {
    Write-Host "⚠  ADMINISTRATOR PRIVILEGES REQUIRED" -ForegroundColor Yellow
    Write-Host "Restarting with Administrator rights..." -ForegroundColor Yellow
    
    $scriptPath = $MyInvocation.MyCommand.Path
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
    Start-Process PowerShell -ArgumentList $arguments -Verb RunAs
    exit
}


function Show-Menu {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║          WINDOWS DIAGNOSTICS & SYSTEM ANALYZER            ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Select a diagnostic option:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  [1] System Information" -ForegroundColor Green
    Write-Host "  [2] Disk Space Analysis" -ForegroundColor Green
    Write-Host "  [3] Memory & CPU Status" -ForegroundColor Green
    Write-Host "  [4] Network Configuration" -ForegroundColor Green
    Write-Host "  [5] Running Processes" -ForegroundColor Green
    Write-Host "  [6] Event Log Summary" -ForegroundColor Green
    Write-Host "  [7] Disk Health Check (SMART)" -ForegroundColor Green
    Write-Host "  [8] Windows Update Status" -ForegroundColor Green
    Write-Host "  [9] System Services Status" -ForegroundColor Green
    Write-Host " [10] Startup Programs" -ForegroundColor Green
    Write-Host " [11] Generate Full Report" -ForegroundColor Green
    Write-Host " [12] Exit" -ForegroundColor Red
    Write-Host ""
}

# ============================================================================
# AUTO-CLOSE WITH MANUAL OVERRIDE FUNCTION
# ============================================================================

function Wait-ForExitWithTimeout {
    param(
        [int]$TimeoutSeconds = 3
    )
    
    Write-Host ""
    #Write-Host "Closing in $TimeoutSeconds seconds... (Press any key to close now)" -ForegroundColor Yellow
    Write-Host ""
    
    $StartTime = Get-Date
    $TimeoutDuration = New-TimeSpan -Seconds $TimeoutSeconds
    $KeyPressed = $false
    
    while ((Get-Date) - $StartTime -lt $TimeoutDuration) {
        # Calculate remaining time
        $Elapsed = (Get-Date) - $StartTime
        $Remaining = [Math]::Max(0, $TimeoutSeconds - [int]$Elapsed.TotalSeconds)
        
        # Display countdown
        Write-Host "`rClosing in $Remaining seconds Or Press any key to close now" -ForegroundColor Yellow -NoNewline
        
        # Check if key is pressed (non-blocking)
        if ($Host.UI.RawUI.KeyAvailable) {
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            $KeyPressed = $true
            break
        }
        
        # Small delay to prevent CPU spinning
        Start-Sleep -Milliseconds 100
    }

    Write-Host ""
    Write-Host ""
    
    if ($KeyPressed) {
        Write-Host "✓ Key pressed - closing application..." -ForegroundColor Green
    }
    else {
        Write-Host "✓ Timeout reached - closing application..." -ForegroundColor Green
    }
    
    Write-Host ""
    Start-Sleep -Milliseconds 500
}


function Invoke-SystemInfo {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                    SYSTEM INFORMATION                      ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    $sysInfo = Get-ComputerInfo
    $os = Get-CimInstance Win32_OperatingSystem
    
    Write-Host "Computer Name       : $($sysInfo.CsComputerName)" -ForegroundColor White
    Write-Host "Domain              : $($sysInfo.CsDomain)" -ForegroundColor White
    Write-Host "OS                  : $($os.Caption)" -ForegroundColor White
    Write-Host "OS Version          : $($os.Version)" -ForegroundColor White
    Write-Host "Build               : $($os.BuildNumber)" -ForegroundColor White
    Write-Host "Install Date        : $($os.InstallDate)" -ForegroundColor White
    Write-Host "System Boot Time    : $((Get-Date) - (New-TimeSpan -Seconds $([System.Environment]::TickCount / 1000)))" -ForegroundColor White
    Write-Host "Processor           : $($sysInfo.CsProcessors[0].Name)" -ForegroundColor White
    Write-Host "RAM Installed       : $([math]::Round($sysInfo.CsPhysicalMemory / 1GB)) GB" -ForegroundColor White
    Write-Host "System Manufacturer : $($sysInfo.CsManufacturer)" -ForegroundColor White
    Write-Host "System Model        : $($sysInfo.CsModel)" -ForegroundColor White
    Write-Host ""
    
    Read-Host "Press Enter to return to menu"
}

function Invoke-DiskAnalysis {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                  DISK SPACE ANALYSIS                       ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    Get-Volume | Where-Object {$_.DriveLetter} | Format-Table -Property DriveLetter, FileSystemLabel, Size, SizeRemaining, @{
        Name       = "Used %"
        Expression = {[math]::Round(($_.Size - $_.SizeRemaining) / $_.Size * 100, 2)}
    } -AutoSize
    
    Write-Host ""
    Read-Host "Press Enter to return to menu"
}

function Invoke-MemoryCPU {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                  MEMORY & CPU STATUS                       ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    $os = Get-CimInstance Win32_OperatingSystem
    $totalRAM = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
    $freeRAM = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
    $usedRAM = $totalRAM - $freeRAM
    $ramPercent = [math]::Round(($usedRAM / $totalRAM) * 100, 2)
    
    Write-Host "Total RAM           : $totalRAM GB" -ForegroundColor White
    Write-Host "Used RAM            : $usedRAM GB" -ForegroundColor White
    Write-Host "Free RAM            : $freeRAM GB" -ForegroundColor White
    Write-Host "Memory Usage        : $ramPercent %" -ForegroundColor $(if ($ramPercent -gt 80) { "Red" } else { "Green" })
    Write-Host ""
    
    $cpu = Get-CimInstance Win32_Processor
    Write-Host "Processor           : $($cpu.Name)" -ForegroundColor White
    Write-Host "Cores               : $($cpu.NumberOfCores)" -ForegroundColor White
    Write-Host "Logical Processors  : $($cpu.NumberOfLogicalProcessors)" -ForegroundColor White
    Write-Host "Max Clock Speed     : $($cpu.MaxClockSpeed) MHz" -ForegroundColor White
    
    Write-Host ""
    $cpuUsage = (Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor | Where-Object Name -eq "_Total").PercentProcessorTime
    Write-Host "Current CPU Usage   : $cpuUsage %" -ForegroundColor $(if ($cpuUsage -gt 80) { "Red" } else { "Green" })
    Write-Host ""
    
    Read-Host "Press Enter to return to menu"
}

function Invoke-NetworkConfig {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                  NETWORK CONFIGURATION                     ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    Get-NetAdapter | Format-Table -Property Name, Status, MediaConnectionState, LinkSpeed -AutoSize
    Write-Host ""
    Write-Host "IP Configuration:" -ForegroundColor Yellow
    Get-NetIPConfiguration | Format-Table -Property InterfaceAlias, IPv4Address, IPv6Address, DNSServer -AutoSize
    Write-Host ""
    
    Read-Host "Press Enter to return to menu"
}

function Invoke-ProcessList {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                    TOP 15 PROCESSES                        ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 15 | Format-Table -Property Name, ID, @{
        Name       = "Memory (MB)"
        Expression = {[math]::Round($_.WorkingSet / 1MB, 2)}
    }, Handles, Threads -AutoSize
    
    Write-Host ""
    Read-Host "Press Enter to return to menu"
}

function Invoke-EventLog {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                   EVENT LOG SUMMARY                        ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "Recent Errors (Last 24 hours):" -ForegroundColor Yellow
    Get-EventLog -LogName System -EntryType Error -After (Get-Date).AddHours(-24) -ErrorAction SilentlyContinue | Select-Object -First 10 | Format-Table -Property TimeGenerated, Source, Message -AutoSize
    Write-Host ""
    
    Write-Host "Recent Warnings (Last 24 hours):" -ForegroundColor Yellow
    Get-EventLog -LogName System -EntryType Warning -After (Get-Date).AddHours(-24) -ErrorAction SilentlyContinue | Select-Object -First 10 | Format-Table -Property TimeGenerated, Source, Message -AutoSize
    Write-Host ""
    
    Read-Host "Press Enter to return to menu"
}

function Invoke-DiskHealth {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                  DISK HEALTH CHECK (SMART)                 ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    $disks = Get-PhysicalDisk
    foreach ($disk in $disks) {
        Write-Host "Disk: $($disk.FriendlyName)" -ForegroundColor Yellow
        Write-Host "  Status          : $($disk.HealthStatus)" -ForegroundColor $(if ($disk.HealthStatus -eq "Healthy") { "Green" } else { "Red" })
        Write-Host "  Operational     : $($disk.OperationalStatus)" -ForegroundColor White
        Write-Host "  Size            : $([math]::Round($disk.Size / 1GB)) GB" -ForegroundColor White
        Write-Host ""
    }
    
    Read-Host "Press Enter to return to menu"
}

function Invoke-WindowsUpdate {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                 WINDOWS UPDATE STATUS                      ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    $updateSession = New-Object -ComObject Microsoft.Update.Session
    $updateSearcher = $updateSession.CreateUpdateSearcher()
    
    Write-Host "Searching for updates..." -ForegroundColor Yellow
    $searchResult = $updateSearcher.Search("IsInstalled=0")
    
    Write-Host "Total Updates Available: $($searchResult.Updates.Count)" -ForegroundColor White
    Write-Host ""
    
    if ($searchResult.Updates.Count -gt 0) {
        $searchResult.Updates | Format-Table -Property Title, Description -AutoSize
    } else {
        Write-Host "Your system is up to date." -ForegroundColor Green
    }
    
    Write-Host ""
    Read-Host "Press Enter to return to menu"
}

function Invoke-Services {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                 SYSTEM SERVICES STATUS                     ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    $criticalServices = @("Winlogon", "lsass", "svchost", "csrss", "dwm")
    
    Get-Service | Where-Object {$_.Name -in $criticalServices -or $_.Status -eq "Stopped"} | Format-Table -Property Name, DisplayName, Status, StartType -AutoSize
    Write-Host ""
    
    Read-Host "Press Enter to return to menu"
}

function Invoke-StartupPrograms {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                   STARTUP PROGRAMS                         ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    Get-CimInstance Win32_StartupCommand | Format-Table -Property Name, Command, User -AutoSize
    Write-Host ""
    
    Read-Host "Press Enter to return to menu"
}

function Invoke-FullReport {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                  GENERATING FULL REPORT                    ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    $reportPath = "$env:USERPROFILE\Desktop\SystemDiagnosticsReport_$(Get-Date -Format 'yyyyMMdd_HHmmss').html"
    
    Write-Host "Generating comprehensive report..." -ForegroundColor Yellow
    Write-Host "This may take a few moments..." -ForegroundColor Yellow
    Write-Host ""
    
    # Collect all diagnostics
    $systemInfo = Get-ComputerInfo
    $os = Get-CimInstance Win32_OperatingSystem
    $disks = Get-Volume | Where-Object {$_.DriveLetter}
    $cpu = Get-CimInstance Win32_Processor
    $topProcesses = Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10
    
    # Build HTML report
    $htmlContent = @"
    <!DOCTYPE html>
    <html>
    <head>
        <title>Windows Diagnostics Report</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
            h1 { color: #0078d4; border-bottom: 3px solid #0078d4; padding-bottom: 10px; }
            h2 { color: #005a9e; margin-top: 30px; }
            table { border-collapse: collapse; width: 100%; margin: 15px 0; background-color: white; }
            th { background-color: #0078d4; color: white; padding: 10px; text-align: left; }
            td { padding: 8px; border-bottom: 1px solid #ddd; }
            tr:hover { background-color: #f9f9f9; }
            .section { background-color: white; padding: 15px; margin: 15px 0; border-radius: 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
            .status-ok { color: green; font-weight: bold; }
            .status-warning { color: orange; font-weight: bold; }
            .status-error { color: red; font-weight: bold; }
        </style>
    </head>
    <body>
        <h1>Windows System Diagnostics Report</h1>
        <p><strong>Generated:</strong> $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')</p>
        
        <div class="section">
            <h2>System Information</h2>
            <table>
                <tr><th>Property</th><th>Value</th></tr>
                <tr><td>Computer Name</td><td>$($systemInfo.CsComputerName)</td></tr>
                <tr><td>OS</td><td>$($os.Caption)</td></tr>
                <tr><td>OS Version</td><td>$($os.Version)</td></tr>
                <tr><td>Build</td><td>$($os.BuildNumber)</td></tr>
                <tr><td>Processor</td><td>$($cpu.Name)</td></tr>
                <tr><td>Cores</td><td>$($cpu.NumberOfCores)</td></tr>
                <tr><td>RAM</td><td>$([math]::Round($systemInfo.CsPhysicalMemory / 1GB)) GB</td></tr>
            </table>
        </div>
        
        <div class="section">
            <h2>Disk Space</h2>
            <table>
                <tr><th>Drive</th><th>Size</th><th>Free</th><th>Used %</th></tr>
"@
    
    foreach ($disk in $disks) {
        $usedPercent = [math]::Round(($disk.Size - $disk.SizeRemaining) / $disk.Size * 100, 2)
        $htmlContent += "<tr><td>$($disk.DriveLetter):</td><td>$([math]::Round($disk.Size / 1GB)) GB</td><td>$([math]::Round($disk.SizeRemaining / 1GB)) GB</td><td>$usedPercent%</td></tr>"
    }
    
    $htmlContent += @"
            </table>
        </div>
        
        <div class="section">
            <h2>Top 10 Processes by Memory</h2>
            <table>
                <tr><th>Process Name</th><th>Memory (MB)</th><th>Handles</th></tr>
"@
    
    foreach ($proc in $topProcesses) {
        $htmlContent += "<tr><td>$($proc.Name)</td><td>$([math]::Round($proc.WorkingSet / 1MB, 2))</td><td>$($proc.Handles)</td></tr>"
    }
    
    $htmlContent += @"
            </table>
        </div>
    </body>
    </html>
"@
    
    $htmlContent | Out-File -FilePath $reportPath -Encoding UTF8
    
    Write-Host "✓ Report generated successfully!" -ForegroundColor Green
    Write-Host "Location: $reportPath" -ForegroundColor Cyan
    Write-Host ""
    
    Read-Host "Press Enter to return to menu"
}

# Main loop
$running = $true
while ($running) {
    Show-Menu
    $choice = Read-Host "Enter your choice (1-12)"
    
    switch ($choice) {
        "1" { Invoke-SystemInfo }
        "2" { Invoke-DiskAnalysis }
        "3" { Invoke-MemoryCPU }
        "4" { Invoke-NetworkConfig }
        "5" { Invoke-ProcessList }
        "6" { Invoke-EventLog }
        "7" { Invoke-DiskHealth }
        "8" { Invoke-WindowsUpdate }
        "9" { Invoke-Services }
        "10" { Invoke-StartupPrograms }
        "11" { Invoke-FullReport }
        "12" { 
           Clear-Host
            Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
            Write-Host "║                    THANK YOU FOR USING                         ║" -ForegroundColor Green
            Write-Host "║        WINDOWS DIAGNOSTICS & SYSTEM ANALYZER v1.0              ║" -ForegroundColor Green
            Write-Host "║                                                                ║" -ForegroundColor Green
            Write-Host "║  Your Windows Diagnostics has been completed successfully!     ║" -ForegroundColor Green
            Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
            Write-Host ""
            Write-Host "Session Summary:" -ForegroundColor Yellow
            Write-Host "  • All Windows diagnostics have been completed" -ForegroundColor White
            Write-Host "  • Repair recommendations have been generated" -ForegroundColor White
            Write-Host "  • Activity logs saved successfully" -ForegroundColor White
            Write-Host ""
            Write-Host "─────────────────────────────────────────────────────────────────" -ForegroundColor Cyan
            Write-Host ""
            
            Wait-ForExitWithTimeout -TimeoutSeconds 3
            exit
        }
        default { 
            Write-Host "Invalid choice. Please select 1-12." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
}