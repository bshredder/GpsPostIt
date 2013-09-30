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

public partial class TestGPIService1 : System.Web.UI.Page
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
        try
        {
            LoginResponse loginResponse = gpiservice_s.Login(inCreds);
            Credentials outCreds = loginResponse.ResponseObj;
            this.validationTokenLabel.Text = "Validation token = " + outCreds.UnsecuredServicesValidationToken + Environment.NewLine + outCreds.SecuredServicesValidationToken;

            this.userIdTextBox2.Text = outCreds.UserId;
            this.userIdTextBox3.Text = outCreds.UserId;
            this.validationTokenTextBox2.Text = outCreds.SecuredServicesValidationToken;
            this.validationTokenTextBox3.Text = outCreds.SecuredServicesValidationToken;
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

    protected void authorPinButton_Click(object sender, EventArgs e)
    {
        double latitude = 0;
        double longitude = 0;
        try
        {
            latitude = Convert.ToDouble(this.latitudeTextBox.Text.Trim());
            longitude = Convert.ToDouble(this.longitudeTextBox.Text.Trim());
        }
        catch (Exception ex)
        {
            ex.HelpLink = "";
            return;
        }
        string userId = this.userIdTextBox2.Text.Trim();
        string validationToken = this.validationTokenTextBox2.Text.Trim();
        string title = this.titleTextBox.Text.Trim();
        string message = this.messageTextBox.Text.Trim();
        if (userId.Equals(string.Empty) || validationToken.Equals(string.Empty) || title.Equals(string.Empty)
            || message.Equals(string.Empty))
        {
            return;
        }

        // handle attachment
        byte[] inArray = null;
        string s = string.Empty;
        if (!this.FileUpload1.HasFile)
        {
            // no attachment, do nothing
        }
        else
        {
            FileStream f = new FileStream(this.FileUpload1.PostedFile.FileName, FileMode.Open);
            BinaryReader b = new BinaryReader(f);
            inArray = b.ReadBytes((int)f.Length);
            s = Convert.ToBase64String(inArray);
            b.Close();
            f.Close();
        }

        string tags = this.userIdTextBox.Text.Trim();
        if (!this.tagsTextBox.Text.Trim().Equals(String.Empty))
        {
            tags += " " + this.tagsTextBox.Text.Trim().ToLower();
        }
        string attachmentName = "snooker.jpg";
        string attachmentType = "image/jpeg";
        string createTime = DateTime.Now.ToUniversalTime().ToString();

        // all parameters ok
        Credentials credentials = new Credentials();
        credentials.UserId = userId;
        credentials.SecuredServicesValidationToken = validationToken;
        PinDetails inPin = new PinDetails();
        inPin.Title = title;
        inPin.Message = message;
        inPin.Latitude = latitude;
        inPin.Longitude = longitude;
        inPin.Attachment = s;
        inPin.AttachmentName = attachmentName;
        inPin.AttachmentType = attachmentType;
        inPin.TagList = tags;
        inPin.CreateTime = createTime;
        string transactionId = "Arbitrary TransactionId String";

        //inPin = null; // testcase
        //inPin.Title = null; // testcase
        //inPin.Title = string.Empty; // testcase
        //inPin.Message = null; // testcase
        //inPin.Message = string.Empty; // testcase
        //transactionId = null; // testcase
        //transactionId = string.Empty; // testcase
        try
        {
            AuthorPinExResponse authorPinExResponse = this.gpiservice_s.AuthorPinEx(credentials, inPin, transactionId);
            PinDetails pin = authorPinExResponse.ResponseObj;
            string outTransactionId = authorPinExResponse.TransactionId;
            if (pin != null)
            {
                this.pinIdLabel.Text = pin.PinId;
                this.pinDetailsTextBox.Text = pin.PinId + ":" + pin.Title + ":" + pin.Message + ":" + pin.Latitude + ":" + pin.Longitude + ":" + pin.TagList + ":" + pin.AttachmentId + ":" + pin.AttachmentName + ":" + pin.AttachmentType + ":" + pin.Author + ":"
                    + pin.AverageRating + ":" + pin.TotalEvaluations + ":" 
                    + pin.CreateTime + ":" + pin.ModifyTime + ":" + pin.CreateTimeInDb + ":" + pin.ModifyTimeInDb + ":" + outTransactionId;
            }
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

            this.pinIdLabel.Text = errorNumber + "\n" + errorMessage + "\n" + errorSource;
        }
    }

    protected void logoutButton_Click(object sender, EventArgs e)
    {
        this.logoutLabel.Text = "";

        string userId = this.userIdTextBox3.Text.Trim();
        string validationToken = this.validationTokenTextBox3.Text.Trim();
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
