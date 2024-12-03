#if NETSTANDARD2_0

using System.Management.Automation;
using System.Reflection;

namespace GreeterCmdlet;

// ReSharper disable once UnusedType.Global
public class WindowsPowerShellModuleInitializer : IModuleAssemblyInitializer
{
    public void OnImport()
    {
        AppDomain.CurrentDomain.AssemblyResolve += DependencyResolution.ResoleAssembly;
    }
}

// ReSharper disable once UnusedType.Global
public class WindowsPowerShellModuleCleanup : IModuleAssemblyCleanup
{
    public void OnRemove(PSModuleInfo psModuleInfo)
    {
        AppDomain.CurrentDomain.AssemblyResolve -= DependencyResolution.ResoleAssembly;
    }
}

internal static class DependencyResolution
{
    private static readonly string ModulePath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location)!;

    public static Assembly ResoleAssembly(object? sender, ResolveEventArgs args)
    {
        var assemblyName = new AssemblyName(args.Name);
        if (assemblyName.Name == "System.Buffers")
        {
            return Assembly.LoadFrom( Path.Combine(ModulePath, "System.Buffers.dll"));
        }
        
        if (assemblyName.Name == "System.Runtime.CompilerServices.Unsafe")
        {
            return Assembly.LoadFrom( Path.Combine(ModulePath, "System.Runtime.CompilerServices.Unsafe.dll"));
        }

        return null!;
    }
}

#endif