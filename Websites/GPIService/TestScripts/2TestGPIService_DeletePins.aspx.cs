using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.Services.Protocols;
using System.Xml;

public partial class TestGPIService2 : System.Web.UI.Page
{
    private GPIService_S gpiservice_s = new GPIService_S();

    protected void Page_Load(object sender, EventArgs e)
    {
    }
 
    protected void deletePinsButton_Click(object sender, EventArgs e)
    {
        string userId = this.userIdTextBox3.Text.Trim();
        string pinIdsStr = this.pinIdsTextBox.Text.Trim();
        string[] pinIdsArr = pinIdsStr.Split('\n');
        List<string> pinIds = new List<string>();
        foreach (string pin in pinIdsArr)
        {
            pinIds.Add(pin);
        }
        string validationToken = this.validationTokenTextBox3.Text.Trim();
        if (userId.Equals(string.Empty) || validationToken.Equals(string.Empty) || pinIdsStr.Equals(string.Empty))
        {
            return;
        }
        string transactionId = "Arbitrary transaction id";

        // all parameters ok
        Credentials credentials = new Credentials();
        credentials.UserId = userId;
        credentials.SecuredServicesValidationToken = validationToken;
        string result = string.Empty;
        string outTransactionId = string.Empty;
        //credentials.UserId = string.Empty; // testcase
        //credentials.SecuredServicesValidationToken = string.Empty; // testcase
        //transactionId = string.Empty; // testcase
        try
        {
            DeletePinsResponse deletePinsResponse = this.gpiservice_s.DeletePins(credentials, pinIds, transactionId);
            result = deletePinsResponse.ResponseCode;
            outTransactionId = deletePinsResponse.TransactionId;
            this.pinDeletedResultTextBox.Text = result + "|" + outTransactionId;
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

            this.pinDeletedResultTextBox.Text = errorNumber + "\n" + errorMessage + "\n" + errorSource;
        }
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
        try
        {
            LoginResponse loginReponse = gpiservice_s.Login(inCreds);
            Credentials outCreds = loginReponse.ResponseObj;
            this.validationTokenLabel.Text = "Validation token = " + outCreds.UnsecuredServicesValidationToken + Environment.NewLine + outCreds.SecuredServicesValidationToken;

            this.userIdTextBox3.Text = outCreds.UserId;
            this.userIdTextBox4.Text = outCreds.UserId;
            this.validationTokenTextBox3.Text = outCreds.SecuredServicesValidationToken;
            this.validationTokenTextBox4.Text = outCreds.SecuredServicesValidationToken;
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
        }
    }

    protected void logoutButton_Click(object sender, EventArgs e)
    {
        this.logoutLabel.Text = "";

        string userId = this.userIdTextBox4.Text.Trim();
        string validationToken = this.validationTokenTextBox4.Text.Trim();
        if (userId.Equals(string.Empty) || validationToken.Equals(string.Empty))
        {
            return;
        }

        Credentials credentials = new Credentials();
        credentials.UserId = userId;
        credentials.SecuredServicesValidationToken = validationToken;
        try
        {
            LogoutResponse logoutResponse = gpiservice_s.Logout(credentials);
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
        }
    }
}
