<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
   <%
   String usererror = (String)request.getAttribute("usererror");
   System.out.println("UE: " + usererror);
   
   String username = (String)request.getAttribute("username");
   String password = (String)request.getAttribute("password");
   System.out.println(username);

   if(username == null){
   	username = "";
   	password = "";
   }
   
   if(usererror == null){
	   usererror = "";
   }
   %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Log in</title>
	<link rel="stylesheet" href="style.css">
</head>
	<body>
		<div id="header">
            <h2 onclick = "goToHome()">WeatherMeister</h2>
            <div id = "login">
	            <h4 id = "log" onclick="login()">Log in</h4>
	            <h4 id = "sin" onclick="signup()">Sign up</h4>
	            <div id = "profile">
            		<h4 id = "prof" onclick = "prof()">Profile</h4>
           		</div>
            </div>
            
        </div>
        
        <div id = "background">
            <img class = "back" src="images/background.jpg">
            <img id = "bvingette" src = "images/vignette.png">
        </div>
       	<div class = "main">
 
	       	<div class = "login"> 
	       		
		        <form class = "loginform" action = "logincheck" method="POST">
		        <img src = "images/keychain.png" class="lgnimg">
					<input type = "text" placeholder= "username" name = "username" class = "up">
					<input type = "text" placeholder = "password" name = "password" class = "up">
					<h1 class = "error" id ="usererror"></h1>
					<button id = "loginbtn"  class = "formbtn">Log In</button>
				</form>	
	        </div>
       	</div>
        
        
	</body>
	<script>
		<% if (username != "") { %>
			document.getElementById("login").style.display = "none";
			document.getElementById("profile").style.display = "block";
		<%}%>
		document.getElementById("usererror").innerHTML = "<%=usererror%>";
	</script>
	<script src="script.js"></script>
</html>