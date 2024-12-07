namespace GreetingClientLib.DTOs;

#if NETSTANDARD2_0
public class GreetingResponse
{
    public string Message { get; set; } = string.Empty;
}
#else
public record GreetingResponse(string Message);
#endif