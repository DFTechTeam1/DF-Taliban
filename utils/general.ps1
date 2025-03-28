function localTime {
    $time = Get-Date
    $formatedTime = $time.ToUniversalTime().AddHours(7).ToString("yyyy-MM-dd HH:mm:ss")
    return $formatedTime
}

function init {
    $currentPolicy = Get-ExecutionPolicy -Scope CurrentUser
    
    if ($currentPolicy -ne "RemoteSigned") {
        $message = "$(localTime) WARNING: Converting execution policy into remote-signed."
        Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
    } else {
        $message = "$(localTime) INFO: Skip converting. Execution policy already converted into remote-signed."
    }

    $message | Tee-Object -FilePath "$(Get-Location)\logs\system.log" -Append
}

function createLog {
    $global:logDir = "$(Get-Location)/logs"
    $global:logFile = "$logDir/system.log"

    if (-Not (Test-Path -Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }

    if (-Not (Test-Path -Path $global:logFile)) {
        New-Item -ItemType File -Path $global:logFile -Force | Out-Null
        $message = "$(localTime) INFO: Directory $global:logFile created."
        $message | Tee-Object -FilePath "$(Get-Location)\logs\system.log" -Append
    }
}