<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Oguzhan_Sarigol_HW4.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login | Chat App</title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="width:300px;margin:100px auto;padding:20px;border:1px solid #ccc;">
            <h3>Login</h3>
            <asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label><br />
            <asp:TextBox ID="txtUsername" runat="server" Placeholder="Username" CssClass="form-control" /><br />
            <asp:TextBox ID="txtPassword" runat="server" Placeholder="Password" TextMode="Password" CssClass="form-control" /><br />
            <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" CssClass="btn btn-primary" />
        </div>
    </form>
</body>
</html>
