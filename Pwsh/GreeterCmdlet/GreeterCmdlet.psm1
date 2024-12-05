[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $Server = ""
)

$script:ServerAddress = $Server

#region Import Binary Module function
function LoadCorrectModule() {
    # TODO: how to correctly load right version of binary cmdlet when publish the module?
    # $script:OnFramework = if ($PSVersionTable.PSVersion -ge '7.4') {
    #     'net8.0'
    # }
    # else {
    #     'netstandard2.0'
    # }

    if (-not (Get-Command Send-GreeterGrpcApi -ErrorAction SilentlyContinue)) {
        Import-Module "$PSScriptRoot/GreeterCmdlet.dll"
    }
}
#endregion

function Invoke-GrpcGreeting() {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)]
        [string] $SenderName
    )
    begin {
        LoadCorrectModule
    }
    process {
        $request = New-Object -TypeName GreetingClientLib.DTOs.GreetingRequest
        $request.GreeterName = $SenderName
        $response = Send-GreeterGrpcApi -Server $script:ServerAddress -Request $request

        return $response.Message
    }
}

function Invoke-GrpcHelloWorld() {
    [CmdletBinding()]
    [OutputType([string])]
    param()
    begin {
        LoadCorrectModule
    }
    process {
        $request = New-Object -TypeName GreetingClientLib.DTOs.GreetingRequest
        $response = Send-GreeterGrpcApi -Server $script:ServerAddress -Request $request

        return $response.Message
    }
}