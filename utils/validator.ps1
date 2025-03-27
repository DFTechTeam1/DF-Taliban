function validate_path {
    param ([string]$path)

    $restrictedPaths = @(
        "$(Get-Location)\logs",
        "$(Get-Location)\logs\system.log"
    )

    $message = "$(localTime) INFO: Validating path: $path."
    $message | Tee-Object -FilePath $logFile -Append

    if ($restrictedPaths -contains $path) {
        $message = "$(localTime) ERROR: Access denied! Modification of $path is not allowed."
        throw $message
    }

    if (-Not (Test-Path -Path $path)) {
        $message = "$(localTime) ERROR: Invalid path. Please ensure path $path has an existing file or directory."
        throw $message
    }

    $message = "$(localTime) INFO: Path: $path validated."
    $message | Tee-Object -FilePath $logFile -Append
}


function validate_task {

    param ([string]$task_id)

    $task = Get-ScheduledTask -TaskName $task_id -ErrorAction SilentlyContinue

    if (-Not $task) {
        $message = "$(localTime) ERROR: Task $task_id not found."
        throw $message
    }

}