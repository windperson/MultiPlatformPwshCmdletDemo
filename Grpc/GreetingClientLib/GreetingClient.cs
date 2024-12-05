using GreetingGrpcService;
using Grpc.Net.Client;

namespace GreetingClientLib;

public class GreetingClient
{
    public string ServerUrl { get; set; } = string.Empty;

    public HelloReply GetGreeting(HelloRequest request)
    {
#if NETSTANDARD2_0
            using var channel = GrpcChannel.ForAddress(ServerUrl, new GrpcChannelOptions
            {
                HttpHandler = new Grpc.Net.Client.Web.GrpcWebHandler(new HttpClientHandler())
            });
#elif NET8_0
        using var channel = GrpcChannel.ForAddress(ServerUrl);
#endif
        var client = new Greeter.GreeterClient(channel);
        return client.SayHello(request);
    }
}