param(
    [string]$date,
    [string]$time,
    [string]$path,
    [string]$taskId
)

. "$PSScriptRoot\..\..\utils\executor.ps1"
. "$PSScriptRoot\..\..\utils\general.ps1"
. "$PSScriptRoot\..\..\utils\validator.ps1"

createLog
init

$validatedDatetime = validateDatetime -date $date -time $time
validatePath -path $path

function checkAdminPrivileges {
    return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

function restartScriptAsAdmin {
    param (
        [string]$date,
        [string]$time,
        [string]$path,
        [string]$taskId
    )

    $message = "$(localTime) INFO: Restarting script with elevated privileges."
    $message | Tee-Object -FilePath "$(Get-Location)\logs\system.log" -Append

    $arguments = "-ExecutionPolicy Bypass -NoProfile -File `"$PSCommandPath`" -date `"$date`" -time `"$time`" -path `"$path`" -taskId `"$taskId`""
    Start-Process powershell.exe -ArgumentList $arguments -Verb RunAs -Wait
    exit
}

function registerDeleteTask {
    param (
        [datetime]$triggerTime,
        [string]$path,
        [string]$taskId
    )

    $fileRemover = "C:\Users\newma\Project\DF-Taliban\main\taliban_logic\fileRemover.ps1"

    try {
        $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$fileRemover`" -path `"$path`""
        $trigger = New-ScheduledTaskTrigger -Once -At $triggerTime
        $principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries `
                                                 -DontStopIfGoingOnBatteries `
                                                 -StartWhenAvailable `
                                                 -DontStopOnIdleEnd `
                                                 -ExecutionTimeLimit (New-TimeSpan -Minutes 5)

        Register-ScheduledTask -TaskName $taskId `
                               -Action $action `
                               -Trigger $trigger `
                               -Principal $principal `
                               -Settings $settings `
                               -Description "File $path will be removed at $triggerTime" `
                               -Force

        $message = "$(localTime) INFO: Scheduled task $taskId created successfully to run at $triggerTime"
        $message | Tee-Object -FilePath "$(Get-Location)\logs\system.log" -Append
    }
    catch {
        $message = "$(localTime) ERROR: Task id: $taskId failed to register."
        $message | Tee-Object -FilePath "$(Get-Location)\logs\system.log" -Append
    }
}

if (-not (checkAdminPrivileges)) {
    restartScriptAsAdmin -date $date -time $time -path $path -taskId $taskId
}

registerDeleteTask -triggerTime $validatedDatetime -path $path -taskId $taskId
