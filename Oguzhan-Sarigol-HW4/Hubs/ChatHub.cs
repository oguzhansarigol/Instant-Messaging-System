using Microsoft.AspNet.SignalR;
using System.Threading.Tasks;
using Oguzhan_Sarigol_HW4.DAL; // SaveMessage metodunu çağırmak için

namespace Oguzhan_Sarigol_HW4.Hubs
{
    public class ChatHub : Hub
    {
        public void Send(string senderUsername, string receiverUsername, string message)
        {
            // Alıcıya mesajı gönder
            Clients.User(receiverUsername).receiveMessage(senderUsername, message);

            // Gönderene de aynı mesajı yansıt
            Clients.Caller.receiveMessage(senderUsername, message);

            // Veritabanına kaydet
            DatabaseHelper.SaveMessage(senderUsername, receiverUsername, message);
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
