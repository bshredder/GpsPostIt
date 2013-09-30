using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml;


/// <summary>
/// Generates a SOAP exception by filling in fault details.
/// </summary>
public class SoapExceptionGenerator
{
    public enum FaultCode
    {
        Client = 0,
        Server = 1
    };

    private SoapExceptionGenerator()
    {
        // Cannot instantiate this class
    }

    /// <summary>
    /// Creates a SoapException by filling in the appropriate fault details, such as 
    /// namespace, error message, etc.
    /// </summary>
    /// <param name="uri"></param>
    /// <param name="webServiceNamespace"></param>
    /// <param name="errorMessage"></param>
    /// <param name="errorNumber"></param>
    /// <param name="errorSource"></param>
    /// <param name="code"></param>
    /// <returns></returns>
    public static SoapException RaiseException(string uri, string webServiceNamespace, string errorMessage, string errorNumber, string errorSource, FaultCode code)
    {
        XmlQualifiedName faultCodeLocation = null;

        //Identify the location of the FaultCode
        switch (code)
        {
            case FaultCode.Client:
                faultCodeLocation = SoapException.ClientFaultCode;
                break;

            case FaultCode.Server:
                faultCodeLocation = SoapException.ServerFaultCode;
                break;
        }

        XmlDocument xmlDoc = new XmlDocument();
        XmlNode rootNode = xmlDoc.CreateNode(XmlNodeType.Element, SoapException.DetailElementName.Name, SoapException.DetailElementName.Namespace);
        XmlNode errorNode = xmlDoc.CreateNode(XmlNodeType.Element, "Error", webServiceNamespace);
        XmlNode errorNumberNode = xmlDoc.CreateNode(XmlNodeType.Element, "ErrorNumber", webServiceNamespace);
        errorNumberNode.InnerText = errorNumber;
        XmlNode errorMessageNode = xmlDoc.CreateNode(XmlNodeType.Element, "ErrorMessage", webServiceNamespace);
        errorMessageNode.InnerText = errorMessage;
        XmlNode errorSourceNode = xmlDoc.CreateNode(XmlNodeType.Element, "ErrorSource", webServiceNamespace);
        errorSourceNode.InnerText = errorSource;

        errorNode.AppendChild(errorNumberNode);
        errorNode.AppendChild(errorMessageNode);
        errorNode.AppendChild(errorSourceNode);
        rootNode.AppendChild(errorNode);

        SoapException soapEx = new SoapException(errorMessage, faultCodeLocation, uri, rootNode);
        return soapEx;
    }

    /// <summary>
    /// Builds an error string from a SqlException.
    /// </summary>
    /// <param name="ex"></param>
    /// <returns></returns>
    public static string BuildSqlErrorString(SqlException ex)
    {
        return "Server = " + ex.Server + "\n"
            + "Source = " + ex.Source + "\n"
            + "Procedure = " + ex.Procedure + "\n"  
            + "Line number = " + ex.LineNumber + "\n"
            + "State = " + ex.State + "\n"
            + "Number = " + ex.Number + "\n"
            + "Message = " + ex.Message; 
    }
}
