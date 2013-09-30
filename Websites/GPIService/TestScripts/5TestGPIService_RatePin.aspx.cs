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

public partial class TestGPIService5 : System.Web.UI.Page
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
            this.evaluatorIdTextBox.Text = outCreds.UserId;
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

    protected void ratePinButton_Click(object sender, EventArgs e)
    {
        ushort numStars = 0;
        try
        {
            numStars = Convert.ToUInt16(this.numStarsTextBox.Text.Trim());
        }
        catch (Exception ex)
        {
            ex.HelpLink = "";
            return;
        }
        string userId = this.userIdTextBox2.Text.Trim();
        string validationToken = this.validationTokenTextBox2.Text.Trim();
        string evaluatorId = this.evaluatorIdTextBox.Text.Trim();
        string ratedPinId = this.ratedPinIdTextBox.Text.Trim();

        if (userId.Equals(string.Empty) || validationToken.Equals(string.Empty) || evaluatorId.Equals(string.Empty)
            || ratedPinId.Equals(string.Empty))
        {
            return;
        }

        // all parameters ok
        Credentials credentials = new Credentials();
        credentials.UserId = userId;
        credentials.SecuredServicesValidationToken = validationToken;
        RatingToken ratingToken = new RatingToken();
        ratingToken.EvaluatorId = evaluatorId;
        ratingToken.RatedPinId = ratedPinId;
        ratingToken.NumStars = numStars;

        string transactionId = "Arbitrary TransactionId String";
        try
        {
            RatePinResponse ratePinResponse = this.gpiservice_s.RatePin(credentials, ratingToken, transactionId);
            PinDetails pin = ratePinResponse.ResponseObj;
            string outTransactionId = ratePinResponse.TransactionId;
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
