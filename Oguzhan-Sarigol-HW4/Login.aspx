<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Oguzhan_Sarigol_HW4.Login" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet" />
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Roboto', sans-serif;
            background-color: #ffffff;
        }
        .container {
            display: flex;
            height: 100vh;
        }
        .image-side {
            flex: 1;
            background-color: #0d1b28; /* Koyu mavi arka plan rengi */
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        .doctor-image {
            height: 100%;
            object-fit: cover;
            object-position: center;
        }
        .form-side {
            flex: 1;
            background-color: #f8f9fa; /* Açık gri arka plan */
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: #000000;
        }
        .login-box {
            width: 80%;
            max-width: 350px;
        }
        h2 {
            margin-bottom: 10px;
            font-weight: 500;
            font-family: 'Roboto', sans-serif;
        }   
        h2:first-of-type {
            margin-bottom: 5px;
        }
        h2:nth-of-type(2) {
            margin-top: 0;
            margin-bottom: 20px;
            font-weight: 700;
            font-size: 28px;
        }
        input[type="text"], input[type="password"], .btn-login {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
            box-sizing: border-box;
        }
       .btn-login {
            background-color: #000000;
            color: white;
            font-weight: bold;
            cursor: pointer;
            outline: none;
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            text-align: center;
            font-family: 'Roboto', sans-serif;
        }
        .error-message {
            color: red;
            font-size: 13px;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="image-side">
                <img src="Content/login-image.png" alt="Doctor" class="doctor-image" />
            </div>
            <div class="form-side">
                <div class="login-box">
                    <h2>Hello !</h2>
                    <h2>Welcome Back</h2>
                    <asp:TextBox ID="txtUsername" runat="server" placeholder="Enter Username" CssClass="form-input" />
                    <asp:TextBox ID="txtPassword" runat="server" placeholder="Enter Password" TextMode="Password" CssClass="form-input" />
                    
                    <asp:Label ID="lblError" runat="server" CssClass="error-message" />
                    <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn-login" OnClick="btnLogin_Click" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>