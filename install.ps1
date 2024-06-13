
### `install.ps1`

```powershell
# Import module for color support
Import-Module -Name Microsoft.PowerShell.Utility

# Define colors
$headerColor = "Yellow"
$sectionColor = "Cyan"
$textColor = "White"

# ==========================
# Header Section
# ==========================
Write-Host @"
# ======================================
#                                                /                       
#           /          _/_o                  /) /          o       _/_   
#   (   _  /  __,  (   / ,  __,  _ _   __,  // /(   _, _  ,   ,_   /  (  
#  /_)_(/_/_)(_/(_/_)_(__(_(_/(_/ / /_(_/(_//_//_)_(__/ (_(__/|_)_(__/_)_
#                                         /)                 /|          
#                                        (/                 (/                                                                          |_|                                                                                  |_|             
# ======================================
#  Repository: github.com/sebastianaf/scripts
# ======================================
"@ -ForegroundColor $headerColor

# ==========================
# Section: Setup Variables
# ==========================
$scriptsPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("UserProfile"), ".scripts")
$sourcePath = (Join-Path -Path $PSScriptRoot -ChildPath "scripts")

# ==========================
# Section: Ensure Destination Folder Exists
# ==========================
if (-not (Test-Path -Path $scriptsPath)) {
    New-Item -ItemType Directory -Path $scriptsPath | Out-Null
}

# ==========================
# Section: Copy Scripts and Generate Report
# ==========================
if (Test-Path $sourcePath) {
    try {
        $copiedItems = Copy-Item -Path "$sourcePath\*" -Destination $scriptsPath -Recurse -Force -PassThru
        Write-Host "==================================================" -ForegroundColor $sectionColor
        Write-Host "                    Copy Report                    " -ForegroundColor $sectionColor
        Write-Host "==================================================" -ForegroundColor $sectionColor
        Write-Host "Copy Report - $(Get-Date)" -ForegroundColor $textColor
        Write-Host "Source Path: $sourcePath" -ForegroundColor $textColor
        Write-Host "Destination Path: $scriptsPath" -ForegroundColor $textColor
        Write-Host "" -ForegroundColor $textColor
        Write-Host "Copied Items:" -ForegroundColor $textColor
        foreach ($item in $copiedItems) {
            Write-Host $item.FullName -ForegroundColor $textColor

            # Create .bat file to run the .ps1 script
            $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($item.Name)
            $batContent = "@echo off`nPowerShell -NoProfile -ExecutionPolicy Bypass -File `"$scriptsPath\$($item.Name)`" %*"
            $batPath = "$scriptsPath\$scriptName.bat"
            Set-Content -Path $batPath -Value $batContent
        }
        Write-Host "==================================================" -ForegroundColor $sectionColor
        Write-Host "All items from $sourcePath have been copied to $scriptsPath and .bat files have been created." -ForegroundColor $textColor

        # ==========================
        # Section: Update PATH
        # ==========================
        $currentPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
        if ($currentPath -notlike "*$scriptsPath*") {
            [System.Environment]::SetEnvironmentVariable("PATH", "$currentPath;$scriptsPath", "User")
            Write-Host "$scriptsPath has been added to the PATH." -ForegroundColor $textColor
        } else {
            Write-Host "$scriptsPath is already in the PATH." -ForegroundColor $textColor
        }

        # ==========================
        # Section: Check and Terminate Open Consoles
        # ==========================
        $openPowerShell = Get-Process -Name "powershell" -ErrorAction SilentlyContinue
        $openCmd = Get-Process -Name "cmd" -ErrorAction SilentlyContinue
        $openWindowsTerminal = Get-Process -Name "WindowsTerminal" -ErrorAction SilentlyContinue

        if ($openPowerShell -or $openCmd -or $openWindowsTerminal) {
            $confirm = Read-Host "There are open PowerShell, CMD or Windows Terminal instances. Do you want to terminate them to apply the new PATH? (Y/N)"
            if ($confirm -eq 'Y' -or $confirm -eq 'y') {
                if ($openPowerShell) {
                    Get-Process -Name "powershell" | ForEach-Object { $_.Kill() }
                    Start-Sleep -Seconds 2
                    $openPowerShell = Get-Process -Name "powershell" -ErrorAction SilentlyContinue
                    if ($openPowerShell) {
                        Write-Host "Failed to terminate all open PowerShell instances." -ForegroundColor "Red"
                    } else {
                        Write-Host "All open PowerShell instances have been terminated." -ForegroundColor "Green"
                    }
                }
                if ($openCmd) {
                    Get-Process -Name "cmd" | ForEach-Object { $_.Kill() }
                    Start-Sleep -Seconds 2
                    $openCmd = Get-Process -Name "cmd" -ErrorAction SilentlyContinue
                    if ($openCmd) {
                        Write-Host "Failed to terminate all open CMD instances." -ForegroundColor "Red"
                    } else {
                        Write-Host "All open CMD instances have been terminated." -ForegroundColor "Green"
                    }
                }
                if ($openWindowsTerminal) {
                    Get-Process -Name "WindowsTerminal" | ForEach-Object { $_.Kill() }
                    Start-Sleep -Seconds 2
                    $openWindowsTerminal = Get-Process -Name "WindowsTerminal" -ErrorAction SilentlyContinue
                    if ($openWindowsTerminal) {
                        Write-Host "Failed to terminate all open Windows Terminal instances." -ForegroundColor "Red"
                    } else {
                        Write-Host "All open Windows Terminal instances have been terminated." -ForegroundColor "Green"
                    }
                }
            } else {
                Write-Host "Console instances were not terminated. Please restart your terminal to apply the new PATH." -ForegroundColor $textColor
            }
        } else {
            Write-Host "No open PowerShell, CMD or Windows Terminal instances found." -ForegroundColor $textColor
        }
    } catch {
        Write-Error "Failed to copy items: $_"
    }
} else {
    Write-Host "The source folder $sourcePath does not exist." -ForegroundColor "Red"
}
