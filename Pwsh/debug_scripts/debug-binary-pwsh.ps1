Set-PSDebug -Trace 1

Invoke-GrpcGreeting -SenderName "PowerShell v$($PSVersionTable.PSVersion)"

Set-PSDebug -Trace 0