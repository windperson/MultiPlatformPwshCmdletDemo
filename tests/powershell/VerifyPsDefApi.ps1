#Requires -Version 7
function VerifyApiDefinition {
    <#
    .SYNOPSIS
    Verify if the function decleared in imported module is designed correctly.
    #>
    param(
        [string] $Name,
        [Nullable[System.Management.Automation.CommandTypes]] $CommandType = $null
    )

    Process {
        if ($null -eq $CommandType) {
            $targetExists = VerifyApiType -Name $Name
        }
        else {
            $targetExists = VerifyApiType -Name $Name -CommandType $CommandType
        }
        VerifyApiInputParameters $targetExists $Inputs
        VerifyApiOutputParameters $targetExists $Outputs
    }
}

function VerifyApiType() {
    <#
    .SYNOPSIS
    Verify if the PowerShell executable command exists in the current session and is correct type.
    #>
    param(
        [string] $Name,
        [System.Management.Automation.CommandTypes] $CommandType = [System.Management.Automation.CommandTypes]::Function
    )

    Process {
        $targetExists = Get-Command -Name $Name -CommandType $CommandType -ErrorAction SilentlyContinue
        $targetExists | Should -Not -BeNullOrEmpty
        return $targetExists
    }
}

function VerifyApiInputParameters {
    <#
    .SYNOPSIS
    Verify if the function parameters are designed correctly.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseLiteralInitializerForHashtable', '')]
    param(
        [ValidateNotNull()]
        [System.Management.Automation.CommandInfo]
        $commandInfo,
        [System.Collections.Hashtable]$designedParameters
    )
    # Note: since PowerShell's built-in Hashtable is case insensitive, we can't use it to exactly check function parameters
    $parameterTable = New-Object 'System.Collections.Hashtable'
    foreach ($key in $designedParameters.Keys) {
        $parameterTable.Add($key, $designedParameters[$key])
    }

    $cmdletBuiltInParameters =
    @('Verbose', 'Debug', 'ErrorAction', 'ErrorVariable', 'InformationAction', 'InformationVariable', 'WarningAction', 'WarningVariable', 'OutBuffer', 'OutVariable', 'PipelineVariable', 'ProgressAction',
        'WhatIf', 'Confirm')

    foreach ($parameter in $commandInfo.Parameters.Values.GetEnumerator()) {
        $parameterName = $parameter.Name
        if ( $commandInfo.CmdletBinding -and $cmdletBuiltInParameters -contains $parameterName) {
            continue
        }
        $parameterTable.ContainsKey($parameterName) | Should -Be $true -Because "Parameter '$parameterName' should be exist"
        $expectedType = $parameterTable[$parameterName]
        # We compare type by its full name string, not rely on Pester's -BeOfType assertion
        # see https://github.com/pester/Pester/issues/1315#issuecomment-756700291
        $parameterTypeName = $parameter.ParameterType.FullName
        $parameterTypeName | Should -Be $expectedType.ToString() -Because "Parameter '`$$parameterName' should be of type '$expectedType'"
    }
}

function VerifyApiOutputParameters {
    <#
    .SYNOPSIS
    Verify if the function output is designed correctly.
    #>
    param(
        [System.Management.Automation.CommandInfo]
        [ValidateNotNUll()]
        $commandInfo,
        [type[]]$designedParameters
    )

    if ($null -eq $designedParameters -or $designedParameters.Count -eq 0) {
        # don't need to verify output type
        return
    }

    [string[]]$actualOutputTypeNames = @()
    foreach ($actualType in $commandInfo.OutputType) {
        $actualOutputTypeNames += $actualType.Type.FullName
    }
    $expectedTypeCount = $designedParameters.Count

    $actualOutputTypeNames.Count | Should -Be $expectedTypeCount -Because "Output Types should have at least '$expectedTypeCount' type(s)"

    foreach ($expectedType in $designedParameters) {
        # We compare type by its full name string, not rely on Pester's -BeOfType assertion
        # see https://github.com/pester/Pester/issues/1315#issuecomment-756700291
        $expectedTypeName = $expectedType.FullName
        $expectedTypeName | Should -BeIn $actualOutputTypeNames -Because "Output should have one of object type '$expectedType'"
    }
}
#Requires -Version 7
function VerifyApiDefinition {
    <#
    .SYNOPSIS
    Verify if the function decleared in imported module is designed correctly.
    #>
    param(
        [string] $Name,
        [Nullable[System.Management.Automation.CommandTypes]] $CommandType = $null
    )

    Process {
        if ($null -eq $CommandType) {
            $targetExists = VerifyApiType -Name $Name
        }
        else {
            $targetExists = VerifyApiType -Name $Name -CommandType $CommandType
        }
        VerifyApiInputParameters $targetExists $Inputs
        VerifyApiOutputParameters $targetExists $Outputs
    }
}

function VerifyApiType() {
    <#
    .SYNOPSIS
    Verify if the PowerShell executable command exists in the current session and is correct type.
    #>
    param(
        [string] $Name,
        [System.Management.Automation.CommandTypes] $CommandType = [System.Management.Automation.CommandTypes]::Function
    )

    Process {
        $targetExists = Get-Command -Name $Name -CommandType $CommandType -ErrorAction SilentlyContinue
        $targetExists | Should -Not -BeNullOrEmpty
        return $targetExists
    }
}

function VerifyApiInputParameters {
    <#
    .SYNOPSIS
    Verify if the function parameters are designed correctly.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseLiteralInitializerForHashtable', '')]
    param(
        [ValidateNotNull()]
        [System.Management.Automation.CommandInfo]
        $commandInfo,
        [System.Collections.Hashtable]$designedParameters
    )
    # Note: since PowerShell's built-in Hashtable is case insensitive, we can't use it to exactly check function parameters
    $parameterTable = New-Object 'System.Collections.Hashtable'
    foreach ($key in $designedParameters.Keys) {
        $parameterTable.Add($key, $designedParameters[$key])
    }

    $cmdletBuiltInParameters =
    @('Verbose', 'Debug', 'ErrorAction', 'ErrorVariable', 'InformationAction', 'InformationVariable', 'WarningAction', 'WarningVariable', 'OutBuffer', 'OutVariable', 'PipelineVariable', 'ProgressAction',
        'WhatIf', 'Confirm')

    foreach ($parameter in $commandInfo.Parameters.Values.GetEnumerator()) {
        $parameterName = $parameter.Name
        if ( $commandInfo.CmdletBinding -and $cmdletBuiltInParameters -contains $parameterName) {
            continue
        }
        $parameterTable.ContainsKey($parameterName) | Should -Be $true -Because "Parameter '$parameterName' should be exist"
        $expectedType = $parameterTable[$parameterName]
        # We compare type by its full name string, not rely on Pester's -BeOfType assertion
        # see https://github.com/pester/Pester/issues/1315#issuecomment-756700291
        $parameterTypeName = $parameter.ParameterType.FullName
        $parameterTypeName | Should -Be $expectedType.ToString() -Because "Parameter '`$$parameterName' should be of type '$expectedType'"
    }
}

function VerifyApiOutputParameters {
    <#
    .SYNOPSIS
    Verify if the function output is designed correctly.
    #>
    param(
        [System.Management.Automation.CommandInfo]
        [ValidateNotNUll()]
        $commandInfo,
        [type[]]$designedParameters
    )

    if ($null -eq $designedParameters -or $designedParameters.Count -eq 0) {
        # don't need to verify output type
        return
    }

    [string[]]$actualOutputTypeNames = @()
    foreach ($actualType in $commandInfo.OutputType) {
        $actualOutputTypeNames += $actualType.Type.FullName
    }
    $expectedTypeCount = $designedParameters.Count

    $actualOutputTypeNames.Count | Should -Be $expectedTypeCount -Because "Output Types should have at least '$expectedTypeCount' type(s)"

    foreach ($expectedType in $designedParameters) {
        # We compare type by its full name string, not rely on Pester's -BeOfType assertion
        # see https://github.com/pester/Pester/issues/1315#issuecomment-756700291
        $expectedTypeName = $expectedType.FullName
        $expectedTypeName | Should -BeIn $actualOutputTypeNames -Because "Output should have one of object type '$expectedType'"
    }
}
