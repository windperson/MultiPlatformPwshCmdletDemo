using System.Management.Automation;
using GreeterCmdlet;
using GreeterCmdletTests.Helpers;
using GreetingClientLib;
using GreetingClientLib.DTOs;
using Moq;

namespace GreeterCmdletTests;

public class CallGreetingClientLibCmdletTests
{
    [Fact]
    public void VerifyCmdletParameterAttributes()
    {
        var binaryCmdletType = typeof(CallGreetingClientLibCmdlet);
        Assert.True(binaryCmdletType.CmdletParameterHasAttribute(nameof(CallGreetingClientLibCmdlet.Server),
            typeof(ParameterAttribute)));
        Assert.True(binaryCmdletType.CmdletParameterHasAttribute(nameof(CallGreetingClientLibCmdlet.Request),
            typeof(ParameterAttribute)));
        Assert.True(binaryCmdletType.CmdletParameterHasAttribute(nameof(CallGreetingClientLibCmdlet.ApiClient),
            typeof(ParameterAttribute)));
    }

    [Fact]
    public void ProcessRecord_ShouldWriteObject_WhenApiClientReturnsResponse()
    {
        // Arrange
        var mockApiClient = new Mock<IGreetingGrpcClient>();
        var request = new GreetingRequest("Test");
        var response = new GreetingResponse("Hello, Test!");
        mockApiClient.Setup(client => client.GetGreeting(request)).Returns(response);

        var cmdlet = new CallGreetingClientLibCmdlet
        {
            Server = "localhost",
            Request = request,
            ApiClient = mockApiClient.Object
        };

        // Act
        var pipelineEmulator = new CommandRuntimeEmulator();
        cmdlet.CommandRuntime = pipelineEmulator;
        cmdlet.ProcessInternalForTest();

        // Assert
        var results = pipelineEmulator.OutputObjects;
        Assert.Single(results);
        var actualResponse = results.First() as GreetingResponse;
        Assert.NotNull(actualResponse);
        Assert.Equal(response.Message, actualResponse.Message);
    }

    [Fact]
    public void ProcessRecord_ShouldWriteError_WhenApiClientThrowsException()
    {
        // Arrange
        var mockApiClient = new Mock<IGreetingGrpcClient>();
        var request = new GreetingRequest("Test");
        var exception = new Exception("Test exception");
        mockApiClient.Setup(client => client.GetGreeting(request)).Throws(exception);

        var cmdlet = new CallGreetingClientLibCmdlet
        {
            Server = "localhost",
            Request = request,
            ApiClient = mockApiClient.Object
        };

        // Act
        var pipelineEmulator = new CommandRuntimeEmulator();
        cmdlet.CommandRuntime = pipelineEmulator;
        var threw = Record.Exception(() => cmdlet.ProcessInternalForTest());

        // Assert
        Assert.Null(threw);
        var results = pipelineEmulator.OutputObjects;
        Assert.Empty(results);
        var errors = pipelineEmulator.ErrorRecords;
        Assert.Single(errors);
        var error = errors.First();
        Assert.Equal(exception, error.Exception);
    }
}