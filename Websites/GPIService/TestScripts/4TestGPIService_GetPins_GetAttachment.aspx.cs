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
using System.Web.Services.Protocols;
using System.Text.RegularExpressions;
using System.IO;
using System.Xml;


public partial class TestGPIService4 : System.Web.UI.Page
{
    private GPIService_S gpiservice_s = new GPIService_S();
    private GPIService gpiservice = new GPIService();

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
            this.userIdTextBox4.Text = outCreds.UserId;
            this.validationTokenTextBox2.Text = outCreds.UnsecuredServicesValidationToken;
            this.validationTokenTextBox3.Text = outCreds.SecuredServicesValidationToken;
            this.validationTokenTextBox4.Text = outCreds.UnsecuredServicesValidationToken;
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

    protected void getPinsButton_Click(object sender, EventArgs e)
    {
        double latitude = 0;
        double longitude = 0;
        double range = 0;
        try
        {
            latitude = Convert.ToDouble(this.latitudeTextBox.Text.Trim());
            longitude = Convert.ToDouble(this.longitudeTextBox.Text.Trim());
            range = Convert.ToDouble(this.rangeTextBox.Text.Trim());
        }
        catch (Exception ex)
        {
            ex.HelpLink = "";
            return;
        }
        string userId = userIdTextBox2.Text.Trim();
        string validationToken = this.validationTokenTextBox2.Text.Trim();
        if (userId.Equals(string.Empty) || validationToken.Equals(string.Empty))
        {
            return;
        }
        string tags = tagsTextBox.Text.Trim();

        ServerConstants.IntervalType iType = ServerConstants.IntervalType.None;
        switch (Convert.ToInt32(timeFilterRadioButtonList.SelectedValue))
        {
            case 0:
                iType = ServerConstants.IntervalType.None;
                break;

            case 1:
                iType = ServerConstants.IntervalType.Today;
                break;

            case 2:
                iType = ServerConstants.IntervalType.PastTwoDays;
                break;

            case 3:
                iType = ServerConstants.IntervalType.ThisWeek;
                break;

            case 4:
                iType = ServerConstants.IntervalType.PastTwoWeeks;
                break;
        }

        string transactionId = "Arbitrary Transaction Id";

        // all parameters ok
        Credentials creds = new Credentials();
        creds.UserId = userId;
        creds.UnsecuredServicesValidationToken = validationToken;
        BasicFilter filter = new BasicFilter();
        filter.Latitude = latitude;
        filter.Longitude = longitude;
        filter.Range = range;
        filter.IntervalType = iType;
        filter.Tags = tags;

        BasicPager pager = new BasicPager();
        pager.StartPosition = 1;
        pager.PageSize = 40;
        //pager.PageSize = ServerConstants.PagingConstants.Greedy;
        pager.PagingDirection = ServerConstants.PagingDirection.Forward;

        //creds = null; // testcase
        try
        {
            //GetPinsExResponse getPinsExResponse = this.gpiservice.GetPinsEx(creds, filter, ServerConstants.PinOrderDisposition.MostRecent, transactionId);
            //GetPinsExResponse getPinsExResponse = this.gpiservice.GetPinsEx(creds, filter, ServerConstants.PinOrderDisposition.HighestRated, pager, transactionId);
            GetPinsExResponse getPinsExResponse = this.gpiservice.GetPinsExWithValidationOption(creds, filter, ServerConstants.PinOrderDisposition.HighestRated, pager, transactionId, false);
            List<PinDetails> pins = getPinsExResponse.ResponseObj;
            string outTransactionId = getPinsExResponse.TransactionId;
            if (pins == null || pins.Count == 0)
            {
                return;
            }

            this.pinsTextBox.Text = "Pins= (Total pins = " + pins[0].TotalPinCount + ")";
            int pinCount = pins.Count;
            for (int i = 0; i < pinCount; i++)
            {
                PinDetails pd = pins[i];
                this.pinsTextBox.Text += Environment.NewLine + pd.PinNumber + ":" + pd.PinId + ":" + pd.Title + ":" + pd.Message + ":" + pd.Latitude + ":" + pd.Longitude + ":"
                    + pd.TagList + ":" + ":" + pd.AttachmentId + ":" + pd.AttachmentName + ":" + pd.AttachmentType + ":" 
                    + pd.Author + ":" + pd.AverageRating + ":" + pd.TotalEvaluations + ":"
                    + pd.TagList + ":" + pd.CreateTime + ":" + pd.ModifyTime + ":" + pd.CreateTimeInDb + ":" + pd.ModifyTimeInDb + ":" + outTransactionId;
            }
        }
        catch (SoapException ex)
        {
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(ex.Detail.OuterXml);
            XmlNamespaceManager nsManager = new XmlNamespaceManager(doc.NameTable);
            nsManager.AddNamespace("errorNS", "http://www.gpspostit.com/gpiws");
            XmlNode errorNode = doc.DocumentElement.SelectSingleNode("errorNS:Error", nsManager);
            string errorNumber = errorNode.SelectSingleNode("errorNS:ErrorNumber", nsManager).InnerText;
            string errorMessage = errorNode.SelectSingleNode("errorNS:ErrorMessage", nsManager).InnerText;
            string errorSource = errorNode.SelectSingleNode("errorNS:ErrorSource", nsManager).InnerText;

            this.pinsTextBox.Text = errorNumber + "\n" + errorMessage + "\n" + errorSource;
        }
    }

    protected void getAttachmentButton_Click(object sender, EventArgs e)
    {
        string userId = this.userIdTextBox4.Text.Trim();
        string pinIdStr = this.pinIdTextBox.Text.Trim();
        string validationToken = this.validationTokenTextBox4.Text.Trim();
        string attachmentIdStr = this.attachmentIdTextBox.Text.Trim();
        if (userId.Equals(string.Empty) || validationToken.Equals(string.Empty) || pinIdStr.Equals(string.Empty) 
            || attachmentIdStr.Equals(string.Empty))
        {
            return;
        }
        string transactionId = "Arbitrary Transaction Id";

        // all parameters ok
        Credentials creds = new Credentials();
        creds.UserId = userId;
        //creds.UnsecuredServicesValidationToken = validationToken;
        //creds.UnsecuredServicesValidationToken = string.Empty; // testcase
        //pinIdStr = string.Empty; // testcase
        //attachmentIdStr = string.Empty; // testcase
        try
        {
            GetAttachmentResponse getAttachmentResponse = this.gpiservice.GetAttachment(creds, pinIdStr, attachmentIdStr, transactionId);
            string outTransactionId = getAttachmentResponse.TransactionId;
            PinDetails pd = getAttachmentResponse.ResponseObj;

            if (pd != null)
            {
                this.attachmentTextBox.Text = pd.Attachment;
                this.attachmentInfoTextBox.Text = pd.AttachmentName + ":" + pd.AttachmentType + ":" + pd.AttachmentId;
            }
        }
        catch (SoapException ex)
        {
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(ex.Detail.OuterXml);
            XmlNamespaceManager nsManager = new XmlNamespaceManager(doc.NameTable);
            nsManager.AddNamespace("errorNS", "http://www.gpspostit.com/gpiws");
            XmlNode errorNode = doc.DocumentElement.SelectSingleNode("errorNS:Error", nsManager);
            string errorNumber = errorNode.SelectSingleNode("errorNS:ErrorNumber", nsManager).InnerText;
            string errorMessage = errorNode.SelectSingleNode("errorNS:ErrorMessage", nsManager).InnerText;
            string errorSource = errorNode.SelectSingleNode("errorNS:ErrorSource", nsManager).InnerText;

            this.attachmentTextBox.Text = errorNumber + "\n" + errorMessage + "\n" + errorSource;
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

        Credentials creds = new Credentials();
        creds.UserId = userId;
        creds.SecuredServicesValidationToken = validationToken;
        try
        {
            LogoutResponse logoutResponse = gpiservice_s.Logout(creds);
            this.logoutLabel.Text = logoutResponse.ResponseCode;
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
