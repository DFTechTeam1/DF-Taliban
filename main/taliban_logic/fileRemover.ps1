param ([string]$pathDirectory)

. "$PSScriptRoot\..\..\utils\executor.ps1"
. "$PSScriptRoot\..\..\utils\general.ps1"
. "$PSScriptRoot\..\..\utils\validator.ps1"

createLog
init
validatePath -path $pathDirectory
deleteData -path $pathDirectory