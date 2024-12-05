#Requires -Version 7

$module_path = $(Resolve-Path $(Join-Path $PSScriptRoot "..\GreeterCmdlet\bin\Debug\net8.0")).Path

Import-Module -Force $module_path/GreeterCmdlet -ArgumentList 'localhost:7121'

Set-PSDebug -Trace 1
$result = Invoke-GrpcGreeting -SenderName "PowerShell v$($PSVersionTable.PSVersion)"
Set-PSDebug -Trace 0

Write-Output "return:`n$result"