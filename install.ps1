$filePath = "C:\ProgramData\TacticalRMM\token.txt"
$exeUrl = "https://example.com/BQS.exe"
$exePath = "C:\ProgramData\TacticalRMM\BQS.exe"
$content = "VERY_LONG_TOKEN_EXAMPLE"
function Create-Shortcut {
    param (
        [string]$shortcutPath,
        [string]$targetPath
    )
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $targetPath
    $shortcut.Save()
}
if (-Not (Test-Path -Path $filePath)) {
    New-Item -Path $filePath -ItemType File -Force
    Write-Host "File created at $filePath"
    Set-Content -Path $filePath -Value $content -NoNewline
    Write-Host "Content written to $filePath"
    Write-Host "Downloading BQS file from $exeUrl"
    Invoke-WebRequest -Uri $exeUrl -OutFile $exePath
    Write-Host "BQS file downloaded to $exePath"
    Unblock-File -Path "C:\ProgramData\TacticalRMM\BQS.exe"
    Write-Host "Unblocked BQS Smart Screen"
} else {
    Write-Host "File already exists at $filePath. Updating..."
    Set-Content -Path $filePath -Value $content -NoNewline
    Write-Host "Content written to $filePath"
    $processes = Get-Process -Name BQS -ErrorAction SilentlyContinue
    if ($processes) {
        Write-Host "Killing BQS: $processName"
        $processes | Stop-Process -Force
    }
    Write-Host "Downloading BQS from $exeUrl"
    Invoke-WebRequest -Uri $exeUrl -OutFile $exePath
    Write-Host "BQS updated to $exePath"

}
$userProfiles = Get-ChildItem "C:\Users" -Directory
foreach ($userProfile in $userProfiles) {
    $startupFolder = "$($userProfile.FullName)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
    if (Test-Path -Path $startupFolder) {
        $shortcutPath = Join-Path -Path $startupFolder -ChildPath "BQS.lnk"
        Create-Shortcut -shortcutPath $shortcutPath -targetPath $exePath
        Write-Host "Shortcut created at $shortcutPath"
    } else {
        Write-Host "Startup folder not found for user $($userProfile.Name)"
    }
}
