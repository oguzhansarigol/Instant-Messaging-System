<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Chat.aspx.cs" Inherits="Oguzhan_Sarigol_HW4.Chat" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Chat</title>
    <script src="Scripts/jquery-3.4.1.min.js"></script>
    <script src="Scripts/jquery.signalR-2.4.3.min.js"></script>
    <script src="/signalr/hubs"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div style="width:500px;margin:50px auto;">
            <h2>Real-time Chat</h2>
            <asp:DropDownList ID="ddlUsers" runat="server" Width="100%"></asp:DropDownList><br /><br />

            <div id="chatBox" style="height:300px; border:1px solid #ccc; overflow:auto; padding:10px;"></div><br />

            <input type="text" id="txtMessage" placeholder="Type your message..." style="width:80%;" />
            <button type="button" id="btnSend">Send</button>
        </div>
    </form>

    <script>
        $(function () {
            var username = "<%= Session["Username"] %>"; // ✅ Artık doğru

        var chat = $.connection.chatHub;

        chat.client.receiveMessage = function (sender, message) {
            $('#chatBox').append('<div><b>' + sender + ':</b> ' + message + '</div>');
        };

        $.connection.hub.qs = { 'username': username };

        $.connection.hub.start().done(function () {
            $('#btnSend').click(function () {
                var receiver = $('#<%= ddlUsers.ClientID %>').val();
                var message = $('#txtMessage').val();
                chat.server.send(username, receiver, message); // username gönderiyoruz
                $('#txtMessage').val('').focus();
            });
        });
    });
    </script>

</body>
</html>
