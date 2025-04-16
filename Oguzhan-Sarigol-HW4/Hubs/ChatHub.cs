using Microsoft.AspNet.SignalR;
using System.Threading.Tasks;
using Oguzhan_Sarigol_HW4.DAL; // SaveMessage metodunu çağırmak için
using System;

namespace Oguzhan_Sarigol_HW4.Hubs
{
    public class ChatHub : Hub
    {
        public void Send(string senderUsername, string receiverUsername, string message)
        {
            // Alıcıya mesajı gönder
            Clients.User(receiverUsername).receiveMessage(senderUsername, message, DateTime.Now.ToString("g"), false);


            // Gönderene de aynı mesajı yansıt
            Clients.Caller.receiveMessage(senderUsername, message, DateTime.Now.ToString("g"), true);


            // Veritabanına kaydet
            DatabaseHelper.SaveMessage(senderUsername, receiverUsername, message);
        }
        public void MarkAsRead(string senderUsername, string receiverUsername)
        {
            int senderId = DatabaseHelper.GetUserIdByUsername(senderUsername);
            int receiverId = DatabaseHelper.GetUserIdByUsername(receiverUsername);

            // Veritabanında IsRead = true yap
            DatabaseHelper.MarkMessagesAsRead(receiverId, senderId);

            // Tik ikonlarını güncellemek için her iki tarafa event gönder
            Clients.User(senderUsername).updateReadStatus(receiverUsername);
        }


        public void NotifyTyping(string senderUsername, string receiverUsername)
        {
            Clients.User(receiverUsername).showTyping(senderUsername);
        }

        public override Task OnConnected()
        {
            string username = Context.QueryString["username"];
            if (!string.IsNullOrEmpty(username))
            {
                // Kullanıcıyı kullanıcı adıyla ilişkilendir (Clients.User eşleşmesi için)
                Groups.Add(Context.ConnectionId, username);
            }

            return base.OnConnected();
        }
    }
}