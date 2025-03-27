param ([string]$path_directory)

. "$PSScriptRoot\utils.ps1"
. "$PSScriptRoot\validator.ps1"
. "$PSScriptRoot\executor.ps1"


createLog
init
validate_path -path $path_directory
delete_data -path $path_directory
