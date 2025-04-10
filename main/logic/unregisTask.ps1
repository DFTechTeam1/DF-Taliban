param ([string]$taskId)

. "$PSScriptRoot\..\..\utils\executor.ps1"
. "$PSScriptRoot\..\..\utils\general.ps1"
. "$PSScriptRoot\..\..\utils\validator.ps1"

createLog
init


function restartScriptAsAdmin {
    param ([string]$taskId)

    $message = "$(localTime) INFO: Restarting script with elevated privileges."
    $message | Tee-Object -FilePath "$(Get-Location)\logs\system.log" -Append

    $arguments = "-ExecutionPolicy Bypass -NoProfile -File `"$PSCommandPath`" -taskId `"$taskId`""
    Start-Process powershell.exe -ArgumentList $arguments -Verb RunAs -Wait
    exit
}

if (-not (checkAdminPrivileges)) {
    restartScriptAsAdmin -taskId $taskId
}

validateTask -taskId $taskId


function unregisTask {
    param ([string]$taskId)

    $message = "$(localTime) INFO: Deleting task: $taskId."
    $message | Tee-Object -FilePath "$(Get-Location)\logs\system.log" -Append

    Unregister-ScheduledTask -TaskName $taskId -Confirm:$false -ErrorAction Stop

    $message = "$(localTime) INFO: Task: $taskId successfully deleted."
    $message | Tee-Object -FilePath "$(Get-Location)\logs\system.log" -Append
}
unregisTask -taskId $taskId