<%@ Page Language="C#" AutoEventWireup="true" CodeFile="3TestGPIService_ModifyPin.aspx.cs" Inherits="TestGPIService3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Testing GPIService Modify Pin</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Panel ID="Panel1" runat="server" BackColor="#FFFFC0" Height="205px" Width="924px">
            <asp:Label ID="userIdLabel" runat="server" Font-Names="Verdana" Font-Size="10pt"
                Text="User:" Width="66px"></asp:Label>
            <asp:TextBox ID="userIdTextBox" runat="server"></asp:TextBox><br />
            <asp:Label ID="Label1" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Password:"></asp:Label>
            <asp:TextBox ID="passwordTextBox" runat="server" TextMode="Password" Width="147px"></asp:TextBox>&nbsp;<br />
            <br />
            <asp:Button ID="loginButton" runat="server" OnClick="loginButton_Click" Text="Login"
                Width="226px" />
            <br />
            <br />
            <asp:Label ID="validationTokenLabel" runat="server" Font-Names="Verdana" Font-Size="10pt"
                Width="916px"></asp:Label></asp:Panel>
        &nbsp;
        <br />
        <asp:Panel ID="Panel5" runat="server" BackColor="#FFFFC0" Height="700px" Width="916px">
            <asp:Label ID="Label12" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="User Id:"
                Width="130px"></asp:Label><asp:TextBox ID="userIdTextBox2" runat="server" Width="471px"></asp:TextBox><br />
            <asp:Label ID="Label13" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Put Validation Token:"
                Width="128px"></asp:Label>
            <asp:TextBox ID="validationTokenTextBox2" runat="server" Width="469px"></asp:TextBox><br />
            <asp:Label ID="Label20" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Pin Id:"
                Width="128px"></asp:Label><asp:TextBox ID="pinIdTextBox" runat="server" Width="384px"></asp:TextBox><br />
            <asp:Label ID="Label14" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Title:"
                Width="128px"></asp:Label><asp:TextBox ID="titleTextBox" runat="server"></asp:TextBox><br />
            <asp:Label ID="Label15" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Message:"
                Width="128px"></asp:Label><asp:TextBox ID="messageTextBox" runat="server"></asp:TextBox><br />
            <asp:Label ID="Label16" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Latitude:"
                Width="128px"></asp:Label><asp:TextBox ID="latitudeTextBox" runat="server"></asp:TextBox><br />
            <asp:Label ID="Label17" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Longitude:"
                Width="128px"></asp:Label><asp:TextBox ID="longitudeTextBox" runat="server"></asp:TextBox><br />
            <asp:Label ID="Label19" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Tags:"
                Width="128px"></asp:Label><asp:TextBox ID="tagsTextBox" runat="server"></asp:TextBox><br />
            <br />
            <asp:Button ID="modifyPinButton" runat="server" OnClick="modifyPinButton_Click"
                Text="Modify Pin" Width="287px" /><br />
            <br />
            <asp:Label ID="Label7" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Attachment:"
                Width="128px"></asp:Label><asp:FileUpload ID="FileUpload0" runat="server" /><br />
            <asp:Button ID="addAttachmentButton" runat="server" OnClick="addAttachmentButton_Click"
                Text="Add attachment" Width="287px" /><br />
            <br />
            <asp:Label ID="Label2" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Attachment Id:"
                Width="128px"></asp:Label><asp:TextBox ID="attachmentIdTextBox1" runat="server"></asp:TextBox><br />
            <asp:Label ID="Label4" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Attachment:"
                Width="128px"></asp:Label><asp:FileUpload ID="FileUpload1" runat="server" /><br />
            <asp:Button ID="modifyAttachmentButton" runat="server" OnClick="modifyAttachmentButton_Click"
                Text="Modify Attachment" Width="287px" /><br />
            <br />
            <asp:Label ID="Label3" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Attachment Id:"
                Width="128px"></asp:Label><asp:TextBox ID="attachmentIdTextBox2" runat="server"></asp:TextBox><br />
            <asp:Button ID="deleteAttachmentButton" runat="server" OnClick="deleteAttachmentButton_Click"
                Text="Delete Attachment" Width="287px" /><br />
            <br />
            <br />
            <asp:Label ID="Label18" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Result:"
                Width="128px"></asp:Label><br />
            <asp:TextBox ID="modifyPinResultTextBox" runat="server" Height="17px" Width="593px"></asp:TextBox></asp:Panel>
        <br />
        <asp:Panel ID="Panel4" runat="server" BackColor="#FFFFC0" Height="153px" Width="784px">
            <asp:Label ID="userLabel2" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="User Id:"
                Width="140px"></asp:Label><asp:TextBox ID="userIdTextBox3" runat="server" Width="461px"></asp:TextBox><br />
            <asp:Label ID="validationToken_S_Label" runat="server" Font-Names="Verdana" Font-Size="10pt"
                Text="Put Validation Token:"></asp:Label><asp:TextBox ID="validationTokenTextBox3"
                    runat="server" Width="458px"></asp:TextBox><br />
            <br />
            &nbsp;<asp:Button ID="logoutButton" runat="server" OnClick="logoutButton_Click" Text="Logout"
                Width="226px" />
            <br />
            <br />
            <asp:Label ID="logoutLabel" runat="server" Font-Names="Verdana" Font-Size="10pt"
                Width="773px"></asp:Label></asp:Panel>
    </div>
    </form>
</body>
</html>
