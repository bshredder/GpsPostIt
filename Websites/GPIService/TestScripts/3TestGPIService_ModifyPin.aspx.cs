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
using System.IO;


public partial class TestGPIService3 : System.Web.UI.Page
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

    protected void modifyPinButton_Click(object sender, EventArgs e)
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
        string pinId = this.pinIdTextBox.Text.Trim();
        string title = this.titleTextBox.Text.Trim();
        string message = this.messageTextBox.Text.Trim();
        if (userId.Equals(string.Empty) || validationToken.Equals(string.Empty) || title.Equals(string.Empty)
            || message.Equals(string.Empty))
        {
            return;
        }
        string transactionId = "Arbitrary TransactionId String";
        string tags = this.userIdTextBox.Text.Trim();
        if (!this.tagsTextBox.Text.Trim().Equals(String.Empty))
        {
            tags += " " + this.tagsTextBox.Text.Trim().ToLower();
        }
        string modifyTime = DateTime.Now.ToUniversalTime().ToString();
        string outTransactionId = string.Empty;

        // all parameters ok
        Credentials credentials = new Credentials();
        credentials.UserId = userId;
        credentials.SecuredServicesValidationToken = validationToken;
        PinDetails inPin = new PinDetails();
        inPin.PinId = pinId;
        inPin.Title = title;
        inPin.Message = message;
        inPin.Latitude = latitude;
        inPin.Longitude = longitude;
        inPin.TagList = tags;
        inPin.ModifyTime = modifyTime;
        try
        {
            ModifyPinResponse mr = this.gpiservice_s.ModifyPin(credentials, inPin, null, transactionId);
            PinDetails pin = mr.ResponseObj;
            outTransactionId = mr.TransactionId;
            if (pin != null)
            {
                this.modifyPinResultTextBox.Text = pin.PinId + ":" + pin.Title + ":" + pin.Message + ":" + pin.Latitude + ":" + pin.Longitude + ":" + pin.TagList + ":" + pin.AttachmentId + ":" + pin.AttachmentName + ":" + pin.AttachmentType + ":" + pin.Author + ":"
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

            this.modifyPinResultTextBox.Text = errorNumber + "\n" + errorMessage + "\n" + errorSource;
        }
    }

    protected void addAttachmentButton_Click(object sender, EventArgs e)
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
        string pinId = this.pinIdTextBox.Text.Trim();
        string title = this.titleTextBox.Text.Trim();
        string message = this.messageTextBox.Text.Trim();
        if (userId.Equals(string.Empty) || validationToken.Equals(string.Empty) || title.Equals(string.Empty)
            || message.Equals(string.Empty))
        {
            return;
        }
        string transactionId = "Arbitrary TransactionId String";
        string tags = this.userIdTextBox.Text.Trim();
        if (!this.tagsTextBox.Text.Trim().Equals(String.Empty))
        {
            tags += " " + this.tagsTextBox.Text.Trim().ToLower();
        }
        string modifyTime = DateTime.Now.ToUniversalTime().ToString();
        string outTransactionId = string.Empty;

        // all parameters ok
        Credentials credentials = new Credentials();
        credentials.UserId = userId;
        credentials.SecuredServicesValidationToken = validationToken;
        PinDetails inPin = new PinDetails();
        inPin.PinId = pinId;
        inPin.Title = title;
        inPin.Message = message;
        inPin.Latitude = latitude;
        inPin.Longitude = longitude;
        inPin.TagList = tags;
        inPin.ModifyTime = modifyTime;

        // handle attachment
        byte[] inArray = null;
        string s = string.Empty;
        List<AttachmentOperation> attachmentOps = new List<AttachmentOperation>();
        if (!this.FileUpload0.HasFile)
        {
            // no attachment, do nothing
            attachmentOps = null;
        }
        else
        {
            FileStream f = new FileStream(this.FileUpload0.PostedFile.FileName, FileMode.Open);
            BinaryReader b = new BinaryReader(f);
            inArray = b.ReadBytes((int)f.Length);
            s = Convert.ToBase64String(inArray);
            b.Close();
            f.Close();

            AttachmentOperation op = new AttachmentOperation();
            op.AttachmentOperationType = ServerConstants.AttachmentOperationType.Add;
            op.AttachmentId = string.Empty;
            op.AttachmentName = "bridge.jpg";
            op.AttachmentType = "image/jpeg";
            op.Attachment = s;
            attachmentOps.Add(op);
        }

        try
        {
            ModifyPinResponse mr = this.gpiservice_s.ModifyPin(credentials, inPin, attachmentOps, transactionId);
            PinDetails pin = mr.ResponseObj;
            outTransactionId = mr.TransactionId;
            if (pin != null)
            {
                this.modifyPinResultTextBox.Text = pin.PinId + ":" + pin.Title + ":" + pin.Message + ":" + pin.Latitude + ":" + pin.Longitude + ":" + pin.TagList + ":" + pin.AttachmentId + ":" + pin.AttachmentName + ":" + pin.AttachmentType + ":" + pin.Author + ":"
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

            this.modifyPinResultTextBox.Text = errorNumber + "\n" + errorMessage + "\n" + errorSource;
        }
    }

    protected void modifyAttachmentButton_Click(object sender, EventArgs e)
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
        string pinId = this.pinIdTextBox.Text.Trim();
        string title = this.titleTextBox.Text.Trim();
        string message = this.messageTextBox.Text.Trim();
        if (userId.Equals(string.Empty) || validationToken.Equals(string.Empty) || title.Equals(string.Empty)
            || message.Equals(string.Empty))
        {
            return;
        }
        string transactionId = "Arbitrary TransactionId String";
        string tags = this.userIdTextBox.Text.Trim();
        if (!this.tagsTextBox.Text.Trim().Equals(String.Empty))
        {
            tags += " " + this.tagsTextBox.Text.Trim().ToLower();
        }
        string modifyTime = DateTime.Now.ToUniversalTime().ToString();
        string outTransactionId = string.Empty;

        // all parameters ok
        Credentials credentials = new Credentials();
        credentials.UserId = userId;
        credentials.SecuredServicesValidationToken = validationToken;
        PinDetails inPin = new PinDetails();
        inPin.PinId = pinId;
        inPin.Title = title;
        inPin.Message = message;
        inPin.Latitude = latitude;
        inPin.Longitude = longitude;
        inPin.TagList = tags;
        inPin.ModifyTime = modifyTime;
        string attachmentId = attachmentIdTextBox1.Text;

        // handle attachment
        byte[] inArray = null;
        string s = string.Empty;
        List<AttachmentOperation> attachmentOps = new List<AttachmentOperation>();
        if (!this.FileUpload1.HasFile || attachmentId.Equals(string.Empty))
        {
            // no attachment, do nothing
            attachmentOps = null;
        }
        else
        {
            FileStream f = new FileStream(this.FileUpload1.PostedFile.FileName, FileMode.Open);
            BinaryReader b = new BinaryReader(f);
            inArray = b.ReadBytes((int)f.Length);
            s = Convert.ToBase64String(inArray);
            b.Close();
            f.Close();

            AttachmentOperation op = new AttachmentOperation();
            op.AttachmentOperationType = ServerConstants.AttachmentOperationType.Modify;
            op.AttachmentId = attachmentId;
            op.AttachmentName = "bridge.jpg";
            op.AttachmentType = "image/jpeg";
            op.Attachment = s;
            attachmentOps.Add(op);
        }
        
        try
        {
            ModifyPinResponse mr = this.gpiservice_s.ModifyPin(credentials, inPin, attachmentOps, transactionId);
            PinDetails pin = mr.ResponseObj;
            outTransactionId = mr.TransactionId;
            if (pin != null)
            {
                this.modifyPinResultTextBox.Text = pin.PinId + ":" + pin.Title + ":" + pin.Message + ":" + pin.Latitude + ":" + pin.Longitude + ":" + pin.TagList + ":" + pin.AttachmentId + ":" + pin.AttachmentName + ":" + pin.AttachmentType + ":" + pin.Author + ":"
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

            this.modifyPinResultTextBox.Text = errorNumber + "\n" + errorMessage + "\n" + errorSource;
        }
    }

    protected void deleteAttachmentButton_Click(object sender, EventArgs e)
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
        string pinId = this.pinIdTextBox.Text.Trim();
        string title = this.titleTextBox.Text.Trim();
        string message = this.messageTextBox.Text.Trim();
        if (userId.Equals(string.Empty) || validationToken.Equals(string.Empty) || title.Equals(string.Empty)
            || message.Equals(string.Empty))
        {
            return;
        }
        string transactionId = "Arbitrary TransactionId String";
        string tags = this.userIdTextBox.Text.Trim();
        if (!this.tagsTextBox.Text.Trim().Equals(String.Empty))
        {
            tags += " " + this.tagsTextBox.Text.Trim().ToLower();
        }
        string modifyTime = DateTime.Now.ToUniversalTime().ToString();
        string outTransactionId = string.Empty;

        // all parameters ok
        Credentials credentials = new Credentials();
        credentials.UserId = userId;
        credentials.SecuredServicesValidationToken = validationToken;
        PinDetails inPin = new PinDetails();
        inPin.PinId = pinId;
        inPin.Title = title;
        inPin.Message = message;
        inPin.Latitude = latitude;
        inPin.Longitude = longitude;
        inPin.TagList = tags;
        inPin.ModifyTime = modifyTime;
        string attachmentId = attachmentIdTextBox2.Text;

        // handle attachment
        string s = string.Empty;
        List<AttachmentOperation> attachmentOps = new List<AttachmentOperation>();
        if (attachmentId.Equals(string.Empty))
        {
            // no attachment, do nothing
            attachmentOps = null;
        }
        else
        {
            AttachmentOperation op = new AttachmentOperation();
            op.AttachmentOperationType = ServerConstants.AttachmentOperationType.Delete;
            op.AttachmentId = attachmentId;
            op.AttachmentName = string.Empty;
            op.AttachmentType = string.Empty;
            op.Attachment = string.Empty;
            attachmentOps.Add(op);
        }

        try
        {
            ModifyPinResponse mr = this.gpiservice_s.ModifyPin(credentials, inPin, attachmentOps, transactionId);
            PinDetails pin = mr.ResponseObj;
            outTransactionId = mr.TransactionId;
            if (pin != null)
            {
                this.modifyPinResultTextBox.Text = pin.PinId + ":" + pin.Title + ":" + pin.Message + ":" + pin.Latitude + ":" + pin.Longitude + ":" + pin.TagList + ":" + pin.AttachmentId + ":" + pin.AttachmentName + ":" + pin.AttachmentType + ":" + pin.Author + ":"
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

            this.modifyPinResultTextBox.Text = errorNumber + "\n" + errorMessage + "\n" + errorSource;
        }
    }
}
