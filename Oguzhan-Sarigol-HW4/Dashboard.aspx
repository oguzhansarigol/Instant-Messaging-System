<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Oguzhan_Sarigol_HW4.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Dashboard</title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="margin: 50px auto; width: 400px;">
            <h2>Welcome, <asp:Label ID="lblName" runat="server" /></h2>
            <h4>Your Role: <asp:Label ID="lblRole" runat="server" /></h4>
            <asp:Button ID="btnLogout" runat="server" Text="Logout" OnClick="btnLogout_Click" /><br /><br />

            <asp:Label ID="lblContacts" runat="server" Text="Your Contacts:" Font-Bold="True"></asp:Label><br />
            <asp:Repeater ID="rptContacts" runat="server">
                <ItemTemplate>
                    <div>
                        - <%# Eval("FullName") %> (<%# Eval("Username") %>)
                        <a href='Chat.aspx?to=<%# Eval("Username") %>' style="margin-left:10px;">Chat</a>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </form>
</body>
</html>
