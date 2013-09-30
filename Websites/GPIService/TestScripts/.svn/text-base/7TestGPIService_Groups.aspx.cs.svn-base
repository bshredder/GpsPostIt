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
using System.Collections.Generic;

public partial class TestGPIService1 : System.Web.UI.Page
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
            this.validationTokenTextBox99.Text = outCreds.UnsecuredServicesValidationToken;
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

    protected void getGroupsButton_Click(object sender, EventArgs e)
    {
        string userId = this.userIdTextBox2.Text.Trim();
        string validationToken = this.validationTokenTextBox99.Text.Trim();
        if (userId.Equals(string.Empty) || validationToken.Equals(string.Empty))
        {
            return;
        }

        // all parameters ok
        Credentials credentials = new Credentials();
        credentials.UserId = userId;
        credentials.UnsecuredServicesValidationToken = validationToken;
        string transactionId = "Arbitrary TransactionId String";
        try
        {
            GetGroupsResponse getGroupsResponse = this.gpiservice.GetGroups(credentials, transactionId);
            List<GroupDetails> groups = getGroupsResponse.ResponseObj;
            string outTransactionId = getGroupsResponse.TransactionId;
            getGroupsResultsLabel.Text = getGroupsResponse.ResponseCode;
            this.groupsListBox.Items.Clear();            

            if (groups == null || groups.Count == 0)
            {
                return;
            }
            int groupCount = groups.Count;
            for (int i = 0; i < groupCount; i++)
            {
                GroupDetails gd = groups[i];
                this.groupsListBox.Items.Add(gd.Name);
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

            this.getGroupsResultsLabel.Text = errorNumber + "\n" + errorMessage + "\n" + errorSource;
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

    protected void createGroupButton_Click(object sender, EventArgs e)
    {
        string userId = this.userIdTextBox2.Text.Trim();
        string validationToken = this.validationTokenTextBox2.Text.Trim();
        string groupName = this.groupNameTextBox.Text.Trim();
        if (userId.Equals(string.Empty) || validationToken.Equals(string.Empty) || groupName.Equals(string.Empty))
        {
            return;
        }

        // all parameters ok
        Credentials credentials = new Credentials();
        credentials.UserId = userId;
        credentials.SecuredServicesValidationToken = validationToken;
        string transactionId = "Arbitrary TransactionId String";
        //credentials.UserId = string.Empty; // testcase
        try
        {
            CreateGroupResponse createGroupResponse = this.gpiservice_s.CreateGroup(credentials, groupName, transactionId);
            string outTransactionId = createGroupResponse.TransactionId;
            outTransactionId = createGroupResponse.TransactionId;
            createGroupResultsLabel.Text = createGroupResponse.ResponseCode;
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

            this.createGroupResultsLabel.Text = errorNumber + "\n" + errorMessage + "\n" + errorSource;
        }
    }

    protected void addUserToGroupButton_Click(object sender, EventArgs e)
    {
        string userId = this.userIdTextBox2.Text.Trim();
        string validationToken = this.validationTokenTextBox2.Text.Trim();
        string userName = this.userToAddTextBox.Text.Trim();
        string groupName = this.endpointGroupTextBox1.Text.Trim();
        if (userId.Equals(string.Empty) || validationToken.Equals(string.Empty) || userName.Equals(string.Empty) || groupName.Equals(string.Empty))
        {
            return;
        }

        // all parameters ok
        Credentials credentials = new Credentials();
        credentials.UserId = userId;
        credentials.SecuredServicesValidationToken = validationToken;
        string transactionId = "Arbitrary TransactionId String";
        //credentials.UserId = string.Empty; // testcase
        try
        {
            AddUserToGroupResponse addUserToGroupResponse = this.gpiservice_s.AddUserToGroup(credentials, userName, groupName, transactionId);
            string outTransactionId = addUserToGroupResponse.TransactionId;
            addUserToGroupResultsLabel.Text = addUserToGroupResponse.ResponseCode;
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

            this.addUserToGroupResultsLabel.Text = errorNumber + "\n" + errorMessage + "\n" + errorSource;
        }
    }

    protected void getUsersInGroupButton_Click(object sender, EventArgs e)
    {
        string userId = this.userIdTextBox2.Text.Trim();
        string validationToken = this.validationTokenTextBox99.Text.Trim();
        if (userId.Equals(string.Empty) || validationToken.Equals(string.Empty) || this.groupsListBox.SelectedIndex < 0)
        {
            return;
        }
        string groupName = this.groupsListBox.SelectedItem.Text.ToString();

        // all parameters ok
        Credentials credentials = new Credentials();
        credentials.UserId = userId;
        credentials.UnsecuredServicesValidationToken = validationToken;
        string transactionId = "Arbitrary TransactionId String";
        //groupName = string.Empty; // testcase
        try
        {
            GetUsersInGroupResponse getUsersInGroupResponse = this.gpiservice.GetUsersInGroup(credentials, groupName, transactionId);
            List<UserDetails> users = getUsersInGroupResponse.ResponseObj;
            string outTransactionId = getUsersInGroupResponse.TransactionId;
            getGroupsResultsLabel.Text = getUsersInGroupResponse.ResponseCode;
            this.usersInGroupListBox.Items.Clear();

            if (users == null || users.Count == 0)
            {
                return;
            }
            int usersCount = users.Count;
            for (int i = 0; i < usersCount; i++)
            {
                UserDetails ud = users[i];
                this.usersInGroupListBox.Items.Add(ud.UserName);
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

            this.getGroupsResultsLabel.Text = errorNumber + "\n" + errorMessage + "\n" + errorSource;
        }
    }

    protected void removeUserFromGroupButton_Click(object sender, EventArgs e)
    {
        string userId = this.userIdTextBox2.Text.Trim();
        string validationToken = this.validationTokenTextBox2.Text.Trim();
        string userName = this.userToBeRemovedTextBox.Text.Trim();
        string groupName = this.endpointGroupTextBox2.Text.Trim();
        if (userId.Equals(string.Empty) || validationToken.Equals(string.Empty) || userName.Equals(string.Empty) || groupName.Equals(string.Empty))
        {
            return;
        }

        // all parameters ok
        Credentials credentials = new Credentials();
        credentials.UserId = userId;
        credentials.SecuredServicesValidationToken = validationToken;
        string transactionId = "Arbitrary TransactionId String";
        //groupName = string.Empty; // testcase
        try
        {
            RemoveUserFromGroupResponse removeUserFromGroupResponse = this.gpiservice_s.RemoveUserFromGroup(credentials, userName, groupName, transactionId);
            string outTransactionId = removeUserFromGroupResponse.TransactionId;
            removeUserFromGroupResultsLabel.Text = removeUserFromGroupResponse.ResponseCode;
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

            this.removeUserFromGroupResultsLabel.Text = errorNumber + "\n" + errorMessage + "\n" + errorSource;
        }
    }

    protected void removeGroupButton_Click(object sender, EventArgs e)
    {
        string userId = this.userIdTextBox2.Text.Trim();
        string validationToken = this.validationTokenTextBox2.Text.Trim();
        if (userId.Equals(string.Empty) || validationToken.Equals(string.Empty) || this.groupsListBox.SelectedIndex < 0)
        {
            return;
        }
        string groupName = this.groupsListBox.SelectedItem.Text.Trim();
 
        // all parameters ok
        Credentials credentials = new Credentials();
        credentials.UserId = userId;
        credentials.SecuredServicesValidationToken = validationToken;
        string transactionId = "Arbitrary TransactionId String";
        //groupName = string.Empty; // testcase
        try
        {
            RemoveGroupResponse removeGroupResponse = this.gpiservice_s.RemoveGroup(credentials, groupName, transactionId);
            string outTransactionId = removeGroupResponse.TransactionId;
            getGroupsResultsLabel.Text = removeGroupResponse.ResponseCode;
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

            this.getGroupsResultsLabel.Text = errorNumber + "\n" + errorMessage + "\n" + errorSource;
        }
    }
}
