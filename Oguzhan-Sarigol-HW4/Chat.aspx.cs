using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using Oguzhan_Sarigol_HW4.DAL;

namespace Oguzhan_Sarigol_HW4
{
    public partial class Chat : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUsers();
                PreselectUser();
                LoadChatHistory();// önce mesajları göster
                                  // sonra okundu olarak işaretle                 
                int myId = Convert.ToInt32(Session["UserID"]);
                string selectedUsername = ddlUsers.SelectedValue;
                int otherId = DatabaseHelper.GetUserIdByUsername(selectedUsername);
                DatabaseHelper.MarkMessagesAsRead(myId, otherId);
            }

        }

        private void LoadUsers()
        {
            string myRole = Session["Role"].ToString();
            int myId = Convert.ToInt32(Session["UserID"]);
            string oppositeRole = myRole == "Doctor" ? "Patient" : "Doctor";

            DataTable dt = DatabaseHelper.GetUsersByRole(oppositeRole, myId);
            ddlUsers.DataSource = dt;
            ddlUsers.DataTextField = "FullName";
            ddlUsers.DataValueField = "Username";
            ddlUsers.DataBind();
        }

        private void PreselectUser()
        {
            string toUsername = Request.QueryString["to"];
            if (!string.IsNullOrEmpty(toUsername))
            {
                ListItem item = ddlUsers.Items.FindByValue(toUsername);
                if (item != null)
                    item.Selected = true;
            }
        }
        private void LoadChatHistory()
        {
            int myId = Convert.ToInt32(Session["UserID"]);
            string myUsername = Session["Username"].ToString();
            string selectedUsername = ddlUsers.SelectedValue;
            int otherId = DatabaseHelper.GetUserIdByUsername(selectedUsername);

            DataTable dt = DatabaseHelper.GetChatHistory(myId, otherId);

            foreach (DataRow row in dt.Rows)
            {
                int senderId = Convert.ToInt32(row["SenderID"]);
                string senderName = senderId == myId ? myUsername : selectedUsername;
                string message = row["MessageText"].ToString();
                string time = Convert.ToDateTime(row["ChatTime"]).ToString("g");
                bool isRead = Convert.ToBoolean(row["IsRead"]);
                bool isMine = senderId == myId;

                // Doğrudan HTML oluştur ve script olarak ekle
                string iconHtml = "";
                if (isMine)
                {
                    iconHtml = isRead
                        ? "<i class='fas fa-check-double' style='color:deepskyblue; font-size:11px; margin-left:4px;'></i>"
                        : "<i class='fas fa-check' style='color:gray; font-size:11px; margin-left:4px;'></i>";
                }

                string messageType = isMine ? "message-outgoing" : "message-incoming";
                string messageHtml = $@"
            <div class='message {messageType}'>
                <div class='message-bubble'>
                    <div class='message-sender'>{senderName}</div>
                    <div class='message-content'>{message}</div>
                    <div class='message-meta'>
                        <span class='message-time'>{time}</span>
                        {iconHtml}
                    </div>
                </div>
            </div>";

                // HTML'i doğrudan ekleyen script
                string script = $"$('#chatBox').append({Newtonsoft.Json.JsonConvert.SerializeObject(messageHtml)});";
                ScriptManager.RegisterStartupScript(this, GetType(), Guid.NewGuid().ToString(), script, true);
            }
        }
    }
}