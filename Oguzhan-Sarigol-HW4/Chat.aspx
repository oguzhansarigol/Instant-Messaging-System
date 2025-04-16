<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Chat.aspx.cs" Inherits="Oguzhan_Sarigol_HW4.Chat" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Chat - MedConnect</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <script src="Scripts/jquery-3.4.1.min.js"></script>
    <script src="Scripts/jquery.signalR-2.4.3.min.js"></script>
    <script src="/signalr/hubs"></script>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Roboto', sans-serif;
            background-color: #f0f2f5;
        }
        .chat-container {
            display: flex;
            min-height: 100vh;
        }
        .sidebar {
            width: 250px;
            background-color: #0d1b28;
            color: white;
            padding: 20px 0;
            position: fixed;
            height: 100vh;
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
        }
        .main-chat {
            flex: 1;
            margin-left: 250px;
            padding: 30px;
        }
        .chat-header {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 20px;
            color: #0d1b28;
        }
        .chat-box {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            height: 400px;
            overflow-y: auto;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        .message-input {
            display: flex;
            margin-top: 15px;
        }
        .message-input input {
            flex: 1;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }
        .message-input button {
            padding: 12px 20px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 5px;
            margin-left: 10px;
            cursor: pointer;
            font-weight: bold;
        }
        #typingInfo {
            margin-top: 8px;
            font-size: 12px;
            font-style: italic;
            color: gray;
        }
        .dropdown {
            margin-bottom: 15px;
        }
        .back-link {
            text-align: center;
            margin-top: 10px;
        }

        .back-link a {
            color: white;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            transition: color 0.3s ease;
        }

        .back-link a i {
            margin-right: 6px;
            font-size: 14px;
        }

        .back-link a:hover {
            color: #3498db;
        }
        .custom-select {
            padding: 10px 14px;
            border: 1px solid #ccc;
            border-radius: 8px;
            background-color: white;
            font-size: 14px;
            color: #333;
            font-family: 'Roboto', sans-serif;
            outline: none;
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg fill='gray' height='16' viewBox='0 0 24 24' width='16' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M7 10l5 5 5-5z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 10px center;
            background-size: 12px;
        }


    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="chat-container">
            <div class="sidebar">
                <div class="logo">
                    <h2><i class="fas fa-comment-medical"></i> Chat</h2>
                </div>
                <div class="back-link">
                    <a href="Dashboard.aspx">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </div>

            </div>
            <div class="main-chat">
                <div class="chat-header">Real-time Chat</div>
                <div class="dropdown">

                    <asp:DropDownList ID="ddlUsers" runat="server" CssClass="custom-select" Width="300px" />

                </div>
                <asp:Literal ID="chatBoxLiteral" runat="server" EnableViewState="false" />
                <div class="chat-box" id="chatBox"></div>
                <div id="typingInfo"></div>
                <div class="message-input">
                    <input type="text" id="txtMessage" placeholder="Type your message..." />
                    <button type="button" id="btnSend">Send</button>
                </div>
            </div>
        </div>
    </form>
    <script>
        $(function () {
            var username = "<%= Session["Username"] %>";
            var chat = $.connection.chatHub;

            chat.client.receiveMessage = function (sender, message, timestamp, isRead) {
                var statusText = isRead ? "<span style='color:green;font-size:10px;'>(read)</span>" : "<span style='color:gray;font-size:10px;'>(unread)</span>";
                $('#chatBox').append('<div><b>' + sender + ':</b> ' + message + ' <span style="font-size:10px; color:#999;">(' + timestamp + ')</span> ' + statusText + '</div>');
            };

            chat.client.showTyping = function (sender) {
                $('#typingInfo').text(sender + ' is typing...');
                clearTimeout(window.typingTimeout);
                window.typingTimeout = setTimeout(function () {
                    $('#typingInfo').text('');
                }, 2000);
            };

            $.connection.hub.qs = { 'username': username };

            $.connection.hub.start().done(function () {
                $('#btnSend').click(function () {
                    var receiver = $('#<%= ddlUsers.ClientID %>').val();
                    var message = $('#txtMessage').val();
                    chat.server.send(username, receiver, message);
                    $('#txtMessage').val('').focus();
                });

                $('#txtMessage').keypress(function (e) {
                    if (e.which === 13) {
                        $('#btnSend').click();
                        return false;
                    }
                });

                $('#txtMessage').on('input', function () {
                    var receiver = $('#<%= ddlUsers.ClientID %>').val();
                    chat.server.notifyTyping(username, receiver);
                });
            });
        });
    </script>
</body>
</html>