using System.Management.Automation;
using GreetingGrpcService;
using Grpc.Net.Client;

namespace GreeterCmdlet;

[Cmdlet(VerbsCommon.Get, "GrpcGreeter")]
public class GreeterClientCmdlet : PSCmdlet
{
    // ReSharper disable once MemberCanBePrivate.Global
    [Parameter(Mandatory = true, Position = 0)]
    public string Server { get; set; } = string.Empty;

    // ReSharper disable once MemberCanBePrivate.Global
    [Parameter(Mandatory = false)] 
    public string Name { get; set; } = string.Empty;

    protected override void ProcessRecord()
    {
        try
        {
#if NETSTANDARD2_0
            var channel = GrpcChannel.ForAddress($"https://{Server}", new GrpcChannelOptions
            {
                HttpHandler = new Grpc.Net.Client.Web.GrpcWebHandler(new HttpClientHandler())
            });
#elif NET8_0
        var channel = GrpcChannel.ForAddress($"https://{Server}");
#endif
            var client = new Greeter.GreeterClient(channel);
            var reply = client.SayHello(new HelloRequest { Name = Name });
            WriteObject(reply.Message);
        }
        catch (Exception ex)
        {
            WriteError(new ErrorRecord(ex, "GreeterClientCmdlet", ErrorCategory.NotSpecified, null));
        }
    }
}