using GreetingClientLib.DTOs;

namespace GreetingClientLib;

public interface IGreetingGrpcClient
{
    GreetingResponse GetGreeting(GreetingRequest request);
}