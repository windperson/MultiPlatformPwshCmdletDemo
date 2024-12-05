#region Script Requirement settings
#Requires -Version 7
#Requires -Module @{ ModuleName='Pester'; ModuleVersion="5.6.1"}
#endregion

BeforeAll {

    $project_path = $(Resolve-Path -Path "$PSScriptRoot\..\..\Pwsh\GreeterCmdlet").Path

    $output_path = "$project_path\bin\Debug\net8.0"

    if (-not( Test-Path -Path $output_path)) {
        Set-Location $project_path
        dotnet build -c Debug
    }
}

Context "Verify Module API declaration" -Tag "FunctionDeclaration" {
    BeforeDiscovery {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
        $ApiDefinition = @(
            @{
                Name        = 'Invoke-GrpcGreeting'
                CommandType = [System.Management.Automation.CommandTypes]::Function;
                Inputs      = @{
                    SenderName = [string]
                }
                Outputs     = @([string])
            },
            @{
                Name        = 'Invoke-GrpcHelloWorld'
                CommandType = [System.Management.Automation.CommandTypes]::Function;
                Inputs      = @{
                }
                Outputs     = @([string])
            }

        )
    }
    BeforeAll {
        . "$PSScriptRoot\VerifyPsDefApi.ps1"
    }

    It "Should have API `'<Name>`' defined in ApiDefinition" -ForEach $ApiDefinition {
        Import-Module -Force "$output_path/GreeterCmdlet.psd1" -ArgumentList 'localhost:7121'
        VerifyApiDefinition -Name $Name -CommandType $CommandType
    }
}

Describe "Verify Module function implementation" -Tag "FunctionImplementation" {
    BeforeAll {
        Import-Module -Force "$output_path/GreeterCmdlet.psd1" -ArgumentList 'localhost:7121'
    }

    Context "Invoke-HellloWorld" {
        It "Should return response message 'Hello World'" {
            # Arrange
            InModuleScope -ModuleName GreeterCmdlet {
                function Send-GreeterGrpcApi() {
                    <#
                    .SYNOPSIS
                        This is a dummy gRPC invocation function
                    #>
                    param()
                    # do nothing
                }
                Mock -CommandName Send-GreeterGrpcApi -Verifiable -MockWith {
                    $response = New-MockObject -Type GreetingClientLib.DTOs.GreetingResponse
                    $response.Message = "Hello World"
                    return $response
                }
            }

            # Act
            $result = Invoke-GrpcHelloWorld

            # Assert
            $result | Should -Be "Hello World"
            Should -Invoke -ModuleName GreeterCmdlet -CommandName Send-GreeterGrpcApi -Times 1
        }
    }

    Context "Invoke-GrpcGreeting" {
        It "Should return response message 'Hello Pester' when given SenderName is 'Pester'" {
            # Arrange
            InModuleScope -ModuleName GreeterCmdlet {
                function Send-GreeterGrpcApi() {
                    <#
                    .SYNOPSIS
                        This is a dummy gRPC invocation function
                    #>
                    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
                        'PSReviewUnusedParameter', '')]
                    param(
                        [Parameter(Mandatory = $true, Position = 0)]
                        [string] $Server,
                        [Parameter(Mandatory = $true)]
                        [GreetingClientLib.DTOs.GreetingRequest] $Request
                    )
                    # do nothing
                }
                Mock -CommandName Send-GreeterGrpcApi -Verifiable -MockWith {
                    $requestSender = $($PesterBoundParameters['Request']).GreeterName
                    $response = New-MockObject -Type GreetingClientLib.DTOs.GreetingResponse
                    $response.Message = "Hello $requestSender"
                    return $response
                }
            }
            # Act
            $result = Invoke-GrpcGreeting -SenderName "Pester"

            # Assert
            $result | Should -Be "Hello Pester"
            Should -Invoke -ModuleName GreeterCmdlet -CommandName Send-GreeterGrpcApi -Times 1 `
                -ParameterFilter { $request.GreeterName -eq "Pester" }
        }
    }
}