package project1;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.naming.*;  // for JNDI
import javax.sql.*;     // extended JDBC interfaces (such as data sources)
import java.sql.*;      // standard JDBC interfaces
import java.io.*;
import java.util.Date;
import java.text.SimpleDateFormat;

public class Servlet1 extends HttpServlet {

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

  public void doGet (HttpServletRequest req, HttpServletResponse resp)
                     throws ServletException, IOException {

/* Get the user-specified WHERE clause from the HTTP request, then   */
/* construct the SQL query.                                          */
      String queryVal = req.getParameter("queryVal");
          String query =
            "select last_name, employee_id from employees " +
            "where last_name like " + queryVal;

    resp.setContentType("text/html");

    PrintWriter out = resp.getWriter();
    out.println("<html>");
    out.println("<head><title>GetEmpInfo</title></head>");
    out.println("<body>");

/* Create a JDBC statement object, execute the query, and set up     */
/* HTML table formatting for the output.                             */
    try {
      Statement stmt = conn.createStatement();
      ResultSet rs = stmt.executeQuery(query);

        out.println("<table border=1 width=50%>");
        out.println("<tr><th width=75%>Last Name</th><th width=25%>Employee " +
                   "ID</th></tr>");

/* Loop through the results. Use the ResultSet getString() and       */
/* getInt() methods to retrieve the individual data items.           */
        int count=0;
        while (rs.next()) {
         count++;
         out.println("<tr><td>" + rs.getString(1) + "</td><td>" +rs.getInt(2) +
                    "</td></tr>");
       
        }
         out.println("</table>"); 
         out.println("<h3>" + count + " rows retrieved</h3>");
         
      rs.close();
      stmt.close();
    }
    catch (SQLException se) {
      se.printStackTrace(out);
    }

    out.println("</body></html>");
  }
  
  public void doPost(HttpServletRequest req, HttpServletResponse resp)
                     throws ServletException, IOException{
          String firstName = req.getParameter("firstName");
          String lastName = req.getParameter("lastName");
          String id = req.getParameter("id");
          String email = req.getParameter("email");
          String hireDate = req.getParameter("hireDate");
          String jobID = req.getParameter("jobId");
                

          String query =
                    "insert into employees (employee_id, first_name, last_name, email, hire_date, job_id) " +
                    "values (" + Integer.parseInt(id) +", '" + firstName + "', '" + lastName
                    + "', '" + email + "', TO_DATE('" + hireDate + "', 'DD-MON-YY'), '" + jobID + "')";
      try{
          
          Statement statement = conn.createStatement();
          System.err.println(statement.executeUpdate(query));
    
      }
        catch (Exception e) {
                System.err.println("Got an exception! "); 
                System.err.println(e.getMessage()); 
          }
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