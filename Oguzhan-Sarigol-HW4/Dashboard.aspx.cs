﻿using System;
using System.Data;
using Oguzhan_Sarigol_HW4.DAL;

namespace Oguzhan_Sarigol_HW4
{
    public partial class Dashboard : System.Web.UI.Page
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
                lblName.Text = Session["FullName"].ToString();
                lblRole.Text = Session["Role"].ToString();
                LoadContacts();
            }
        }
        protected string GetInitials(string fullName)
        {
            if (string.IsNullOrWhiteSpace(fullName))
                return "";

            string[] parts = fullName.Trim().Split(' ');
            if (parts.Length == 1)
                return parts[0].Substring(0, 1).ToUpper();

            return (parts[0][0].ToString() + parts[parts.Length - 1][0].ToString()).ToUpper();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        private void LoadContacts()
        {
            string role = Session["Role"].ToString();
            int currentUserID = Convert.ToInt32(Session["UserID"]);

            DataTable contacts;

            if (role == "Doctor")
                contacts = DatabaseHelper.GetUsersByRole("Patient", currentUserID);
            else
                contacts = DatabaseHelper.GetUsersByRole("Doctor", currentUserID);

            rptContacts.DataSource = contacts;
            rptContacts.DataBind();
        }
    }
}
