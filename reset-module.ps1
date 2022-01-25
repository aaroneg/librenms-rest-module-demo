Remove-Module -Name librenms-rest-module -ErrorAction SilentlyContinue -Force
Import-Module -Name librenms-rest-module -Force
. $PSScriptRoot\init-librenms-module.ps1
