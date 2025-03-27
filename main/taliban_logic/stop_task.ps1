param ([string]$task_id)

. "$PSScriptRoot\utils.ps1"
. "$PSScriptRoot\validator.ps1"
. "$PSScriptRoot\executor.ps1"

createLog
init
validate_task -task_id $task_id

function run_admin {
    param ([string]$task_id)

    $adminCheck = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

    if (-not $adminCheck) {
        $message = "$(localTime) INFO: Restarting script with elevated privileges"
        $message | Tee-Object -FilePath $logFile -Append

        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File `"$PSCommandPath`" `"$task_id`"" -Verb RunAs
        exit
    }
}


run_admin -task_id $task_id
delete_task -task_id $task_id