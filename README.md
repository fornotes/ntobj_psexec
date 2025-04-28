# PsExec-like Functionality with NtObjectManager Demo

## Purpose
This repository demonstrates how **NtObjectManager** can be used to create functionality similar to **PsExec**.

Specifically, it replicates the effect of running:
```bash
PsExec.exe -s cmd.exe
```
Note:
These scripts are currently designed for local usage, but can be easily adapted for remote execution with minor modifications.

Scripts Included
- service_install.ps1
-- Installs a service named myserver by interacting with the Service Control Manager (SCM) using NtObjectManager.

- service.ps1
-- A service script that opens a named pipe (mypipe) and listens for incoming commands.

- client.ps1
-- Used to send a command to service.ps1.

## Instructions
Install and Import NtObjectManager
Run the following commands in PowerShell:
```
Install-Module "NtObjectManager"
Import-Module "NtObjectManager"
```
Prepare the Service Folder
Create a folder and copy service.ps1 into it:
```
mkdir "$env:SystemDrive\temp"
```
Download Necessary Symbols
Run the following commands to download the required symbols:
```
$sym_path = "$env:SystemDrive\symbols"
$services_path = "$env:SystemRoot\system32\services.exe"
Get-Win32ModuleSymbolFile -Path $services_path -OutPath $sym_path
```
Run `service_install.ps1` as Administrator.

Send Commands via Client
Use client.ps1 to run any program as SYSTEM. Example:
```
client.ps1 -command "notepad"
```

This will start Notepad in Session 0 under the SYSTEM user context.




