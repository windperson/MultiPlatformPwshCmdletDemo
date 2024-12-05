using System.Management.Automation;
using GreetingClientLib;
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
            var client = new GreetingClient(){ ServerUrl = $"https://{Server}" };
            var reply = client.GetGreeting(new HelloRequest { Name = Name });
            WriteObject(reply.Message);
        }
        catch (Exception ex)
        {
            WriteError(new ErrorRecord(ex, "GreeterClientCmdlet", ErrorCategory.NotSpecified, null));
        }
    }
}