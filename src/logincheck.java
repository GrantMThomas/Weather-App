


import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class logincheck
 */
@WebServlet("/logincheck")
public class logincheck extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public logincheck() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/index.jsp");
		dispatch.forward(request,response);
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		System.out.println(username);
		System.out.println(password);
		
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			System.out.println("here?");
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/assignment3?user=root&password=&serverTimezone=UTC");
			ps = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
			System.out.println("made it here");
			ps.setString(1, username);
			//ps.setString(2, password);
			rs = ps.executeQuery();
			System.out.println("made it here");
			
			int size = 0;
			while(rs.next()) {
				size++;
				//int studentID = rs.getInt("studentID");
				String uname = rs.getString("username");
				String pword = rs.getString("password");
				System.out.println(uname + " - " + pword);
			}
			if(size == 0) {
				RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/login.jsp");
				request.setAttribute("usererror", "Username does not exist");
				dispatch.forward(request,response);
			}
			ps.close();
			rs.close();
			
			ps = conn.prepareStatement("SELECT * FROM Users WHERE username=? AND password=?");
			ps.setString(1, username);
			ps.setString(2, password);
			rs = ps.executeQuery();
			size = 0;
			while(rs.next()) {
				size++;
				String uname = rs.getString("username");
				String pword = rs.getString("password");
				System.out.println(uname + " - " + pword);
			}
			if(size == 0) {
				RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/login.jsp");
				request.setAttribute("usererror", "Incorrect password");
				dispatch.forward(request,response);
			}
			RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/index.jsp");
			request.setAttribute("username", username);
			request.setAttribute("password", password);
			dispatch.forward(request,response);
			
		} catch(SQLException sqle) {
			System.out.println("sqle: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println("cnfe: " + cnfe.getMessage());
		} finally {
			try {
				if(rs != null) { rs.close();}
				if(ps != null) {ps.close();}
				if(conn != null) {conn.close();}
			} catch(SQLException sqle) {
				System.out.println("sqle closing stuff: " + sqle.getMessage());
				
			}
		}
	}
}


