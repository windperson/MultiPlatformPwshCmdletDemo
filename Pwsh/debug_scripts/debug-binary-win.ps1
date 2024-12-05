Set-PSDebug -Trace 1

Invoke-GrpcGreeting -SenderName "Windows PowerShell v$($PSVersionTable.PSVersion)"

Set-PSDebug -Trace 0