﻿using System.Management.Automation;
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
    [Parameter(Mandatory = true)] public GreetingRequest Request { get; set; } = null!;

    // ReSharper disable once MemberCanBePrivate.Global
    [Parameter(Mandatory = false)] public IGreetingGrpcClient ApiClient { get; set; } = new GreetingClient();

    protected override void BeginProcessing()
    {
        if (ApiClient is GreetingClient greetingClient)
        {
            greetingClient.ServerUrl = $"https://{Server}";
        }
    }

    protected override void ProcessRecord()
    {
        try
        {
            var reply = ApiClient.GetGreeting(Request);
            WriteObject(reply);
        }
        catch (Exception ex)
        {
            WriteError(new ErrorRecord(ex, "GreeterClientCmdlet", ErrorCategory.NotSpecified, null));
        }
    }

    // ReSharper disable once UnusedMember.Global
    /// <summary>
    /// This method is used for testing purposes only.
    /// </summary>
    internal void ProcessInternalForTest()
    {
        BeginProcessing();
        ProcessRecord();
        EndProcessing();
    }
}