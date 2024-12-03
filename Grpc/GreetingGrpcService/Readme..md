Start the service by running the following command in current folder:

```shell
dotnet run --launch-profile https
````

To test this service, you can use the [grpcurl](https://github.com/fullstorydev/grpcurl ) command line tool with following command:

```shell
grpcurl -proto ../Protos/greet.proto -d '{"name": "test with grpcurl"}' localhost:7121 greet.Greeter/SayHello
```