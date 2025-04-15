using System;
using System.Data;
using System.Data.OleDb;
using System.Configuration;

namespace Oguzhan_Sarigol_HW4.DAL
{
    public class DatabaseHelper
    {
        private static string connStr = ConfigurationManager.ConnectionStrings["ChatDBConnection"].ConnectionString;

        public static DataRow GetUser(string username, string password)
        {
            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                conn.Open();
                string query = "SELECT * FROM USERS WHERE Username=@username AND Password=@password";
                OleDbCommand cmd = new OleDbCommand(query, conn);
                cmd.Parameters.AddWithValue("@username", username);
                cmd.Parameters.AddWithValue("@password", password);

                OleDbDataAdapter adapter = new OleDbDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                if (dt.Rows.Count > 0)
                    return dt.Rows[0];
                else
                    return null;
            }
        }

        public static DataTable GetUsersByRole(string role, int excludeUserID)
        {
            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                conn.Open();
                string query = "SELECT * FROM USERS WHERE Role=@role AND UserID <> @uid";
                OleDbCommand cmd = new OleDbCommand(query, conn);
                cmd.Parameters.AddWithValue("@role", role);
                cmd.Parameters.AddWithValue("@uid", excludeUserID);

                OleDbDataAdapter adapter = new OleDbDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                return dt;
            }
        }

        public static void SaveMessage(string senderUsername, string receiverUsername, string message)
        {
            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                conn.Open();
                string query = "INSERT INTO CHAT (SenderUsername, ReceiverUsername, MessageText, ChatTime, IsRead) " +
                               "VALUES (?, ?, ?, ?, ?)";

                using (OleDbCommand cmd = new OleDbCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("?", senderUsername);
                    cmd.Parameters.AddWithValue("?", receiverUsername);
                    cmd.Parameters.AddWithValue("?", message);
                    cmd.Parameters.AddWithValue("?", DateTime.Now);
                    cmd.Parameters.AddWithValue("?", false);

                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}
