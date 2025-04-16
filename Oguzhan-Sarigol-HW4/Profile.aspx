<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="Oguzhan_Sarigol_HW4.Profile" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>My Profile</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f7f6; /* Standard light gray background */
            padding: 30px; /* Standard padding */
            margin: 0;
            color: #333; /* Default text color */
        }

        .profile-box {
            background-color: white;
            padding: 30px; /* Slightly reduced padding */
            border-radius: 8px; /* Standard border radius */
            width: 500px; /* Adjusted width */
            max-width: 95%; /* Ensure responsiveness on smaller screens */
            margin: 40px auto; /* Top/bottom margin, centered horizontally */
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08); /* Softer shadow */
            border: 1px solid #e0e0e0; /* Optional: subtle border */
        }

        .profile-box h2 {
            margin-top: 0; /* Remove default top margin */
            margin-bottom: 25px;
            text-align: center;
            color: #333;
            font-weight: 600;
            font-size: 1.5rem; /* Standard header size */
        }

        .form-control {
            width: 100%;
            padding: 12px; /* Standard padding */
            margin: 12px 0; /* Standard margin */
            border: 1px solid #ccc; /* Standard border */
            border-radius: 6px; /* Standard border radius */
            box-sizing: border-box;
            font-size: 0.95rem; /* Standard font size */
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .form-control::placeholder {
            color: #999; /* Slightly darker placeholder */
            font-weight: 300;
        }

        .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 5px rgba(0, 123, 255, 0.25); /* Slightly subtler focus shadow */
            outline: none;
        }

        .btn-save {
            background-color: #007bff; /* Standard blue */
            color: white;
            border: none;
            padding: 12px 20px; /* Standard padding */
            cursor: pointer;
            border-radius: 6px; /* Standard border radius */
            width: 100%;
            margin-top: 15px;
            font-size: 1rem; /* Standard font size */
            font-weight: 500; /* Standard weight */
            text-transform: none; /* Removed uppercase */
            letter-spacing: normal; /* Removed letter spacing */
            transition: background-color 0.2s ease; /* Simple background transition */
        }

        .btn-save:hover {
            background-color: #0056b3; /* Darker blue on hover */
            /* Removed transform effect */
        }

        #lblMessage {
            display: block;
            text-align: center;
            margin-top: 15px;
            font-weight: 500; /* Adjusted weight */
            font-size: 0.9rem; /* Adjusted size */
        }
         /* Keep the back button styling as it was standard */
        .btn-back {
            display: block;
            text-align: center;
            margin-top: 20px; /* Increased space */
            color: #007bff;
            font-weight: 500;
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.3s ease;
        }

        .btn-back:hover {
            color: #0056b3;
            text-decoration: underline;
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="profile-box">
            <h2>My Profile</h2>
            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Full Name"></asp:TextBox>
            <asp:TextBox ID="txtEmail" runat="server" type="email" CssClass="form-control" placeholder="Email"></asp:TextBox>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="New Password (leave blank if unchanged)"></asp:TextBox>
            <asp:Button ID="btnSave" runat="server" CssClass="btn-save" Text="Save Changes" OnClick="btnSave_Click" />
             <%-- Label'ı butonun altına almak daha standart bir akış sağlar --%>
            <asp:Label ID="lblMessage" runat="server" ForeColor="Green" />
            <a href="Dashboard.aspx" class="btn-back">← Back to Dashboard</a>
        </div>
    </form>
</body>
</html>