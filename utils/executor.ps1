function delete_data {
    param ([string]$path)

    $message = "$(localTime) INFO: Deleting data: $path."
    $message | Tee-Object -FilePath $logFile -Append

    Remove-Item -Path "$path" -Recurse -Force

    $message = "$(localTime) INFO: Successfully deleted path: $path."
    $message | Tee-Object -FilePath $logFile -Append
}

function delete_task {
    param ([string]$task_id)

    $message = "$(localTime) INFO: Task: $task_id successfully deleted."
    Unregister-ScheduledTask -TaskName $task_id -Confirm:$false -ErrorAction Stop
    $message | Tee-Object -FilePath $logFile -Append
}

function create_task {
    param (
        [string]$path_directory,
        [string]$date,
        [string]$time,
        [string]$task_id
    )
}