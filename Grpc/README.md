Start the gRPC service by running the following .NET SDK [dotnet run](https://learn.microsoft.com/dotnet/core/tools/dotnet-run) command in current folder:

```shell
dotnet run --project ./GreetingGrpcService --launch-profile https
````

To test this service, you can use the [grpcurl](https://github.com/fullstorydev/grpcurl ) command line tool with following command:

```shell
grpcurl -proto ./Protos/greet.proto -d '{"name": "test with grpcurl"}' localhost:7121 greet.Greeter/SayHello
```