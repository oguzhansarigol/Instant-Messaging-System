# Instant Messaging System – MedConnect

An ASP.NET WebForms-based real-time messaging application that enables doctors and patients to communicate instantly. Built with SignalR for real-time communication and a Microsoft Access database for data persistence.
[![Demo](https://img.youtube.com/vi/polY8OW2XNA/maxresdefault.jpg)](https://www.youtube.com/watch?v=polY8OW2XNA)


## Features

- User authentication with role-based access (Doctor and Patient)
- Real-time chat using SignalR
- Message read/unread indicators with timestamp
- Typing indicator for active conversations
- Chat history loading from the database
- Responsive and modern UI with separate views for doctors and patients
- Profile management (update full name, email, and password)
- Secure session management
- Optional file sharing feature

## Technologies Used

- ASP.NET WebForms
- SignalR (Microsoft.AspNet.SignalR)
- Microsoft Access (.accdb)
- ADO.NET with OleDb
- HTML/CSS/JavaScript
- jQuery

## How to Run the Project

1. **Clone the Repository**
git clone https://github.com/oguzhansarigol/Instant-Messaging-System.git

2. **Open in Visual Studio**
- Open the `.sln` file in Visual Studio 2022.
- Make sure the `ChatDB.accdb` file is located in the `App_Data` folder (or wherever the `Web.config` connection string points to).

3. **Configure Database Connection**
- Open `Web.config` and ensure the connection string points to your Access database path:
  ```xml
  <connectionStrings>
      <add name="ChatDBConnection" connectionString="Provider=Microsoft.ACE.OLEDB.12.0;Data Source=|DataDirectory|ChatDB.accdb;" providerName="System.Data.OleDb" />
  </connectionStrings>
  ```

4. **Build and Run**
- Restore NuGet packages if needed.
- Run the project (F5).
- Default page is `Login.aspx`.

## Folder Structure

- `DAL/` - Data access layer (e.g., `DatabaseHelper.cs`)
- `Hubs/` - SignalR hub (`ChatHub.cs`)
- `Pages/` - ASPX pages: Login, Dashboard, Chat, Profile
- `App_Data/` - Access database file (`ChatDB.accdb`)
- `Scripts/` - JavaScript libraries (SignalR, jQuery)

## Known Issues / Limitations

- Works best in modern browsers (Chrome, Edge, Firefox)
- File sharing is basic and lacks preview/download progress

## Additional Notes

- The project was developed as part of a Web-Based Technologies homework.
- Backend logic is built around SignalR events and Access SQL operations.
- Code is structured for readability and modularity to support future updates such as file previews, push notifications, and theme customization.
