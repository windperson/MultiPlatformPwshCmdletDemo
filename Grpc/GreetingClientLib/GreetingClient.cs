using GreetingClientLib.DTOs;
using GreetingGrpcService;
using Grpc.Net.Client;
#if NETSTANDARD2_0
using Grpc.Net.Client.Web;
#endif

namespace GreetingClientLib;

public class GreetingClient : IGreetingGrpcClient
{
    public string ServerUrl { get; set; } = string.Empty;

    public GreetingResponse GetGreeting(GreetingRequest request)
    {
        using var channel = CreateGrpcChannel();
        var client = new Greeter.GreeterClient(channel);
        var result = client.SayHello(new HelloRequest { Name = string.IsNullOrEmpty(request.GreeterName) ? "" : request.GreeterName });
        return new GreetingResponse { Message = result.Message };
    }

#if NETSTANDARD2_0
    private static GrpcWebHandler GetGrpcWebHandler()
    {
        return new GrpcWebHandler(new HttpClientHandler());
    }
#endif

    private GrpcChannel CreateGrpcChannel()
    {
#if NETSTANDARD2_0
        var channel = GrpcChannel.ForAddress(ServerUrl, new GrpcChannelOptions
        {
            HttpHandler = GetGrpcWebHandler()
        });
#elif NET8_0
        var channel = GrpcChannel.ForAddress(ServerUrl);
#endif
        return channel;
    }
}