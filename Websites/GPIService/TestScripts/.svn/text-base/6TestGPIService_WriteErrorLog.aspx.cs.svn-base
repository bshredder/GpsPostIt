using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Web.Services.Protocols;
using System.Xml;

public partial class TestGPIService6 : System.Web.UI.Page
{
    private GPIService_S gpiservice_s = new GPIService_S();

    protected void Page_Load(object sender, EventArgs e)
    {       
    }

    protected void generateErrorLogButton_Click(object sender, EventArgs e)
    {
        string message = this.errorMessageTextBox.Text.Trim();
        string createTime = DateTime.Now.ToUniversalTime().ToString();

        // all parameters ok
        try
        {
            this.gpiservice_s.WriteErrorLog(ServerConstants.ValidationTokens.GeneralServiceToken, message, createTime);
            //this.gpiservice_s.WriteErrorLog("xyz", message, createTime);
        }
        catch (SoapException ex)
        {
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(ex.Detail.OuterXml);
            XmlNamespaceManager nsManager = new XmlNamespaceManager(doc.NameTable);
            nsManager.AddNamespace("errorNS", "http://www.gpspostit.com/gpiws_s");
            XmlNode errorNode = doc.DocumentElement.SelectSingleNode("errorNS:Error", nsManager);
            string errorNumber = errorNode.SelectSingleNode("errorNS:ErrorNumber", nsManager).InnerText;
            string errorMessage = errorNode.SelectSingleNode("errorNS:ErrorMessage", nsManager).InnerText;
            string errorSource = errorNode.SelectSingleNode("errorNS:ErrorSource", nsManager).InnerText;
        }
    }
}
