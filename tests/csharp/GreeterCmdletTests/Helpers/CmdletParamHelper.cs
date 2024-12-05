namespace GreeterCmdletTests.Helpers;

public static class CmdletParamHelper
{
    public static bool CmdletParameterHasAttribute(this Type cmdletType, string cmdletProperty, Type attribute)
    {
        var property = cmdletType.GetProperty(cmdletProperty);
        return property != null && Attribute.IsDefined(property, attribute);
    } 
}