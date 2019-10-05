<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="weather.WeatherReader" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import = "java.util.ArrayList" %>
    
<!DOCTYPE html>
<%

String username = (String)request.getAttribute("username");
String password = (String)request.getAttribute("password");

if(username == null || username == ""){
	username = (String)session.getAttribute("username");
	password = (String)session.getAttribute("password");
}

String signout = request.getParameter("signout");

if(signout != null && signout != ""){
	username = "";
	password = "";
}

session.setAttribute("username", username);
session.setAttribute("password",password);


System.out.println(username);

if(username == null){
	username = "";
	password = "";
}

ArrayList<String> history = new ArrayList<>();
if(username != ""){

	System.out.println(username);	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		System.out.println("here?");
		conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/assignment3?user=root&password=&serverTimezone=UTC");
		ps = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
		ps.setString(1, username);
		rs = ps.executeQuery();
		
		
		
		int size = 0;
		int userID = -1;
		while(rs.next()) {
			size++;
			userID = rs.getInt("id");
			System.out.println("ID: " + userID);
		}
		ps.close();
		rs.close();
		
		ps = conn.prepareStatement("SELECT * FROM history WHERE userid=?");
		ps.setString(1, userID + "");
		rs = ps.executeQuery();
		
		while(rs.next()){
			System.out.println(rs.getString("content"));
			history.add(rs.getString("content"));
		}

		
		
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

%>

<html lang="en">
    
    <head>
        <title>Weather</title>
        
        <link rel="stylesheet" href="style.css">
        <style>
        	.inputimg{
				margin-left:-70px;
				 margin-top:-45px;
				 
				
			}
			#locclick{
				
				margin-left:-70px;
				 margin-top:-45px;
			}
			
        </style>
    </head>
    <body>
    
        
        <div id="header">
            <h2 onclick = "goToHome()">WeatherMeister</h2>
            <div id = "login">
	            <h4 id = "log" onclick="login()">Log in</h4>
	            <h4 id = "sin" onclick="signup()">Sign up</h4>
            </div>
            <div id = "profile">
            
            	<h4 id = "prof" onclick = "prof()">Profile</h4>
            	<h4 id = "signout" onclick = "signout()">Sign Out</h4>
            </div>
            
        </div>
        <div id = "background">
            <img class = "back" src="images/background.jpg">
            <img id = "bvingette" src = "images/vignette.png">
        </div>
        
        
        <div class="main hist">
        <div>
        <h1 id ="usernameinfo"></h1>
        </div>
        
        	<div id = "histtable" >
                <div id = "scroll">
                    <table id = "table1">
                        <thead id = "th">
  
                        </thead>  

                        <tbody id = "tablecontent">
                        	
                        </tbody>
                    </table>
                   </div>
                    
              </div>
        	
        </div>
    </body>
	
	<script src="script.js"></script>
    <script>

		    //console.log(response);
		    
		    <% if (username != "") { %>
		    	
		    	document.getElementById("login").style.display = "none";
		    	document.getElementById("profile").style.display = "flex";
		    	document.getElementById("usernameinfo").innerHTML = "<%=username%>" + "'s Search History";
		    <%}%>
		    
		    <% for(int i = history.size() - 1; i >= 0; i--){ %>
          		tr = document.createElement("tr");
          		td1 = document.createElement("td");
    	    	td1.innerHTML = "<%= history.get(i) %>";	
    	    	tr.appendChild(td1);
    	    	document.getElementById("th").appendChild(tr);
    
    		<%}%>
		   
		   	
		  
        
        
        
        
    </script>




    
    
</html>