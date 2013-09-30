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
using System.Web.Services.Protocols;
using System.Xml;


public partial class TestGPIService0 : System.Web.UI.Page
{
    private GPIService_S gpiservice_s = new GPIService_S();

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void loginButton_Click(object sender, EventArgs e)
    {
        string userId = this.userIdTextBox.Text.Trim();
        string password = this.passwordTextBox.Text.Trim();
        if (userId.Equals(string.Empty) || password.Equals(string.Empty))
        {
            return;
        }

        Credentials inCreds = new Credentials();
        inCreds.UserName = userId;
        inCreds.Password = password;
        //inCreds.UserName = string.Empty; // testcase
        //inCreds.Password = string.Empty; // testcase
        //inCreds.UserName = null; // testcase
        //inCreds.Password = null; // testcase
        try
        {
            LoginResponse loginResponse = gpiservice_s.Login(inCreds);
            Credentials outCreds = loginResponse.ResponseObj;

            this.validationTokenLabel.Text = "Validation token = " + outCreds.UnsecuredServicesValidationToken + Environment.NewLine + outCreds.SecuredServicesValidationToken;

            // Make life easier
            this.userIdTextBox2.Text = outCreds.UserId;
            this.validationToken_S_TextBox.Text = outCreds.SecuredServicesValidationToken;
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

            this.validationTokenLabel.Text = errorNumber + "\n" + errorMessage + "\n" + errorSource;
            return;
        }
    }

    protected void logoutButton_Click(object sender, EventArgs e)
    {
        this.logoutLabel.Text = String.Empty;

        string userId = this.userIdTextBox2.Text.Trim();
        string validationToken_S = this.validationToken_S_TextBox.Text.Trim();
        if (userId.Equals(string.Empty) || validationToken_S.Equals(string.Empty))
        {
            return;
        }

        try
        {
            Credentials creds = new Credentials();
            creds.UserId = userId;
            creds.SecuredServicesValidationToken = validationToken_S;

            //creds.UserId = string.Empty; // testcase
            //creds.UserId = null; // testcase
            //creds.SecuredServicesValidationToken = string.Empty; // testcase
            //creds.SecuredServicesValidationToken = null; // testcase
            LogoutResponse logoutResponse = gpiservice_s.Logout(creds);
            string result = logoutResponse.ResponseCode;
            this.logoutLabel.Text = result;
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

            this.logoutLabel.Text = errorNumber + "\n" + errorMessage + "\n" + errorSource;
            return;
        }
    }
}
