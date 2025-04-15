using System;
using System.Web;
using System.Web.UI;
using Oguzhan_Sarigol_HW4.DAL;

namespace Oguzhan_Sarigol_HW4
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;

            // Oturum varsa yönlendir
            if (Session["UserID"] != null)
            {
                Response.Redirect("Dashboard.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            var user = DatabaseHelper.GetUser(username, password);

            if (user != null)
            {
                Session["UserID"] = user["UserID"];
                Session["FullName"] = user["FullName"];
                Session["Role"] = user["Role"];
                Session["Username"] = user["Username"];
                Response.Redirect("Dashboard.aspx");
                
            }
            else
            {
                lblError.Text = "Invalid username or password.";
            }
        }
    }
}
