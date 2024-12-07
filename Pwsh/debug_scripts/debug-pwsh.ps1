#Requires -PSEdition Core
#Requires -Version 7

$module_path = $(Resolve-Path $(Join-Path $PSScriptRoot "..\GreeterCmdlet\bin\Debug\net8.0")).Path

Import-Module -Force $module_path/GreeterCmdlet -ArgumentList 'localhost:7121'

Set-PSBreakpoint -Command "Invoke-Grpc*"

Invoke-GrpcHelloWorld

$result = Invoke-GrpcGreeting -SenderName "PowerShell v$($PSVersionTable.PSVersion)"
Write-Output "return:`n$result"