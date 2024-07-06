$filePath = "C:\ProgramData\TacticalRMM\token.txt"
if (Test-Path -Path $filePath) {
    $processName = "BQS"
    $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
    if ($processes) {
        Write-Host "Killing running process: $processName"
        $processes | Stop-Process -Force
    }
    Write-Host "Launching BQS"
    Start-Process -FilePath C:\ProgramData\TacticalRMM\BQS.exe
}else{
    Write-Host "Please install BQS first"
}
