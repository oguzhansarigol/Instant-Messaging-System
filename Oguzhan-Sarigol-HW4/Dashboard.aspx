<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Oguzhan_Sarigol_HW4.Dashboard" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>MedConnect</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <style>
        :root {
            --primary-color: #0d1b28;
            --secondary-color: #3498db;
            --light-color: #f8f9fa;
            --dark-color: #2c3e50;
            --success-color: #2ecc71;
            --danger-color: #e74c3c;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f0f2f5;
            color: #333;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 250px;
            background-color: var(--primary-color);
            color: white;
            padding: 20px 0;
            position: fixed;
            height: 100vh;
            transition: all 0.3s ease;
        }

        .logo {
            text-align: center;
            padding: 20px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }

        .logo h2 {
            color: white;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .logo i {
            color: var(--secondary-color);
            margin-right: 10px;
            font-size: 24px;
        }

        .sidebar-menu {
            padding: 0 15px;
        }

        .menu-item {
            padding: 12px 15px;
            border-radius: 5px;
            margin-bottom: 10px;
            transition: all 0.3s ease;
            cursor: pointer;
            display: flex;
            align-items: center;
        }

        .menu-item:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }

        .menu-item.active {
            background-color: var(--secondary-color);
        }

        .menu-item i {
            margin-right: 10px;
            font-size: 18px;
        }

        .main-content {
            flex: 1;
            margin-left: 250px;
            padding: 30px;
        }

        .user-welcome {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #ddd;
        }

        .welcome-text h1 {
            font-size: 28px;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 5px;
        }

        .welcome-text p {
            color: #666;
            font-size: 16px;
        }

        .user-actions {
            display: flex;
            align-items: center;
        }

        .user-profile {
            display: flex;
            align-items: center;
            margin-right: 20px;
            padding-right: 20px;
            border-right: 1px solid #ddd;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--secondary-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 10px;
        }

        .btn-logout {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 500;
            display: flex;
            align-items: center;
        }

        .btn-logout:hover {
            background-color: var(--dark-color);
        }

        .btn-logout i {
            margin-right: 5px;
        }

        .dashboard-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            display: flex;
            align-items: center;
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 24px;
        }

        .patients-icon {
            background-color: rgba(52, 152, 219, 0.1);
            color: var(--secondary-color);
        }

        .appointments-icon {
            background-color: rgba(46, 204, 113, 0.1);
            color: var(--success-color);
        }

        .messages-icon {
            background-color: rgba(155, 89, 182, 0.1);
            color: #9b59b6;
        }

        .stat-info h3 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .stat-info p {
            color: #666;
            font-size: 14px;
        }

        .contacts-section {
            background-color: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .section-header h2 {
            font-size: 20px;
            color: var(--primary-color);
        }

        .section-actions a {
            color: var(--secondary-color);
            text-decoration: none;
            display: flex;
            align-items: center;
        }

        .section-actions i {
            margin-left: 5px;
        }

        .contacts-list {
            max-height: 400px;
            overflow-y: auto;
        }

        .contact-item {
            display: flex;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #eee;
            transition: all 0.3s ease;
        }

        .contact-item:hover {
            background-color: #f9f9f9;
        }

        .contact-item:last-child {
            border-bottom: none;
        }

        .contact-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #ddd;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-weight: bold;
            color: var(--primary-color);
        }

        .contact-info {
            flex: 1;
        }

        .contact-name {
            font-weight: 500;
            margin-bottom: 3px;
        }

        .contact-username {
            color: #666;
            font-size: 13px;
        }

        .contact-actions {
            display: flex;
        }

        .btn-chat {
            background-color: var(--secondary-color);
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 13px;
            display: flex;
            align-items: center;
            text-decoration: none;
        }

        .btn-chat:hover {
            background-color: #2980b9;
        }

        .btn-chat i {
            margin-right: 5px;
        }

        @media (max-width: 992px) {
            .sidebar {
                width: 80px;
                padding: 20px 0;
            }
            
            .logo h2 span {
                display: none;
            }
            
            .menu-item span {
                display: none;
            }
            
            .menu-item {
                justify-content: center;
            }
            
            .menu-item i {
                margin-right: 0;
                font-size: 20px;
            }
            
            .main-content {
                margin-left: 80px;
            }
        }

        @media (max-width: 768px) {
            .dashboard-stats {
                grid-template-columns: 1fr;
            }
            
            .user-welcome {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .user-actions {
                margin-top: 20px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="dashboard-container">
            <div class="sidebar">
                <div class="logo">
                    <h2><i class="fas fa-heartbeat"></i> <span>MedConnect</span></h2>
                </div>
                <div class="sidebar-menu">
                    <div class="menu-item active">
                        <i class="fas fa-home"></i>
                        <span>Dashboard</span>
                    </div>
                    <div class="menu-item">
                        <i class="fas fa-user-md"></i>
                        <span>Doctors</span>
                    </div>
                    <div class="menu-item">
                        <i class="fas fa-calendar-check"></i>
                        <span>Appointments</span>
                    </div>
                    <div class="menu-item">
                        <i class="fas fa-comments"></i>
                        <span>Messages</span>
                    </div>
                    <div class="menu-item">
                        <i class="fas fa-cog"></i>
                        <span>Settings</span>
                    </div>
                </div>
            </div>
            
            <div class="main-content">
                <div class="user-welcome">
                    <div class="welcome-text">
                        <h1>Welcome, <asp:Label ID="lblName" runat="server" /></h1>
                        <p>Your Role: <asp:Label ID="lblRole" runat="server" /></p>
                    </div>
                    <div class="user-actions">
                        <div class="user-profile">
                            <div class="user-avatar">
                                <asp:Literal ID="ltUserInitial" runat="server" />
                            </div>
                            <div class="user-name">
                                <asp:Label ID="lblNameShort" runat="server" />
                            </div>
                        </div>
                        <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />


                    </div>
                </div>
                
                <div class="dashboard-stats">
                    <div class="stat-card">
                        <div class="stat-icon patients-icon">
                            <i class="fas fa-user-friends"></i>
                        </div>
                        <div class="stat-info">
                            <h3>
                                <asp:Literal ID="ltContactCount" runat="server" />
                            </h3>
                            <p>Total Contacts</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon appointments-icon">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <div class="stat-info">
                            <h3>8</h3>
                            <p>Upcoming Appointments</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon messages-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div class="stat-info">
                            <h3>12</h3>
                            <p>New Messages</p>
                        </div>
                    </div>
                </div>
                
                <div class="contacts-section">
                    <div class="section-header">
                        <h2><i class="fas fa-address-book"></i> Your Contacts</h2>
                        <div class="section-actions">
                            <a href="#">View All <i class="fas fa-arrow-right"></i></a>
                        </div>
                    </div>
                    <div class="contacts-list">
                        <asp:Repeater ID="rptContacts" runat="server">
                            <ItemTemplate>
                                <div class="contact-item">
                                    <div class="contact-avatar">
                                        <%# GetInitials(Eval("FullName").ToString()) %>
                                    </div>
                                    <div class="contact-info">
                                        <div class="contact-name"><%# Eval("FullName") %></div>
                                        <div class="contact-username">@<%# Eval("Username") %></div>
                                    </div>
                                    <div class="contact-actions">
                                        <a href='Chat.aspx?to=<%# Eval("Username") %>' class="btn-chat">
                                            <i class="fas fa-comment"></i> Chat
                                        </a>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script>
        // Function to add code for getting initials for the user avatar
        function getInitials() {
            let userName = document.getElementById('<%= lblName.ClientID %>').innerText;
            if (userName) {
                let nameParts = userName.split(' ');
                let initials = '';
                if (nameParts.length >= 2) {
                    initials = nameParts[0].charAt(0) + nameParts[1].charAt(0);
                } else {
                    initials = nameParts[0].charAt(0);
                }
                document.getElementById('<%= ltUserInitial.ClientID %>').innerText = initials.toUpperCase();
                document.getElementById('<%= lblNameShort.ClientID %>').innerText = userName.split(' ')[0];
            }
        }

        // Run on page load
        window.onload = function() {
            getInitials();
        };
    </script>
</body>
</html>