<%@ Page Language="C#" AutoEventWireup="true" CodeFile="7TestGPIService_Groups.aspx.cs" Inherits="TestGPIService1" ValidateRequest="false" Debug="true"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Testing GPIService Groups</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Panel ID="Panel1" runat="server" Height="211px" Width="933px" BackColor="#FFFFC0">
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
                Width="926px"></asp:Label></asp:Panel>
        <br />
        <asp:Panel ID="Panel2" runat="server" BackColor="#FFFFC0" Height="678px" Width="916px">
            <asp:Label ID="userIdLabel2" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="User Id:"
                Width="130px"></asp:Label><asp:TextBox ID="userIdTextBox2" runat="server" Width="471px"></asp:TextBox><br />
            <asp:Label ID="Label2" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Put Validation Token:"
                Width="128px"></asp:Label><asp:TextBox ID="validationTokenTextBox2" runat="server"
                    Width="469px"></asp:TextBox><br />
            <asp:Label ID="Label5" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Put Validation Token:"
                Width="128px"></asp:Label><asp:TextBox ID="validationTokenTextBox99" runat="server"
                    Width="469px"></asp:TextBox><br />
            <br />
            <asp:Label ID="Label4" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Groups:"
                Width="130px"></asp:Label><br />
            <asp:ListBox ID="groupsListBox" runat="server" Width="469px">
            </asp:ListBox>&nbsp;<asp:ListBox ID="usersInGroupListBox" runat="server" Width="246px"></asp:ListBox><br />
            <asp:Button ID="getGroupsButton" runat="server" OnClick="getGroupsButton_Click"
                Text="Get Groups" Width="141px" />
            <asp:Button ID="removeGroupButton" runat="server"
                Text="Remove Group" Width="157px" OnClick="removeGroupButton_Click" />
            <asp:Button ID="getUsersInGroupButton" runat="server"
                Text="Get Users" Width="157px" OnClick="getUsersInGroupButton_Click" /><br />
            <br />
            <asp:Label ID="getGroupsResultsLabel" runat="server" Font-Names="Verdana" Font-Size="10pt"
                Width="773px"></asp:Label><br />
            &nbsp;<br />
            <asp:Label ID="Label3" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Group name:"
                Width="128px"></asp:Label><asp:TextBox ID="groupNameTextBox" runat="server" Width="263px"></asp:TextBox><br />
            <br />
            &nbsp;<asp:Button ID="createGroupButton" runat="server" OnClick="createGroupButton_Click"
                Text="Create Group" Width="287px" /><br />
            <br />
            &nbsp;<asp:Label ID="createGroupResultsLabel" runat="server" Font-Names="Verdana"
                Font-Size="10pt" Width="773px"></asp:Label>
            <br />
            <br />
            <asp:Label ID="Label6" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="User:"
                Width="73px"></asp:Label><asp:TextBox ID="userToAddTextBox" runat="server" Width="263px"></asp:TextBox><asp:Label
                    ID="Label7" runat="server" Font-Names="Verdana" Font-Size="10pt" Text=">> Group:"
                    Width="73px"></asp:Label><asp:TextBox ID="endpointGroupTextBox1" runat="server" Width="263px"></asp:TextBox><br />
            <asp:Button ID="addUserToGroupButton" runat="server"
                Text="Add User to Group" Width="287px" OnClick="addUserToGroupButton_Click" /><br />
            <br />
            <asp:Label ID="addUserToGroupResultsLabel" runat="server" Font-Names="Verdana" Font-Size="10pt"
                Width="773px"></asp:Label><br />
            <br />
            <asp:Label ID="Label8" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="User:"
                Width="73px"></asp:Label><asp:TextBox ID="userToBeRemovedTextBox" runat="server"
                    Width="263px"></asp:TextBox>
            <asp:Label ID="Label10" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="<< Group:"
                Width="73px"></asp:Label>
            <asp:TextBox ID="endpointGroupTextBox2" runat="server" Width="263px"></asp:TextBox><asp:Button ID="removeUserFromGroupButton" runat="server" 
                Text="Remove User From Group" Width="287px" OnClick="removeUserFromGroupButton_Click" /><br />
            <br />
            <asp:Label ID="removeUserFromGroupResultsLabel" runat="server" Font-Names="Verdana"
                Font-Size="10pt" Width="773px"></asp:Label></asp:Panel>
        <br />
        <asp:Panel ID="Panel3" runat="server" BackColor="#FFFFC0" Height="153px" Width="784px">
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
