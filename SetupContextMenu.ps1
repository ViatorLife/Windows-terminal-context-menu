Param(
    [bool]$uninstall=$false
)

# Global definitions
$contextMenuLabel = "Open Windows Terminal"
$menuRegID = "WindowsTerminal"
$contextMenuRegPath = "Registry::HKEY_CURRENT_USER\SOFTWARE\Classes\Directory\shell\$menuRegID"
$contextBGMenuRegPath = "Registry::HKEY_CURRENT_USER\SOFTWARE\Classes\Directory\Background\shell\$menuRegID"
$resourcePath = "$env:LOCALAPPDATA\WindowsTerminalContextIcons\"
$contextMenuIcoName = "terminal.ico"

# Clean up registry and resources
if((Test-Path -Path $contextMenuRegPath)) {
    Remove-Item -Recurse -Force -Path $contextMenuRegPath
    Write-Host "Clear reg $contextMenuRegPath"
}
if((Test-Path -Path $contextBGMenuRegPath)) {
    Remove-Item -Recurse -Force -Path $contextBGMenuRegPath
    Write-Host "Clear reg $contextBGMenuRegPath"
}
if((Test-Path -Path $resourcePath)) {
    Remove-Item -Recurse -Force -Path $resourcePath
    Write-Host "Clear icon content folder $resourcePath"
}

if($uninstall) {
    Exit
}

# Copy icons
[void](New-Item -Path $resourcePath -ItemType Directory)
[void](Copy-Item -Path "$PSScriptRoot\icons\*.ico" -Destination $resourcePath)
Write-Output "Copy icons => $resourcePath"

# Add first-level menu (right-click on folder)
[void](New-Item -Force -Path $contextMenuRegPath)
[void](New-Item -Force -Path "$contextMenuRegPath\command")
[void](New-ItemProperty -Path $contextMenuRegPath -Name "Icon" -PropertyType String -Value "$resourcePath$contextMenuIcoName")
[void](New-ItemProperty -Path $contextMenuRegPath -Name "MUIVerb" -PropertyType String -Value $contextMenuLabel)
[void](New-ItemProperty -Path "$contextMenuRegPath\command" -Name "(default)" -PropertyType String -Value "`"$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe`" -d `"%V`"")

# Add first-level menu (right-click on blank area)
[void](New-Item -Force -Path $contextBGMenuRegPath)
[void](New-Item -Force -Path "$contextBGMenuRegPath\command")
[void](New-ItemProperty -Path $contextBGMenuRegPath -Name "Icon" -PropertyType String -Value "$resourcePath$contextMenuIcoName")
[void](New-ItemProperty -Path $contextBGMenuRegPath -Name "MUIVerb" -PropertyType String -Value $contextMenuLabel)
[void](New-ItemProperty -Path "$contextBGMenuRegPath\command" -Name "(default)" -PropertyType String -Value "`"$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe`" -d `"%V`"")
