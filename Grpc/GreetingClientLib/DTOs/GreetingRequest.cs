namespace GreetingClientLib.DTOs;

#if  NETSTANDARD2_0
// ReSharper disable once ClassNeverInstantiated.Global
public class GreetingRequest
{
    public string? GreeterName { get; set; }
}
#else
public record GreetingRequest(string? GreeterName);
#endif