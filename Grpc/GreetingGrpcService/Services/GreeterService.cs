using Grpc.Core;
using GreetingGrpcService;

namespace GreetingGrpcService.Services;

public class GreeterService : Greeter.GreeterBase
{
    private readonly ILogger<GreeterService> _logger;

    public GreeterService(ILogger<GreeterService> logger)
    {
        _logger = logger;
    }

    public override Task<HelloReply> SayHello(HelloRequest request, ServerCallContext context)
    {
        var postFix = string.IsNullOrEmpty(request.Name) ? "World" : request.Name;
        _logger.LogInformation("Returning Hello message to \"{postFix}\"", postFix);
        return Task.FromResult(new HelloReply
        {
            Message = "Hello " + postFix
        });
    }
}