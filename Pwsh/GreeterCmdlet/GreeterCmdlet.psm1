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

function IsWindowsPowerShell() {
    return $PSVersionTable.PSEdition -eq "Desktop"
}

#region Cmdlet functions
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
        if ( IsWindowsPowerShell ) {
            $request = New-Object -TypeName GreetingClientLib.DTOs.GreetingRequest
            $request.GreeterName = $SenderName
        }
        else {
            $request = New-Object -TypeName GreetingClientLib.DTOs.GreetingRequest -ArgumentList $SenderName
        }
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
        if ( IsWindowsPowerShell ) {
            $request = New-Object -TypeName GreetingClientLib.DTOs.GreetingRequest
        }
        else {
            $request = New-Object -TypeName GreetingClientLib.DTOs.GreetingRequest -ArgumentList ""
        }
        $response = Send-GreeterGrpcApi -Server $script:ServerAddress -Request $request

        return $response.Message
    }
}
#endregion