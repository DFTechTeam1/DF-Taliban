param ([string]$taskId)

. "$PSScriptRoot\utils.ps1"
. "$PSScriptRoot\validator.ps1"
. "$PSScriptRoot\executor.ps1"

createLog
init
validateTask -taskId $taskId