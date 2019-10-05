<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="weather.WeatherReader" %>
    
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
            <h2>WeatherMeister</h2>
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
        
        <div class="main">
        	
        	
            <img class = "img" id="logo" src="images/logo.png">

            <form name = "myform" method = "GET" action = "alltable.jsp" onsubmit = "return citysearch();">
                    
                    <input type="text" class="cityinput" id = "cityinput" placeholder = "City"  name = "cityinput">
                    <!--  -->
                    <input type = "text" class = "hide" value = "alltable.jsp?cityinput=" name="nexturl">
                    <!--  -->
                    
                    <button><img src = "images/magnifying_glass.jpeg" class="inputimg" id="cityclick"></button>
			</form>
			<form name = "myform" method = "GET" action = "alltable.jsp" onsubmit = "return lsearch();">
				 <input type = "text" class = "locinput" id = "li1" placeholder = "Lat."  name = "latinput">
                 <input type = "text" class = "locinput" id = "li2" placeholder = "Long."  name = "longinput">
                 <button><img src = "images/magnifying_glass.jpeg" class="inputimg" id = "locclick"></button>
                 <img src = "images/MapIcon.png" id = "google" onclick ="mp()" >
                    
			</form>
			<div id = "mapholder"> 
        		<div id = "map" style="height:100%; width:100%;"></div>
        	</div>
                   
            
            <form class = "radio">
                <input type = "radio" class = "rbutton" id = "cityselect" name = "select" onclick="city()"> City
                <input type = "radio" class = "rbutton" id = "latselect" name = "select" onclick="loc()">Location (Lat/Long)
            </form>
            
            
        </div>
    </body>
	
	<script src="script.js"></script>
    <script>

		    //console.log(response);
		    
		    <% if (username != "") { %>
		    	
		    	document.getElementById("login").style.display = "none";
		    	document.getElementById("profile").style.display = "flex";
		    <%}%>
		   
		   	
		   	function citysearch(){
		   		let city = document.getElementById("cityinput").value;
		   		city = city.trim();
		   		city = city
		   		let string = "http://api.openweathermap.org/data/2.5/weather?q="+ city +"&APPID=8f727ee320b1e83cccf26f96f2a48971";
		   		ajax(string, function(v1){
		   			
		   			if(v1 == ""){
		   				alert("City not found");
		   				return false;
		   			}
		   			else{
		   				window.location = 'alltable.jsp?cityinput=' + city;
		   				
		   				return true;
		   			}
		   			
		   			
		   		});
		   		return false;
		   	}


		    
		    
		 	document.getElementById("google").hidden = true; 
		    
            document.getElementById("locclick").hidden = true;
            document.getElementById("li1").hidden = true;
            document.getElementById("li2").hidden = true;
        function city(){
            document.getElementById("cityinput").hidden = false;
            document.getElementById("cityclick").hidden = false;

            document.getElementById("locclick").hidden = true;
            document.getElementById("li1").hidden = true;
            document.getElementById("li2").hidden = true;
            
            document.getElementById("google").hidden = true; //
            
        }
        function loc(){
            document.getElementById("locclick").hidden = false;
            document.getElementById("li1").hidden = false;
            document.getElementById("li2").hidden = false;

            document.getElementById("cityinput").hidden = true;
            document.getElementById("cityclick").hidden = true;
            document.getElementById("google").hidden = false;
        }

        function goToAll(){
            window.location = 'alltable.jsp?cityinput=all';return false;
        }
        
        
        
        
    </script>
<script 
  src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAS8H7kq0xX5QNOzv__yFrBtqdURhP2zHA&callback=initMap" async defer>
</script>



    
    
</html>