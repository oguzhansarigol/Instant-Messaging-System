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
            display: flex;
            align-items: center;
        }
        .chat-header-avatar {
            width: 40px;
            height: 40px;
            background-color: #3498db;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            color: white;
            font-weight: bold;
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
            background-color: white;
            border-radius: 24px;
            padding: 6px 12px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        }
        .message-input input {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 24px;
            font-size: 14px;
            outline: none;
            background: transparent;
        }
        .message-input button {
            padding: 12px 20px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 24px;
            cursor: pointer;
            font-weight: bold;
            box-shadow: 0 2px 5px rgba(52, 152, 219, 0.3);
        }
        #typingInfo {
            margin-top: 8px;
            font-size: 12px;
            font-style: italic;
            color: gray;
            height: 16px;
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

        /* Yeni chat kutuları için stiller */
        .message {
            display: flex;
            flex-direction: column;
            max-width: 70%;
            margin-bottom: 14px;
            clear: both;
        }
        
        .message-incoming {
            align-self: flex-start;
        }
        
        .message-outgoing {
            align-self: flex-end;
        }
        
        .message-bubble {
            border-radius: 12px;
            padding: 12px 16px;
            position: relative;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
            word-break: break-word;
        }
        
        .message-incoming .message-bubble {
            background-color: #E6F5FF; /* Soft blue */
            border: 1px solid #D1EAFF;
        }
        
        .message-outgoing .message-bubble {
            background-color: #e8ebff; /* Soft pink */
            border: 1px solid #d8ddff;
        }
        
        .message-sender {
            font-size: 12px;
            font-weight: 600;
            margin-bottom: 3px;
            color: #555;
        }
        
        .message-content {
            font-size: 14px;
            margin-bottom: 2px;
        }
        
        .message-meta {
            display: flex;
            justify-content: flex-end;
            font-size: 11px;
            color: #8c8c8c;
            margin-top: 2px;
        }
        
        .message-time {
            margin-right: 4px;
        }
        
        #chatBox {
            display: flex;
            flex-direction: column;
            padding: 10px;
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
                <div class="dropdown">
                    <asp:DropDownList ID="ddlUsers" runat="server" CssClass="custom-select" Width="300px" />
                </div>
                <div class="chat-header">
                    <div class="chat-header-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <div>Chat with <span id="selectedUserName"></span></div>
                </div>
                <div class="chat-box" id="chatBox"></div>
                <div id="typingInfo"></div>
                <div class="message-input">
                    <input type="text" id="txtMessage" placeholder="Type your message..." />
                    <button type="button" id="btnSend">
                        <i class="fas fa-paper-plane"></i> Send
                    </button>
                </div>
            </div>
        </div>
    </form>
   <script>
       $(function () {
           var username = "<%= Session["Username"] %>";
           var chat = $.connection.chatHub;

           // Seçili kullanıcı ismini göster
           function updateSelectedUser() {
               var selectedText = $('#<%= ddlUsers.ClientID %> option:selected').text();
               $('#selectedUserName').text(selectedText);
           }

           // İlk yüklemede seçili kullanıcıyı göster
           updateSelectedUser();

           // Dropdown değiştiğinde kullanıcı ismini güncelle
           $('#<%= ddlUsers.ClientID %>').change(function () {
               updateSelectedUser();
               // Sohbet geçmişini temizle
               $('#chatBox').empty();
               // Yeni kullanıcıyla olan mesajları yükle
               var receiver = $(this).val();
               chat.server.markAsRead(username, receiver);

               // Sayfayı yeniden yükle
               location.reload();
           });

           // Mouse ile chatbox'a girince mesajları okundu say
           $('#chatBox').on('mouseenter', function () {
               var receiver = $('#<%= ddlUsers.ClientID %>').val();
               chat.server.markAsRead(username, receiver);
           });

           // Eski mesajları LoadChatHistory ile yükle
           chat.client.receiveMessage = function (sender, message, timestamp, isMine) {
               let messageType = isMine ? 'message-outgoing' : 'message-incoming';
               let readStatus = "";

               if (isMine) {
                   readStatus = "<i class='fas fa-check' style='color:gray; font-size:11px; margin-left:4px;'></i>";
               }

               let messageHtml = `
                   <div class="message ${messageType}">
                       <div class="message-bubble">
                           <div class="message-sender">${sender}</div>
                           <div class="message-content">${message}</div>
                           <div class="message-meta">
                               <span class="message-time">${timestamp}</span>
                               ${readStatus}
                           </div>
                       </div>
                   </div>
               `;

               $('#chatBox').append(messageHtml);
               $('#chatBox').scrollTop($('#chatBox')[0].scrollHeight);
           };

           // "yazıyor" bilgisi
           chat.client.showTyping = function (sender) {
               $('#typingInfo').text(sender + ' is typing...');
               setTimeout(() => $('#typingInfo').text(""), 1500);
           };

           // Okundu güncellemesi
           chat.client.updateReadStatus = function (fromUser) {
               $('.message-outgoing .fas.fa-check').each(function () {
                   $(this).removeClass('fa-check').addClass('fa-check-double').css('color', 'deepskyblue');
               });
           };

           // Bağlantı açıldığında
           $.connection.hub.qs = { 'username': username };
           $.connection.hub.start().done(function () {
               $('#btnSend').click(function () {
                   var receiver = $('#<%= ddlUsers.ClientID %>').val();
                   var message = $('#txtMessage').val();
                   
                   if (message.trim() !== '') {
                       chat.server.send(username, receiver, message);
                       $('#txtMessage').val('').focus();
                   }
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

               // Sayfa yüklenince ilk markAsRead
               var initialReceiver = $('#<%= ddlUsers.ClientID %>').val();
               chat.server.markAsRead(username, initialReceiver);
           });

           // DropDown değişince tekrar markAsRead
           $('#<%= ddlUsers.ClientID %>').change(function () {
               var receiver = $(this).val();
               chat.server.markAsRead(username, receiver);
           });
           
           // Sayfanın sonuna kaydır
           function scrollToBottom() {
               $('#chatBox').scrollTop($('#chatBox')[0].scrollHeight);
           }
           
           // Sayfa yüklendiğinde en alta kaydır
           setTimeout(scrollToBottom, 100);
       });
   </script>

   <script>
       // Bu script C# tarafından LoadChatHistory metodu içerisindeki
       // ScriptManager.RegisterStartupScript ile çağrılan JS kodunu yakalamak için kullanılır

       // Eski mesajları yüklerken de yeni format kullanılsın
       function formatOldMessage(senderName, message, time, isRead, isMine) {
           let messageType = isMine ? 'message-outgoing' : 'message-incoming';
           let readStatus = "";

           if (isMine) {
               readStatus = isRead
                   ? "<i class='fas fa-check-double' style='color:deepskyblue; font-size:11px; margin-left:4px;'></i>"
                   : "<i class='fas fa-check' style='color:gray; font-size:11px; margin-left:4px;'></i>";
           }

           return `
               <div class="message ${messageType}">
                   <div class="message-bubble">
                       <div class="message-sender">${senderName}</div>
                       <div class="message-content">${message}</div>
                       <div class="message-meta">
                           <span class="message-time">${time}</span>
                           ${readStatus}
                       </div>
                   </div>
               </div>
           `;
       }
   </script>
</body>
</html>