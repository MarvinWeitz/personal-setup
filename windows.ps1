# Windows 11 Application Setup Script

$confirm = Read-Host "Do you want to proceed? (Y/N)"
if ($confirm -ne "Y" -and $confirm -ne "y") {
    exit
}

# List of windows store applications to install
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

# List of external applications to install via winget
$externalApps = @(
    @{Name="Bruno"; Id="bruno.bruno"}
)

# Install each external application
foreach ($app in $externalApps) {
    Write-Host "Installing $($app.Name) with id $($app.Id)..." -ForegroundColor Green
    winget install --id $($app.Id) --accept-package-agreements --accept-source-agreements
    Start-Sleep -Seconds 1
}

# Install external applications via direct download
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
