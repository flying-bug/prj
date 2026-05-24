package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBContext {

    protected Connection connection;

    public DBContext() {
        try {
            String user = "sa";
            String pass = "Strong@12345!";

            String url = "jdbc:sqlserver://localhost:14333;"
                    + "databaseName=AutoWashPro;"
                    + "encrypt=true;"
                    + "trustServerCertificate=true;";

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            connection = DriverManager.getConnection(url, user, pass);

            System.out.println("CONNECTED OK");

        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace(); // <<< QUAN TRỌNG: KHÔNG LOG LOGGER
        }
    }

    public static void main(String[] args) {
        // Test connection
        DBContext db = new DBContext();
        if (db.connection != null) {
            System.out.println("Connection successful!");
        } else {
            System.out.println("Connection failed.");
        }
    }
}
