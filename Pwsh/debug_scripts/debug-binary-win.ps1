#Requires -PSEdition Desktop
#Requires -Version 5.1
using assembly '..\GreeterCmdlet\bin\Debug\netstandard2.0\GreetingClientLib.dll'
Set-PSDebug -Trace 1

$request = New-Object -TypeName GreetingClientLib.DTOs.GreetingRequest
$request.GreeterName = "Windows PowerShell v$($PSVersionTable.PSVersion)"
$response = Send-GreeterGrpcApi -Server "localhost:7121" -Request $request

$response.Message
Set-PSDebug -Trace 0