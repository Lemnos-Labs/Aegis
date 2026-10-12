$path = "$PSScriptRoot\test_5gb.bin"
$size = 5GB
$bufferSize = 8MB # 8MB Puffer ist ideal für hohen Datendurchsatz
$buffer = [byte[]]::new($bufferSize)
$rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()

Write-Host "Erstelle 5 GB Testdatei mit kryptografischem Rauschen..." -ForegroundColor Cyan
$sw = [System.Diagnostics.Stopwatch]::StartNew()

$stream = [System.IO.File]::Create($path)
try {
    $written = 0
    while ($written -lt $size) {
        $rng.GetBytes($buffer)
        $stream.Write($buffer, 0, $buffer.Length)
        $written += $bufferSize
    }
}
finally {
    $stream.Dispose()
    $rng.Dispose()
}

$sw.Stop()
Write-Host ("Fertig in {0:N2} Sekunden!" -f $sw.Elapsed.TotalSeconds) -ForegroundColor Green

# SHA256-Hash zur Verifikation vor/nach Verschlüsselung
Write-Host "Berechne SHA-256 Prüfsumme als Referenz..." -ForegroundColor Yellow
$hash = Get-FileHash -Path $path -Algorithm SHA256
Write-Host "Referenz-Hash: $($hash.Hash)" -ForegroundColor White