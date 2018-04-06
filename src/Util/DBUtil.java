package Util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtil {
    /**
     * 连接数据库
     */
    public static Connection connectDB() {
        Connection conn = null;
        String classForName = "com.mysql.jdbc.Driver";
        String ServandDB = "jdbc:mysql://127.0.0.1:3306/OurBook";
        String DBUser = "root";
        String DBPWD = "root";

        try {
            Class.forName(classForName).newInstance();
            conn = DriverManager.getConnection(ServandDB, DBUser, DBPWD);
            System.out.println("数据库加载成功");
        } catch (Exception e) {
            System.out.println("数据库加载失败");
        }
        return conn;
    }
}
