param(
    [string]$ProcessName = "Picocrypt-NG",
    [int]$IntervalMs = 200,
    [string]$OutFile = "ram_log.csv"
)

Write-Host "Waiting for process '$ProcessName'..."
$proc = $null
while (-not $proc) {
    $proc = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $proc) { Start-Sleep -Milliseconds $IntervalMs }
}

Write-Host "Process found (PID $($proc.Id)). Logging to '$OutFile'. Press Ctrl+C to stop."
"ElapsedSeconds;WorkingSetMB;PrivateMB" | Out-File -FilePath $OutFile -Encoding utf8

$start = Get-Date
$peakWorkingSet = 0
$peakPrivate = 0

try {
    while ($true) {
        $proc.Refresh()
        if ($proc.HasExited) {
            Write-Host "Process has exited."
            break
        }
        $elapsed = [math]::Round(((Get-Date) - $start).TotalSeconds, 2)
        $workingSet = [math]::Round($proc.WorkingSet64 / 1MB, 1)
        $private = [math]::Round($proc.PrivateMemorySize64 / 1MB, 1)
        if ($workingSet -gt $peakWorkingSet) { $peakWorkingSet = $workingSet }
        if ($private -gt $peakPrivate) { $peakPrivate = $private }
        "$elapsed;$workingSet;$private" | Add-Content -Path $OutFile
        Start-Sleep -Milliseconds $IntervalMs
    }
}
finally {
    Write-Host "Peak working set: $peakWorkingSet MB"
    Write-Host "Peak private bytes: $peakPrivate MB"
    Write-Host "Log written to '$OutFile'."
}

