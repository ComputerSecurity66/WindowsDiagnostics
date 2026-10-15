# 🖥️ Windows Diagnostics & System Analyzer

> 🔒 **PROPRIETARY SOFTWARE — NOT OPEN SOURCE**  
> Copyright © 2026 VALOR. All Rights Reserved.

**Windows Diagnostics & System Analyzer** is a PowerShell-based Windows diagnostic utility designed to help users and IT technicians inspect important system information from a single menu-driven interface.

The tool can review hardware and operating-system details, disk usage, memory and CPU status, network configuration, running processes, event logs, physical-disk health, Windows Update availability, services, startup programs, and generate an HTML system report.

---

# ✨ Features

## 🖥️ 1. System Information

Displays core Windows and hardware information including:

- Computer name
- Domain
- Operating system
- OS version
- Windows build
- Installation date
- System boot time
- Processor
- Installed RAM
- System manufacturer
- System model

The information is collected using Windows system-management interfaces such as:

```text
Get-ComputerInfo
Win32_OperatingSystem
```

---

## 💽 2. Disk Space Analysis

Analyzes mounted storage volumes that have drive letters.

The tool displays:

- Drive letter
- File-system label
- Total capacity
- Remaining capacity
- Used percentage

This can help identify drives that are approaching full capacity.

---

## 🧠 3. Memory & CPU Status

Displays current memory and processor information.

### Memory Information

The tool reports:

- Total RAM
- Used RAM
- Free RAM
- Memory usage percentage

High memory usage is highlighted for easier review.

### CPU Information

Displays:

- Processor model
- Physical cores
- Logical processors
- Maximum clock speed
- Current processor usage

High CPU usage can also be highlighted.

---

## 🌐 4. Network Configuration

Displays information about Windows network adapters.

The tool can show:

- Adapter name
- Adapter status
- Media connection state
- Link speed
- Interface name
- IPv4 address
- IPv6 address
- DNS server information

This can help with general network troubleshooting and configuration review.

---

## ⚙️ 5. Running Processes

Displays the **top 15 processes by memory usage**.

Information includes:

- Process name
- Process ID
- Memory usage
- Handle count
- Thread information

This can help identify applications or processes consuming large amounts of system memory.

> This is a resource-usage view and does not determine whether a process is malicious.

---

## 📋 6. Event Log Summary

Reviews recent Windows System event log entries from the previous 24 hours.

The tool displays recent:

- Errors
- Warnings
- Event times
- Event sources
- Event messages

Up to 10 recent entries from each category are displayed.

This can help identify operating-system, driver, hardware, or service-related problems.

---

## 💿 7. Disk Health Check

Reviews the health information exposed by Windows for installed physical disks.

The tool displays:

- Disk name
- Health status
- Operational status
- Disk capacity

This information is retrieved through:

```text
Get-PhysicalDisk
```

> The current implementation uses Windows physical-disk health reporting. It does not display the complete raw SMART attribute table provided by every disk manufacturer.

For this reason, the feature should be treated as a **general disk health assessment**, not a complete manufacturer-specific SMART diagnostic.

---

## 🔄 8. Windows Update Status

Uses the Windows Update API to search for updates that are currently not installed.

The tool displays:

- Number of available updates
- Update titles
- Update descriptions

If no updates are found, the application reports that the system appears up to date according to the Windows Update search result.

> This feature checks Windows Update availability. It does not automatically install updates.

---

## 🛠️ 9. System Services Status

Reviews Windows service information.

The current implementation displays selected system-related services as well as services that are currently stopped.

Information includes:

- Service name
- Display name
- Status
- Startup type

This can help technicians identify stopped services that may require further investigation.

> A stopped service does not automatically indicate a problem. Many Windows services are designed to start only when required.

---

## 🚀 10. Startup Programs

Displays Windows startup entries detected through:

```text
Win32_StartupCommand
```

Information includes:

- Startup item name
- Command
- Associated user

This can help users identify applications configured to start automatically with Windows.

---

# 📊 11. Generate Full HTML Report

The tool can generate a formatted HTML diagnostics report.

The report currently contains:

### System Information

- Computer name
- Operating system
- OS version
- Windows build
- Processor
- CPU cores
- Installed RAM

### Disk Information

- Drive letters
- Total disk capacity
- Free disk capacity
- Used percentage

### Process Information

- Top 10 processes by memory usage
- Memory usage
- Handle count

The report is saved to the user's Desktop.

Example filename:

```text
SystemDiagnosticsReport_20261015_192500.html
```

The report can be opened using a standard web browser.

---

# 🖥️ Main Menu

The application provides the following options:

```text
╔════════════════════════════════════════════════════════════╗
║          WINDOWS DIAGNOSTICS & SYSTEM ANALYZER            ║
╚════════════════════════════════════════════════════════════╝

 [1] System Information
 [2] Disk Space Analysis
 [3] Memory & CPU Status
 [4] Network Configuration
 [5] Running Processes
 [6] Event Log Summary
 [7] Disk Health Check
 [8] Windows Update Status
 [9] System Services Status
[10] Startup Programs
[11] Generate Full Report
[12] Exit
```

---

# 🛡️ Administrator Privileges

The script checks whether it is running with Windows Administrator privileges.

If Administrator privileges are not detected, it automatically requests elevation using Windows User Account Control.

The script restarts itself with elevated privileges using PowerShell.

Administrator rights may be required to access certain diagnostic and system-management information.

---

# 💻 Requirements

Recommended environment:

- Windows 10
- Windows 11
- Windows PowerShell
- Administrator privileges
- Windows Management Instrumentation / CIM
- Windows Update service access
- Storage-management cmdlets
- Network-management cmdlets

Some functionality may vary depending on:

- Windows edition
- Windows version
- System configuration
- Available PowerShell modules
- Hardware support
- Security policies

---

# 🚀 How to Run

Clone or download the repository.

Open PowerShell and navigate to the project directory.

Run:

```powershell
.\WindowsDiagnositcs.ps1
```

The application may request Administrator privileges through Windows UAC.

---

# 🔄 Typical Diagnostic Workflow

```text
Start Application
       │
       ▼
Administrator Check
       │
       ▼
System Information
       │
       ├──► CPU / RAM
       │
       ├──► Disk Space
       │
       ├──► Network
       │
       ├──► Processes
       │
       ├──► Event Logs
       │
       ├──► Disk Health
       │
       ├──► Windows Update
       │
       ├──► Services
       │
       └──► Startup Programs
                    │
                    ▼
             Generate HTML Report
```

---

# 🔍 Common Use Cases

Windows Diagnostics & System Analyzer can assist with:

- General Windows diagnostics
- Desktop support
- Hardware information review
- Performance investigation
- Disk-space checks
- Memory usage checks
- CPU usage checks
- Network configuration review
- Event-log inspection
- Disk-health assessment
- Windows Update checks
- Service review
- Startup-program review
- System documentation
- IT troubleshooting

---

# ⚠️ Important Limitations

This application is an **information gathering and diagnostic utility**.

It does not automatically repair detected issues.

It does not guarantee detection of:

- Malware
- Rootkits
- Hardware failures
- Driver corruption
- Network attacks
- File-system corruption
- Memory defects
- CPU defects
- Every Windows error

It also does not replace:

- Microsoft Defender
- Enterprise EDR/XDR
- Manufacturer hardware diagnostics
- Professional SMART analysis tools
- Memory-testing utilities
- Network monitoring platforms
- Professional IT troubleshooting

The information provided by the tool should be reviewed together with other diagnostic evidence.

---

# ⚠️ Event Log Notice

Windows event logs frequently contain warnings and errors that do not necessarily represent critical system problems.

A diagnostic finding should be reviewed in context before taking corrective action.

Do not remove software, disable services, or change important Windows settings solely because an event appears in the report.

---

# ⚠️ Services Notice

The system-services section may display stopped services.

A service being stopped does **not automatically mean that Windows has a problem**.

Many services use:

```text
Manual
Trigger Start
Automatic
Disabled
```

depending on their intended purpose.

Always review the service documentation before changing its configuration.

---

# 💿 Disk Health Notice

The current disk-health function relies on the health and operational information made available through Windows `Get-PhysicalDisk`.

A reported:

```text
Healthy
```

status should not be interpreted as a guarantee that a storage device cannot fail.

Important data should always have an appropriate backup strategy.

---

# 🔐 Security & Privacy

The application reads local system information for diagnostic purposes.

The generated HTML report may contain information such as:

- Computer name
- Operating system
- Hardware configuration
- Processor information
- Disk information
- Running process names

Review diagnostic reports before uploading them publicly or sending them to another person.

Do not publish system reports containing information you consider private or sensitive.

---

# 🧑‍💻 Technician Use

The tool can be useful for authorized IT support environments including:

- Desktop support
- Remote support
- Windows maintenance
- System inventory
- Preliminary troubleshooting
- Hardware assessment
- Performance investigation
- Incident triage

The project is designed to place several common Windows diagnostic commands into one simple menu-driven PowerShell application.

---

# 🛠️ Technology

The project uses Windows PowerShell technologies including:

```text
PowerShell
Get-ComputerInfo
Get-CimInstance
Get-Volume
Get-PhysicalDisk
Get-NetAdapter
Get-NetIPConfiguration
Get-Process
Get-EventLog
Get-Service
Windows Update COM API
Win32_StartupCommand
HTML Report Generation
Windows UAC Elevation
```

---

# 🚫 Proprietary Software Notice

**Windows Diagnostics & System Analyzer** is proprietary software developed by **VALOR**.

Copyright © 2026 VALOR. All Rights Reserved.

This project is **not open-source software**.

Unless expressly authorized in writing by the copyright holder, you may not:

- Copy the source code
- Modify the source code
- Create derivative works
- Redistribute the software
- Publish modified versions
- Repackage the software
- Sell the software
- Incorporate the source code into another product
- Sublicense the software
- Remove or alter copyright notices
- Re-license the project
- Release modified versions under an open-source license
- Convert the project into an open-source project

No permission is granted under:

- MIT
- Apache-2.0
- GPL
- LGPL
- BSD
- Or another open-source license

All rights not expressly granted are reserved by the copyright holder.

See the project's `LICENSE` file for the complete licensing terms.

---

# 📜 License

This project is distributed under a **proprietary license**.

Copyright © 2026 VALOR. All Rights Reserved.

No open-source license is granted.

Modification, redistribution, commercial use, derivative development, integration, or other use outside the permissions expressly granted by the proprietary license requires written authorization from the copyright holder.

---

# 👤 Project Information

**Project Name:** Windows Diagnostics & System Analyzer  
**Version:** 1.0  
**Developer:** VALOR  
**Language:** PowerShell  
**Platform:** Windows  
**Category:** System Diagnostics & Analysis  
**Copyright:** © 2026 VALOR

---

# 🔒 Copyright

Copyright © 2026 VALOR. All Rights Reserved.

**Windows Diagnostics & System Analyzer is proprietary software and is not open source.**
