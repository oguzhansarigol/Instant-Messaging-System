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
    }
}
