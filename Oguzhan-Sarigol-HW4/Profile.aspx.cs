using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Oguzhan_Sarigol_HW4.DAL;

namespace Oguzhan_Sarigol_HW4
{
    public partial class Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                var user = DatabaseHelper.GetUserById(userId);

                if (user != null)
                {
                    txtFullName.Text = user["FullName"].ToString();
                    txtEmail.Text = user["Email"].ToString();
                }
            }
        }
        protected void btnSave_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim(); // boşsa güncellenmez

            bool success = DatabaseHelper.UpdateUserProfile(userId, fullName, email, password);

            if (success)
            {
                lblMessage.Text = "Profile updated successfully!";
            }
            else
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Update failed.";
            }
        }
    }
}