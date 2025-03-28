function deleteData {
    param ([string]$path)

    $message = "$(localTime) INFO: Deleting data: $path."
    $message | Tee-Object -FilePath "$(Get-Location)\logs\system.log" -Append

    Remove-Item -Path "$path" -Recurse -Force

    $message = "$(localTime) INFO: Successfully deleted path: $path."
    $message | Tee-Object -FilePath "$(Get-Location)\logs\system.log" -Append
}
