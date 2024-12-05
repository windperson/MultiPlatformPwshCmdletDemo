[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $Server = ""
)

$script:ServerAddress = $Server

# TODO: how to correctly load right version of binary cmdlet when publish the module?
$script:OnFramework = if ($PSVersionTable.PSVersion -ge '7.4') {
    'net8.0'
}
else {
    'netstandard2.0'
}

Import-Module "$PSScriptRoot/GreeterCmdlet.dll"

function Invoke-GrpcGreeting() {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)]
        [string] $SenderName
    )
    $request = New-Object -TypeName GreetingClientLib.DTOs.GreetingRequest
    $request.GreeterName = $SenderName
    $response = Send-GreeterGrpcApi -Server $script:ServerAddress -Request $request

    return $response.Message
}

function Invoke-GrpcHelloWrold() {
    [CmdletBinding()]
    [OutputType([string])]
    param()
    $request = New-Object -TypeName GreetingClientLib.DTOs.GreetingRequest
    $response = Send-GreeterGrpcApi -Server $script:ServerAddress -Request $request

    return $response.Message
}