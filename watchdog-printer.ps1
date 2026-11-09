
$appPath = "C:\clube-watchdog\ClubeSevenPrinter.lnk"
$processName = "ClubeSevenPrinter.exe"
$logPath = "C:\clube-watchdog\watchdog.log"

function Rotate-Log {
    if (Test-Path $logPath) {
        $size = (Get-Item $logPath).Length

        if ($size -gt 1MB) {
            $oldLog = "C:\clube-watchdog\watchdog.old.log"

            if (Test-Path $oldLog) {
                Remove-Item $oldLog -Force
            }

            Rename-Item $logPath "watchdog.old.log"
        }
    }
}

while ($true) {
    Rotate-Log
    try {
        $process = Get-CimInstance Win32_Process |
            Where-Object {
                $_.Name -ieq $processName
            }

        if (-not $process) {
            Add-Content $logPath "$(Get-Date) - Impressora do Clube fechado. Reiniciando..."

            Start-Process -FilePath $appPath

            Add-Content $logPath "$(Get-Date) - Comando de inicialização Impressora executado."
        }
    }
    catch {
        Add-Content $logPath "$(Get-Date) - ERRO: $_"
    }

    Start-Sleep -Seconds 30
}

