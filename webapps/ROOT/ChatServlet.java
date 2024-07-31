import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import org.json.*;

public class ChatServlet extends HttpServlet {
    private Connection connection;
    private static final String URL = "jdbc:mariadb://localhost:3306/occ";
    private static final String USER = "root";
    private static final String PASSWORD = "1234";

    @Override
    public void init() throws ServletException {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int roomId = Integer.parseInt(request.getParameter("room_id"));
        try {
            PreparedStatement statement = connection.prepareStatement("SELECT * FROM messages WHERE room_id = ?");
            statement.setInt(1, roomId);
            ResultSet resultSet = statement.executeQuery();

            JSONArray messages = new JSONArray();
            while (resultSet.next()) {
                JSONObject message = new JSONObject();
                message.put("id", resultSet.getInt("id"));
                message.put("room_id", resultSet.getInt("room_id"));
                message.put("sender", resultSet.getString("sender"));
                message.put("message", resultSet.getString("message"));
                message.put("timestamp", resultSet.getTimestamp("timestamp").toString());
                messages.put(message);
            }

            response.setContentType("application/json");
            response.getWriter().write(messages.toString());
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            JSONObject json = new JSONObject(request.getReader().readLine());
            int roomId = json.getInt("room_id");
            String sender = json.getString("sender");
            String message = json.getString("message");

            PreparedStatement statement = connection.prepareStatement("INSERT INTO messages (room_id, sender, message) VALUES (?, ?, ?)");
            statement.setInt(1, roomId);
            statement.setString(2, sender);
            statement.setString(3, message);
            statement.executeUpdate();

            response.setStatus(HttpServletResponse.SC_OK);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    public void destroy() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

