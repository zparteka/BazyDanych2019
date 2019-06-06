package project1;

import java.io.IOException;
import java.io.PrintWriter;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.InitialContext;
import javax.naming.NamingException;

import javax.servlet.*;
import javax.servlet.http.*;

import javax.sql.DataSource;

public class Servlet2 extends HttpServlet {

    DataSource ds = null;
    Connection conn = null;
    public void init() throws ServletException {
      try {
        InitialContext ic = new InitialContext();  // JNDI initial context
        ds = (DataSource) ic.lookup("jdbc/myDS"); // JNDI lookup
        conn = ds.getConnection();  // database connection through data source
      }
      catch (SQLException se) {
        throw new ServletException(se);
      }
      catch (NamingException ne) {
        throw new ServletException(ne);
      }
    }
    
    

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        PrintWriter out = response.getWriter();
        out.println("<html>");
        out.println("<head><title>Servlet2</title></head>");
        out.println("<body>");
        out.println("<p>The servlet has received a POST. This is the reply.</p>");
        out.println("</body></html>");
        out.close();
    }
    
    public void destroy() {
      try {
        conn.close();
      }
      catch (SQLException se) {
        se.printStackTrace();
      }
    }
}
