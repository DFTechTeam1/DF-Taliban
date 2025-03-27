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

    $message | Tee-Object -FilePath "logs/system.log" -Append
}

function createLog {
    $global:logDir = "$(Get-Location)/logs"
    $global:logFile = "$logDir/system.log"

    if (-Not (Test-Path -Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }

    if (-Not (Test-Path -Path $logFile)) {
        New-Item -ItemType File -Path $logFile -Force | Out-Null
        $message = "$(localTime) INFO: Directory $logFile created."
        $message | Tee-Object -FilePath $global:logFile -Append
    }
}


function convertDatetime {
    param([string]$date, [string]$time)

    if ($date.Length -ne 8 -or $date -notmatch "^\d{8}$") {
        $message = "$(localTime) ERROR: Date should be on YYYYMMDD format (e.g: 20250327)."
        throw $message
    }

    $message = "$(localTime) INFO: Date validated."
    $message | Tee-Object -FilePath $global:logFile -Append

    if ($time.Length -ne 4 -or $time -notmatch "^\d{4}$") {
        $message = "$(localTime) ERROR: Time should be on HHmm format (e.g: 2359)."
        throw $message
    }

    $message = "$(localTime) INFO: Time validated."
    $message | Tee-Object -FilePath $global:logFile -Append

    $datetime = "$date $time"

    try {
        $convertedDatetime = [datetime]::ParseExact($datetime, "yyyyMMdd HHmm", $null)
        return $convertedDatetime
    } catch {
        $message = "$(localTime) ERROR: Invalid datetime format."
        throw $message
    }
}

# $date = "20250810"
# $time = "1231"
# $result = convertDatetime -date $date -time $time
# echo $result
