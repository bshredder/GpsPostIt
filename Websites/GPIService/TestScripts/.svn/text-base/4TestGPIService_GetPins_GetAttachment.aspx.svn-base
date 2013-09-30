<%@ Page Language="C#" AutoEventWireup="true" CodeFile="4TestGPIService_GetPins_GetAttachment.aspx.cs" Inherits="TestGPIService4" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Testing GPIService Get Pins/Get Attachment</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Panel ID="Panel1" runat="server" BackColor="#FFFFC0" Height="222px" Width="904px">
            <asp:Label ID="userIdLabel" runat="server" Font-Names="Verdana" Font-Size="10pt"
                Text="User:" Width="66px"></asp:Label>
            <asp:TextBox ID="userIdTextBox" runat="server"></asp:TextBox><br />
            <asp:Label ID="Label1" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Password:"></asp:Label>
            <asp:TextBox ID="passwordTextBox" runat="server" TextMode="Password" Width="147px"></asp:TextBox>&nbsp;<br />
            <br />
            <asp:Button ID="loginButton" runat="server" Text="Login"
                Width="226px" OnClick="loginButton_Click" />
            <br />
            <br />
            <asp:Label ID="validationTokenLabel" runat="server" Font-Names="Verdana" Font-Size="10pt"
                Width="893px"></asp:Label></asp:Panel>
        </div>
        <br />
        <asp:Panel ID="Panel2" runat="server" BackColor="#FFFFC0" Height="650px" Width="900px">
            <asp:Label ID="Label13" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="User Id:"
                Width="124px"></asp:Label><asp:TextBox ID="userIdTextBox2" runat="server" Width="584px"></asp:TextBox><br />
            <asp:Label ID="Label2" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Get Validation Token:"
                Width="128px"></asp:Label>
            <asp:TextBox ID="validationTokenTextBox2" runat="server" Width="578px"></asp:TextBox><br />
            <asp:Label ID="Label5" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Latitude:"
                Width="128px"></asp:Label><asp:TextBox ID="latitudeTextBox" runat="server"></asp:TextBox><br />
            <asp:Label ID="Label6" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Longitude:"
                Width="128px"></asp:Label><asp:TextBox ID="longitudeTextBox" runat="server"></asp:TextBox><br />
            <asp:Label ID="Label3" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Range:"
                Width="128px"></asp:Label><asp:TextBox ID="rangeTextBox" runat="server"></asp:TextBox><br />
            <asp:Label ID="tagsLabel" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Tags:"
                Width="128px"></asp:Label><asp:TextBox ID="tagsTextBox" runat="server"></asp:TextBox><br />
            <br />
            &nbsp;<asp:Button ID="getPinsButton" runat="server" 
                Text="Get Pins" Width="287px" OnClick="getPinsButton_Click" /><br />
            <br />
            <asp:RadioButtonList ID="timeFilterRadioButtonList" runat="server" Font-Names="Verdana,Arial"
                Font-Size="10pt">
                <asp:ListItem Selected="True" Value="0">None</asp:ListItem>
                <asp:ListItem Value="1">Today</asp:ListItem>
                <asp:ListItem Value="2">Past 2 Days</asp:ListItem>
                <asp:ListItem Value="3">This Week</asp:ListItem>
                <asp:ListItem Value="4">Past 2 Weeks</asp:ListItem>
            </asp:RadioButtonList><br />
            <asp:Label ID="Label8" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Pins:"
                Width="128px"></asp:Label><br />
            <asp:TextBox ID="pinsTextBox" runat="server" Height="113px" TextMode="MultiLine"
                Width="593px"></asp:TextBox></asp:Panel>
        &nbsp;<br />
        
        <asp:Panel ID="Panel3" runat="server" BackColor="#FFFFC0" Height="400px" Width="900px">
            <asp:Label ID="Label4" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="User Id:"
                Width="124px"></asp:Label><asp:TextBox ID="userIdTextBox4" runat="server" Width="584px"></asp:TextBox><br />
            <asp:Label ID="Label7" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Get Validation Token:"
                Width="128px"></asp:Label>
            <asp:TextBox ID="validationTokenTextBox4" runat="server" Width="578px"></asp:TextBox><br />
            <asp:Label ID="Label10" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Pin Id:"
                Width="128px"></asp:Label><asp:TextBox ID="pinIdTextBox" runat="server"></asp:TextBox><br />
            <asp:Label ID="Label12" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Attachment Id:"
                Width="128px"></asp:Label><asp:TextBox ID="attachmentIdTextBox" runat="server"></asp:TextBox><br />
            <br />
            &nbsp;<asp:Button ID="getAttachmentButton" runat="server" 
                Text="Get Attachment" Width="287px" OnClick="getAttachmentButton_Click" /><br />
            <br />
            <asp:Label ID="Label14" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Attachment:"
                Width="128px"></asp:Label><br />
            <asp:TextBox ID="attachmentTextBox" runat="server" Height="113px" TextMode="MultiLine"
                Width="593px"></asp:TextBox>
            <br />
            <asp:Label ID="Label9" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Attachment Info:"
                Width="128px"></asp:Label><br />
            <asp:TextBox ID="attachmentInfoTextBox" runat="server" TextMode="SingleLine"
                Width="593px"></asp:TextBox></asp:Panel>
        &nbsp;<br />

        
        <asp:Panel ID="Panel6" runat="server" BackColor="#FFFFC0" Height="153px" Width="784px">
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
    </form>
</body>
</html>
