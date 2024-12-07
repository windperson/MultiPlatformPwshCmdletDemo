#Requires -PSEdition Core
#Requires -Version 7
using assembly '..\GreeterCmdlet\bin\Debug\net8.0\GreetingClientLib.dll'
Set-PSDebug -Trace 1

$request = New-Object -TypeName GreetingClientLib.DTOs.GreetingRequest -ArgumentList "PowerShell v$($PSVersionTable.PSVersion)"
$response = Send-GreeterGrpcApi -Server "localhost:7121" -Request $request

$response.Message

Set-PSDebug -Trace 0