function validatePath {
    param ([string]$path)

    $restrictedPath = @(
        "logs",
        "$(Get-Location)\logs",
        "$(Get-Location)\logs\system.log"
    )

    $message = "$(localTime) INFO: Validating path: $path."
    $message | Tee-Object -FilePath "$(Get-Location)\logs\system.log" -Append

    if ($restrictedPath -contains $path) {
        throw "ERROR: Access denied! Modification of $path is not allowed."
    }

    if (-Not (Test-Path -Path $path)) {
        throw "ERROR: Invalid path. Please ensure path $path has an existing file or directory."
    }

    $message = "$(localTime) INFO: Path validated."
    $message | Tee-Object -FilePath "$(Get-Location)\logs\system.log" -Append
}


function validateTask {
    param ([string]$taskId)

    $task = Get-ScheduledTask -TaskName $taskId -ErrorAction SilentlyContinue

    if (-Not $task) {
        throw "ERROR: Task $taskId not found."
    }

}

function validateDatetime {
    param([string]$date, [string]$time)

    if ($date.Length -ne 8 -or $date -notmatch "^\d{8}$") {
        throw "ERROR: Date should be in YYYYMMDD format (e.g: 20250327)."
    }

    if ($time.Length -ne 4 -or $time -notmatch "^\d{4}$") {
        throw "ERROR: Time should be in HHmm format (e.g: 2359)."
    }

    $datetime = "$date $time"
    $currentTime = Get-Date
    $convertedDatetime = [datetime]::ParseExact($datetime, "yyyyMMdd HHmm", $null)
    if ($convertedDatetime -le $currentTime) {
        throw "ERROR: Time input should be more than $currentTime"
    }

    return $convertedDatetime
    
}
