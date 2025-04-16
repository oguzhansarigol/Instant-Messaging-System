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
        public static int GetUserIdByUsername(string username)
        {
            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                conn.Open();
                string query = "SELECT UserID FROM USERS WHERE Username=@username";
                OleDbCommand cmd = new OleDbCommand(query, conn);
                cmd.Parameters.AddWithValue("@username", username);
                object result = cmd.ExecuteScalar();
                return result != null ? Convert.ToInt32(result) : -1;
            }
        }
        public static void MarkMessagesAsRead(int receiverId, int senderId)
        {
            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                conn.Open();
                string query = "UPDATE CHAT SET IsRead = true WHERE ReceiverID = ? AND SenderID = ? AND IsRead = false";
                using (OleDbCommand cmd = new OleDbCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("?", receiverId); // bu kullanıcı
                    cmd.Parameters.AddWithValue("?", senderId);   // mesaj atan kişi
                    cmd.ExecuteNonQuery();
                }
            }
        }

        public static DataTable GetChatHistory(int user1Id, int user2Id)
        {
            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                conn.Open();
                string query = @"SELECT * FROM CHAT 
                         WHERE (SenderID = ? AND ReceiverID = ?) OR (SenderID = ? AND ReceiverID = ?)
                         ORDER BY ChatTime ASC";

                using (OleDbCommand cmd = new OleDbCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("?", user1Id);
                    cmd.Parameters.AddWithValue("?", user2Id);
                    cmd.Parameters.AddWithValue("?", user2Id);
                    cmd.Parameters.AddWithValue("?", user1Id);

                    OleDbDataAdapter adapter = new OleDbDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    return dt;
                }
            }
        }
        public static DataRow GetUserById(int userId)
        {
            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                conn.Open();
                string query = "SELECT * FROM USERS WHERE UserID = ?";
                OleDbCommand cmd = new OleDbCommand(query, conn);
                cmd.Parameters.AddWithValue("?", userId);

                OleDbDataAdapter adapter = new OleDbDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                if (dt.Rows.Count > 0)
                    return dt.Rows[0];
                return null;
            }
        }

        public static bool UpdateUserProfile(int userId, string fullName, string email, string password)
        {
            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                conn.Open();
                string query;
                OleDbCommand cmd;

                if (!string.IsNullOrEmpty(password))
                {
                    query = "UPDATE USERS SET FullName=?, Email=?, Password=? WHERE UserID=?";
                    cmd = new OleDbCommand(query, conn);
                    cmd.Parameters.AddWithValue("?", fullName);
                    cmd.Parameters.AddWithValue("?", email);
                    cmd.Parameters.AddWithValue("?", password); // basit şifreleme önerilir
                }
                else
                {
                    query = "UPDATE USERS SET FullName=?, Email=? WHERE UserID=?";
                    cmd = new OleDbCommand(query, conn);
                    cmd.Parameters.AddWithValue("?", fullName);
                    cmd.Parameters.AddWithValue("?", email);
                }

                cmd.Parameters.AddWithValue("?", userId);
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public static void SaveMessage(string senderUsername, string receiverUsername, string message)
        {
            try
            {
                int senderId = GetUserIdByUsername(senderUsername);
                int receiverId = GetUserIdByUsername(receiverUsername);

                if (senderId == -1 || receiverId == -1)
                {
                    System.Diagnostics.Debug.WriteLine("[ERROR] Kullanıcı ID bulunamadı.");
                    return;
                }

                using (OleDbConnection conn = new OleDbConnection(connStr))
                {
                    conn.Open();
                    string query = "INSERT INTO CHAT (SenderID, ReceiverID, MessageText, ChatTime, IsRead) " +
                                   "VALUES (?, ?, ?, ?, ?)";

                    using (OleDbCommand cmd = new OleDbCommand(query, conn))
                    {
                        // OleDb soru işaretleri sırasına göre parametre ekliyor
                        cmd.Parameters.Add("SenderID", OleDbType.Integer).Value = senderId;
                        cmd.Parameters.Add("ReceiverID", OleDbType.Integer).Value = receiverId;
                        cmd.Parameters.Add("MessageText", OleDbType.VarChar).Value = message;
                        cmd.Parameters.Add("ChatTime", OleDbType.Date).Value = DateTime.Now;
                        cmd.Parameters.Add("IsRead", OleDbType.Boolean).Value = false;

                        cmd.ExecuteNonQuery();
                    }
                }

                System.Diagnostics.Debug.WriteLine("[INFO] Mesaj veritabanına kaydedildi.");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("[ERROR] Mesaj kaydedilemedi: " + ex.Message);
                // Debug için hata mesajını konsola yazdırın
                Console.WriteLine("[ERROR] Mesaj kaydedilemedi: " + ex.Message);
            }
        }



    }
}