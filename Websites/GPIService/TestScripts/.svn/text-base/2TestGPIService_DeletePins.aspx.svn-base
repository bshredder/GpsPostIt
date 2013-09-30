<%@ Page Language="C#" AutoEventWireup="true" CodeFile="2TestGPIService_DeletePins.aspx.cs" Inherits="TestGPIService2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Testing GPIService</title>
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
        <asp:Panel ID="Panel3" runat="server" BackColor="#FFFFC0" Height="286px" Width="921px">
            <asp:Label ID="Label9" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="User Id:"
                Width="125px"></asp:Label><asp:TextBox ID="userIdTextBox3" runat="server" Width="608px"></asp:TextBox><br />
            <asp:Label ID="Label10" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Put Validation Token:"
                Width="128px"></asp:Label><asp:TextBox ID="validationTokenTextBox3" runat="server"
                    Width="603px"></asp:TextBox><br />
            <asp:Label ID="Label4" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Pin Ids (separate with newlines):"
                Width="128px"></asp:Label>
            <asp:TextBox ID="pinIdsTextBox" runat="server" TextMode="MultiLine" Width="384px"></asp:TextBox><br />
            <br />
            &nbsp;<asp:Button ID="deletePinsButton" runat="server" 
                Text="Delete Pins" Width="287px" OnClick="deletePinsButton_Click" /><br />
            <br />
            <asp:Label ID="Label11" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Pins Deleted:"
                Width="128px"></asp:Label><br />
            <asp:TextBox ID="pinDeletedResultTextBox" runat="server" Height="20px"
                Width="593px"></asp:TextBox></asp:Panel>
        &nbsp;&nbsp;<br />
        <asp:Panel ID="Panel4" runat="server" BackColor="#FFFFC0" Height="153px" Width="784px">
            <asp:Label ID="userLabel2" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="User Id:"
                Width="140px"></asp:Label><asp:TextBox ID="userIdTextBox4" runat="server" Width="461px"></asp:TextBox><br />
            <asp:Label ID="validationToken_S_Label" runat="server" Font-Names="Verdana" Font-Size="10pt"
                Text="Put Validation Token:"></asp:Label><asp:TextBox ID="validationTokenTextBox4"
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
