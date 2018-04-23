package dao.impl;

import Util.DBUtil;
import dao.BookDao;
import model.Book;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Calendar;

public class BookDaoImpl implements BookDao {
    private Connection conn = null;

    @Override
    public Book findByID(int ID) {
        try {
            conn = DBUtil.connectDB(); // 连接数据库
            PreparedStatement stm = conn.prepareStatement("SELECT * FROM book WHERE ID = ?");
            stm.setInt(1, ID);
            Book[] books = getBooks(stm);
            if (books != null) return books[0];
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("BookDao: findbyID(" + ID + ")失败");
        }
        return null;
    }

    @Override
    public Book[] findByName(String name) {
        try {
            conn = DBUtil.connectDB(); // 连接数据库
            PreparedStatement stm = conn.prepareStatement("SELECT * FROM book WHERE name = ?");
            stm.setString(1, name);
            Book[] books = getBooks(stm);
            if (books != null) return books;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new Book[0];
    }

    @Override
    public Book[] findByKeywords(String[] keywords) {
        try {
            conn = DBUtil.connectDB(); // 连接数据库
            PreparedStatement stm = conn.prepareStatement("SELECT * FROM book_chapter WHERE "
                    + DBUtil.keywordsMatchCondition("keywords", keywords));
            Book[] books = getBooks(stm);
            if (books != null) return books;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new Book[0];
    }

    @Override
    public Book[] findByKeywordsClick(String[] keywords, String range) {
        try {
            conn = DBUtil.connectDB(); // 连接数据库
            PreparedStatement stm = conn.prepareStatement("SELECT * FROM book LEFT JOIN (SELECT * FROM click WHERE " + DBUtil.timeLimit("date", range) + ") as c ON book.ID = c.bookID WHERE "
                    + DBUtil.keywordsMatchCondition("keywords", keywords) +
                    " GROUP BY book.ID ORDER BY COUNT(*) DESC");
            Book[] books = getBooks(stm);
            if (books != null) return books;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new Book[0];
    }

    @Override
    public Book[] findByKeywordsFav(String[] keywords, String range) {
        try {
            conn = DBUtil.connectDB(); // 连接数据库
            PreparedStatement stm = conn.prepareStatement("SELECT * FROM book LEFT JOIN (SELECT * FROM favorite WHERE " + DBUtil.timeLimit("date", range) + ") as f ON book.ID = f.bookid WHERE "
                    + DBUtil.keywordsMatchCondition("keywords", keywords) +
                    " GROUP BY book.ID ORDER BY COUNT(*) DESC");
            Book[] books = getBooks(stm);
            if (books != null) return books;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new Book[0];
    }

    @Override
    public void add(Book book) {
        try {
            conn = DBUtil.connectDB(); // 连接数据库
            PreparedStatement stm = conn.prepareStatement("INSERT INTO book (ID,name,description,chiefEditor,keywords,cover,chapter_num) VALUES (null,?,?,?,?,?,0)");
            stm.setString(1, book.getName());
            stm.setString(2, book.getDescription());
            stm.setString(3, book.getChiefEditor());
            stm.setString(4, book.getKeywords());
            stm.setString(5, book.getCover());
            try {
                stm.executeUpdate();
                System.out.println("BookDao: 添加书目成功");
            } catch (Exception e1) {
                e1.printStackTrace();
                System.out.println("BookDao: 添加书目失败");
            }
            stm.close();
            conn.close(); // 关闭数据库连接
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public int maxID() {
        try {
            conn = DBUtil.connectDB(); // 连接数据库
            PreparedStatement stm = conn.prepareStatement("SELECT MAX(ID) AS max_id FROM book");
            ResultSet rs;
            try {
                rs = stm.executeQuery();
                int ret = -1;
                while (rs.next())
                    ret = rs.getInt("max_id");
                rs.close();
                stm.close();
                conn.close(); // 关闭数据库连接
                System.out.println("BookDao: 查询最大ID成功");
                return ret;
            } catch (Exception e1) {
                e1.printStackTrace();
                System.out.println("BookDao: 查询最大ID失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }


    public Book[] findByUserID(String chiefEditorID) {
        try {
            conn = DBUtil.connectDB(); // 连接数据库
            PreparedStatement stm = conn.prepareStatement("SELECT *, COUNT(c.bookID) AS clicks, COUNT(f.bookid) AS favs FROM book_chapter LEFT JOIN click c ON ID = c.bookID LEFT JOIN favorite f on ID = f.bookid WHERE chiefEditor = ? GROUP BY ID ORDER BY clicks DESC");
            stm.setString(1, chiefEditorID);
            Book[] books = getBooks(stm);
            if (books != null)
                return books;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new Book[0];
    }

    /**
     * 返回符合语句的多个书籍
     *
     * @param stm SQL语句
     * @return 符合语句的多个书籍
     */
    private Book[] getBooks(PreparedStatement stm) {
        try {
            ResultSet rs = stm.executeQuery();
            ArrayList<Book> books = new ArrayList<>();
            while (rs.next()) {
                Book book = new Book(rs.getInt("ID"), rs.getString("name"),
                        rs.getString("description"), rs.getString("chiefEditor"),
                        rs.getString("keywords"), rs.getString("cover"), rs.getInt("chapter_num"));
                try {
                    book.setClicks(rs.getInt("clicks"));
                } catch (Exception ignored) {
                }
                try {
                    book.setFavorites(rs.getInt("favs"));
                } catch (Exception ignored) {
                }
                try {
                    book.setLastModified(rs.getDate("last_modified"));
                } catch (Exception ignored) {
                }
                books.add(book);
            }
            rs.close();
            stm.close();
            conn.close(); // 关闭数据库连接
            return books.toArray(new Book[0]);
        } catch (Exception e) {
            System.out.println("BookDao: 获取书目失败:");
            e.printStackTrace();
        }
        return null;
    }


    @Override
    public boolean delete(int bookID) {
        try {
            conn = DBUtil.connectDB(); // 连接数据库
            PreparedStatement delChapter = conn.prepareStatement("DELETE FROM chapter WHERE bookID = ?");
            delChapter.setInt(1, bookID);
            PreparedStatement delClick = conn.prepareStatement("DELETE FROM click WHERE bookID = ?");
            delClick.setInt(1, bookID);
            PreparedStatement delBook = conn.prepareStatement("DELETE FROM book WHERE ID = ?");
            delBook.setInt(1, bookID);
            try {
                delChapter.executeUpdate();
                delClick.executeUpdate();
                delBook.executeUpdate();
                System.out.println("BookDao: 删除书目成功");
            } catch (Exception e1) {
                e1.printStackTrace();
                System.out.println("BookDao: 删除书目失败");
            }
            delChapter.close();
            delBook.close();
            conn.close(); // 关闭数据库连接
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public Book[] getFavorites(String username) {
        try {
            conn = DBUtil.connectDB(); // 连接数据库
            PreparedStatement stm = conn.prepareStatement("SELECT * FROM book, favorite WHERE username = ? AND bookid = ID");
            stm.setString(1, username);
            Book[] books = getBooks(stm);
            if (books != null) return books;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new Book[0];
    }

    @Override
    public boolean click(String username, int bookID) {
        try {
            conn = DBUtil.connectDB(); // 连接数据库
            PreparedStatement stm = conn.prepareStatement("INSERT INTO click VALUES (?,?,?)");
            stm.setString(1, username);
            stm.setInt(2, bookID);
            stm.setDate(3, new Date(Calendar.getInstance().getTime().getTime()));
            stm.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public Book[] recommend() {
        try {
            conn = DBUtil.connectDB();
            ArrayList<Book> books = new ArrayList<>();
            PreparedStatement stm = conn.prepareStatement("SELECT\n" +
                    "  bookID,\n" +
                    "  name,\n" +
                    "  description,\n" +
                    "  chiefEditor,\n" +
                    "  keywords,\n" +
                    "  cover,\n" +
                    "  chapter_num,\n" +
                    "  COUNT(bookID) AS count_book\n" +
                    "FROM book\n" +
                    "  JOIN click\n" +
                    "WHERE book.ID = click.bookID\n" +
                    "GROUP BY bookID\n" +
                    "ORDER BY count_book DESC");
            int displayBookNum = 10;
            ResultSet rs = stm.executeQuery();
            while (displayBookNum-- > 0 && rs.next()) {
                books.add(new Book(rs.getInt("bookID"), rs.getString("name"), rs.getString("description"), rs.getString("chiefEditor"), rs.getString("keywords"), rs.getString("cover"), rs.getInt("chapter_num")));
            }
            rs.close();
            stm.close();
            conn.close();
            return books.toArray(new Book[0]);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
