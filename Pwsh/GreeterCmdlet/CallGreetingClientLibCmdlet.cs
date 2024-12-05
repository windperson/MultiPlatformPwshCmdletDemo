using System.Management.Automation;
using GreetingClientLib;
using GreetingClientLib.DTOs;

namespace GreeterCmdlet;

// ReSharper disable once UnusedType.Global
[Cmdlet(VerbsCommunications.Send, "GreeterGrpcApi")]
[OutputType(typeof(GreetingResponse))]
public class CallGreetingClientLibCmdlet : PSCmdlet
{
    // ReSharper disable once MemberCanBePrivate.Global
    [Parameter(Mandatory = true, Position = 0)]
    public string Server { get; set; } = string.Empty;

    // ReSharper disable once MemberCanBePrivate.Global
    [Parameter(Mandatory = true)] 
    public GreetingRequest Request { get; set; } = null!; 
    
    protected override void ProcessRecord()
    {
        try
        {
            var client = new GreetingClient(){ ServerUrl = $"https://{Server}" };
            var reply = client.GetGreeting(Request);
            WriteObject(reply);
        }
        catch (Exception ex)
        {
            WriteError(new ErrorRecord(ex, "GreeterClientCmdlet", ErrorCategory.NotSpecified, null));
        }
    }
}