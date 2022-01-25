# Read or create a netbox config object
try {
    $nmConfig=Import-Clixml $PSScriptRoot\lnconfig.xml
}
catch {
    $nmConfig=@{
        serverAddress = Read-Host -Prompt "IP address or hostname of LibreNMS server"
    }
    $nmConfig | Export-Clixml $PSScriptRoot\lnconfig.xml
}
Import-Module librenms-rest-module
Try {
    Import-Module CredentialManager -ErrorAction Stop
}
Catch {
    Install-Module -Name CredentialManager -Repository PSGallery -Scope CurrentUser
}

# Get or create the API credential
try {$nbCred=Import-Clixml lnpassword.xml -ErrorAction Stop}
catch {
    $nbCred=Get-Credential -Title 'LibreNMS Credentials' -Message "Credentials for $($serverAddress)" -UserName 'API'
    $nbCred|Export-Clixml lnpassword.xml
}

$lnConnection = New-LNMSConnection -DeviceAddress $nmConfig.serverAddress -ApiKey $nbCred.GetNetworkCredential().Password -Passthru
Write-Output "LibreNMS connection initiated:"
$lnConnection

#$result = Test-LNMSConnection
#($result|Get-Member -MemberType NoteProperty).Name
