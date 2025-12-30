# Windows 11 Application Setup Script

$confirm = Read-Host "Do you want to proceed? (Y/N)"
if ($confirm -ne "Y" -and $confirm -ne "y") {
    exit
}

# -------------------------------
# List of windows store applications to install
# -------------------------------

$apps = @(
    @{Name="Brave Browser"; Id="XP8C9QZMS2PC1T"},
    @{Name="SoundCloud"; Id="9NVJBT29B36L"},
    @{Name="ChatGPT"; Id="9NT1R1C2HH7J"},
    @{Name="MS Loop"; Id="9P1HQ5TQZMGD"},
    @{Name="draw.io"; Id="9MVVSZK43QQW"},
    @{Name="PDF24 Tools"; Id="9NFTNPPZ33TQ"},
    @{Name="ShareX"; Id="9NBLGGH4Z1SP"},
    @{Name="Visual Studio Code"; Id="XP9KHM4BK9FZ7Q"},
    @{Name="Okular"; Id="9N41MSQ1WNM8"},
    @{Name="PowerToys"; Id="XP89DCGQ3K6VLD"}
    # @{Name="Git"; Id="Git.Git"}
)

# Install each application
foreach ($app in $apps) {
    Write-Host "Installing $($app.Name) with id $($app.Id)..." -ForegroundColor Green
    winget install --id $($app.Id) --source msstore --accept-package-agreements --accept-source-agreements
    Start-Sleep -Seconds 1
}

# -------------------------------
# List of external applications to install via winget
# -------------------------------

$externalApps = @(
    @{Name="Bruno"; Id="bruno.bruno"}
)

# Install each external application
foreach ($app in $externalApps) {
    Write-Host "Installing $($app.Name) with id $($app.Id)..." -ForegroundColor Green
    winget install --id $($app.Id) --accept-package-agreements --accept-source-agreements
    Start-Sleep -Seconds 1
}

# -------------------------------
# Install external applications via direct download
# -------------------------------

$downloadApps = @(
    # Install docker via direct download as winget does not aut update
    @{Name="Docker"; Url="https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"; Arguments="install" }
)

# Install each downloaded application
foreach ($app in $downloadApps) {
    $installerPath = "$env:TEMP\$($app.Name)_Installer.exe"
    Write-Host "Downloading and installing $($app.Name) from $($app.Url)..." -ForegroundColor Green
    Start-BitsTransfer -Source $app.Url -Destination $installerPath -Description "Downloading $($app.Name)"
    
    Write-Host "Running installer for $($app.Name)..." -ForegroundColor Green
    $arguments = if ($app.Arguments) { $app.Arguments } else { "/quiet" }
    Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait
    
    Remove-Item $installerPath
    Start-Sleep -Seconds 1
}

# -------------------------------
# All apps with more complex install
# -------------------------------

# Download Latest LibreOffice Portable Multilingual-Standard
# -------------------------------

# Base URL
$baseUrl = "https://portableapps.com"
$paUrl = "$baseUrl/apps/office/libreoffice_portable"

# Downloads folder
$downloadsFolder = Join-Path $env:USERPROFILE "Downloads"

# Fetch page HTML
try {
    $page = Invoke-WebRequest -Uri $paUrl -UseBasicParsing
} catch {
    Write-Error "Failed to fetch page: $_"
    exit 1
}

# Find first link ending with .paf.exe and containing MultilingualStandard
$linkObj = ($page.Links |
    Where-Object { $_.href -match "\.paf\.exe$" -and $_.href -match "MultilingualStandard" } |
    Select-Object -First 1)

if (-not $linkObj) {
    Write-Error "Could not find a Multilingual-Standard .paf.exe download link"
    exit 1
}

$downloadLink = $linkObj.href

# Convert relative URL to full URL
if ($downloadLink -like "/redir2/*") {
    $downloadLink = $baseUrl + $downloadLink
}

# Extract filename from 'f=' parameter
if ($downloadLink -match "f=([^&]+)") {
    $filename = $matches[1]
} else {
    $filename = "LibreOfficePortable_MultilingualStandard.paf.exe"
}

$installerPath = "$env:TEMP\$filename"
Write-Host "Downloading and installing LibreOffice Portable..." -ForegroundColor Green
Start-BitsTransfer -Source $downloadLink -Destination $installerPath -Description "Downloading LibreOffice Portable"

Write-Host "Running installer for LibreOffice Portable..." -ForegroundColor Green
Start-Process -FilePath $installerPath -Wait

Remove-Item $installerPath
Start-Sleep -Seconds 1

# -------------------------------
# Windows settings
# -------------------------------

# Enable Clipboard history
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Clipboard" -Name "EnableClipboardHistory" -Value 1

# Explorer:
# Show hidden files
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1
# Show file extensions
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0
# Restart
Stop-Process -Name explorer -Force

# Taskbar:
# Hide search box
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0
# Disable Task View
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0
# Enable multi-display taskbar
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarEnabled" -Value 1
# Restart
Stop-Process -Name explorer -Force
