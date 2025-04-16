using System;
using System.Data;
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
            string selectedUsername = ddlUsers.SelectedValue;
            int otherId = DatabaseHelper.GetUserIdByUsername(selectedUsername);

            DataTable dt = DatabaseHelper.GetChatHistory(myId, otherId);

            foreach (DataRow row in dt.Rows)
            {
                string senderName = row["SenderID"].ToString() == myId.ToString() ? (string)Session["Username"] : selectedUsername;
                string message = row["MessageText"].ToString();
                string time = Convert.ToDateTime(row["ChatTime"]).ToString("g");
                bool isRead = Convert.ToBoolean(row["IsRead"]);

                string isReadText = isRead ? "<span style='color:green;font-size:10px;'>(read)</span>" : "<span style='color:gray;font-size:10px;'>(unread)</span>";

                string html = $"<div><b>{senderName}:</b> {message} <span style='font-size:10px;color:#999;'>({time})</span> {isReadText}</div>";
                chatBoxLiteral.Text += html;
            }
        }

    }
}
