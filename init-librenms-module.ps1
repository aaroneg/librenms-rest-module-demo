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

Try {
    Import-Module CredentialManager -ErrorAction Stop
}
Catch {
    Install-Module -Name CredentialManager -Repository PSGallery -Scope CurrentUser
}

# Get or create the API credential from the credential store
try {$nbCred=Get-StoredCredential -Name $nmConfig.serverAddress -ErrorAction Stop}
catch {
    $nbCred=Get-Credential -Title 'LibreNMS Credentials' -Message "Credentials for $($serverAddress)" -UserName 'API'
    New-StoredCredential -Target $nmConfig.serverAddress -Username 'API' -password $nbCred.GetNetworkCredential().Password
}

$lnConnection = New-LNMSConnection -DeviceAddress $nmConfig.serverAddress -ApiKey $nbCred.GetNetworkCredential().Password -Passthru
Write-Output "LibreNMS connection initiated:"
$lnConnection
