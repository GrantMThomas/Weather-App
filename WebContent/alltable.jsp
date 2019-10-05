<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ page import="weather.WeatherReader" %>
  <%@ page import="weather.Weather" %>
   <%@ page import="weather.Wjson" %>
   
<%@ page import = "java.util.List" %>
<%@ page import = "java.util.ArrayList" %>
<%@ page import = "java.util.Collections" %>

<%@ page import = "com.google.gson.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.io.BufferedReader" %>
<%@ page import = "java.io.InputStreamReader" %>
<%@ page import = "java.io.FileReader" %>
<%@ page import = "java.util.Arrays" %>
<%@ page import="weather.WtJson" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>


<%
	String cityinput = request.getParameter("cityinput");
	double latinput = 181;
	double longinput = 0;
	if(request.getParameter("latinput") != null && request.getParameter("longinput") != null && request.getParameter("latinput") != "" && request.getParameter("longinput") != ""){
		latinput = Double.parseDouble(request.getParameter("latinput"));
		longinput = Double.parseDouble(request.getParameter("longinput"));
	}
	
	String username = (String)session.getAttribute("username");
	String password = (String)session.getAttribute("password");
	
	session.setAttribute("username", username);
	session.setAttribute("password",password);
	
	if(username == null){
		username = "";
	}
	
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
			if(size != 0){
				if(cityinput != null && cityinput != ""){
					ps = conn.prepareStatement("INSERT INTO History (content, userid) VALUES (?,?);");
					ps.setString(1, cityinput);
					ps.setString(2, userID + "");
					ps.executeUpdate();
				}
				else if(latinput != 181){
					ps = conn.prepareStatement("INSERT INTO History (content, userid) VALUES (?,?);");
					ps.setString(1, "(" + latinput + ", " + longinput + ")");
					ps.setString(2, userID + "");
					ps.executeUpdate();
				}
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
	
	
	
	
	System.out.println("Uname: " + username);


	//Parse json file here
	Gson gson = new Gson();
	java.net.URL ur = Weather.class.getResource("/../../city.txt"); 
	BufferedReader bfr = new BufferedReader(new InputStreamReader(ur.openStream()));
	
	
	
	
	Wjson[] data = new Gson().fromJson(bfr, Wjson[].class);
	
	System.out.println(data.length);
	
	ArrayList<Integer> ids = new ArrayList<>();
	
	//If using city parameter
	ArrayList<Weather> cities = new ArrayList<Weather>();
	System.out.println(data[0].getName());
	
	if(cityinput != null && cityinput != ""){
		cityinput = cityinput.toLowerCase();
		for(int i = 0; i < data.length; i++){
			if(data[i].getName().toLowerCase().equals(cityinput)){
				ids.add(data[i].getId());
			}
		}
		
		int twenties = ids.size() / 20;
		int remaining = ids.size() % 20;
		
		for(int i = 0; i < ids.size(); i++){
			String input = "http://api.openweathermap.org/data/2.5/weather?id=" + ids.get(i) +"&units=imperial&APPID=8f727ee320b1e83cccf26f96f2a48971";
			URL url = new URL(input);
			
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
			String resp = br.readLine();
			
			WtJson wtjson = new Gson().fromJson(resp, WtJson.class);
			Weather w = new Weather();
			
			System.out.println(wtjson.getName());
			w.setCity(wtjson.getName());
			w.setDayLow(wtjson.getMain().getTempMin());
			w.setDayHigh(wtjson.getMain().getTempMax());
			w.setId(wtjson.getId());
			w.setCountry(wtjson.getSys().getCountry());
			

			cities.add(w);
			
			
		}
	}
	else if (latinput != 181){
		String input = "http://api.openweathermap.org/data/2.5/weather?lat=" + latinput + "&lon=" + longinput  + "&units=imperial&APPID=8f727ee320b1e83cccf26f96f2a48971";
		URL url = new URL(input);
		
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
		String resp = br.readLine();
		
		WtJson wtjson = new Gson().fromJson(resp, WtJson.class);
		Weather w = new Weather();
		
		System.out.println(wtjson.getName());
		w.setCity(wtjson.getName());
		w.setDayLow(wtjson.getMain().getTempMin());
		w.setDayHigh(wtjson.getMain().getTempMax());
		w.setId(wtjson.getId());
		w.setCountry(wtjson.getSys().getCountry());
		
		cities.add(w);
		

		br.close();
	}
	
	
	
	
	Collections.sort(cities, Weather.byName);
	ArrayList<Weather> byName = new ArrayList<Weather>();
	for(int i = 0; i < cities.size(); i++){
		byName.add(cities.get(i));
	}
	Collections.sort(cities, Weather.byNameD);
	ArrayList<Weather> byNameD = new ArrayList<Weather>();
	for(int i = 0; i < cities.size(); i++){
		byNameD.add(cities.get(i));
	}
	
	Collections.sort(cities, Weather.byTempHigh);
	ArrayList<Weather> byTempHigh = new ArrayList<Weather>();
	for(int i = 0; i < cities.size(); i++){
		byTempHigh.add(cities.get(i));
	}
	Collections.sort(cities, Weather.byTempHighD);
	ArrayList<Weather> byTempHighD = new ArrayList<Weather>();
	for(int i = 0; i < cities.size(); i++){
		byTempHighD.add(cities.get(i));
	}
	
	Collections.sort(cities, Weather.byTempLow);
	ArrayList<Weather> byTempLow = new ArrayList<Weather>();
	for(int i = 0; i < cities.size(); i++){
		byTempLow.add(cities.get(i));
	}
	Collections.sort(cities, Weather.byTempLowD);
	ArrayList<Weather> byTempLowD = new ArrayList<Weather>();
	for(int i = 0; i < cities.size(); i++){
		byTempLowD.add(cities.get(i));
	}
	
	
	 
	
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Weather</title>
        
        <link rel="stylesheet" href="style.css">
        <style>
        	.inputimg{
				margin-left:35px;
				 margin-top:-50px;
				
			}
			#locclick{
				
				margin-left:-40px;
				 margin-top:-50px;
			}
			#cityinput2{
				background-color:white;
			}
			.l2{
				background-color:white
			}
        </style>
       
    </head>
    <body>
        
        <div id="header">
            <h2 id = "toplink" onclick="goToHome()">WeatherMeister</h2>
            <!-- <form>             
                <input type="text" class="cityinput" id = "cityinput2">
                <img src = "images/magnifying_glass.jpeg" class="inputimg" id="cityclick">

                <input type = "text" class = "locinput l2" id = "li1">
                <input type = "text" class = "locinput l2" id = "li2">
                <img src = "images/magnifying_glass.jpeg" class="inputimg loctop" id = "locclick">
                
            </form> -->
            
            <form name = "myform" method = "GET" action = "alltable.jsp" onsubmit = "return citysearch();">
                    
                    <input type="text" class="cityinput" id = "cityinput2" placeholder = "City"  name = "cityinput">
                    <button><img src = "images/magnifying_glass.jpeg" class="inputimg" id="cityclick"></button>
			</form>
			<form name = "myform" method = "GET" action = "alltable.jsp" onsubmit = "return lsearch();">
				 <input type = "text" class = "locinput l2" id = "li1" placeholder = "Lat."  name = "latinput">
                 <input type = "text" class = "locinput l2" id = "li2" placeholder = "Long."  name = "longinput">
                 <button><img src = "images/magnifying_glass.jpeg" class="inputimg" id = "locclick"></button>
                 <img src = "images/MapIcon.png" id = "google" onclick ="mp()" >
    
			</form>

            <form class = "radio" id="r2">
                <input type = "radio" class = "rbutton" id = "cityselect" name = "select" onclick="city()"> City
                <input type = "radio" class = "rbutton" id = "latselect" name = "select" onclick="loc()">Location (Lat/Long)
            </form>
        </div>
        <div id = "background">
            <img class = "back" src="images/background.jpg">
            <img id = "bvingette" src = "images/vignette.png">
        </div>
        
        <div class="main acmain">
            <div id = "table">
            <h1 id = "allcities">All cities</h1>
                <div id = "scroll">
                    <table id = "table1">
                        <thead>
                            <tr>
                                <th>City Name</th>
                                <th>Temp. Low</th>
                                <th>Temp. High</th>
                            </tr>
                        </thead>  

                        <tbody id = "tablecontent">
                                <!-- <tr> <td>1, 0</td> <td>2, 0</td> <td>3, 0</td> </tr> -->
                               
                        </tbody>
                    </table>
                    
                </div>

                
            </div>
            
            <div id = "mapholder"> 
        		<div id = "map" style="height:100%; width:100%;"></div>
        	</div>

            <div class = "dropdown" id = "dropdown">
                
                    <h2>Sort by:</h2>
                    <button class = "dbtn">City Name A-Z</button>
                    <div class = "options">
                        <h3 class = "op" onclick="sortName()">City Name A-Z</h3>
                        <h3 class = "op" onclick="sortNameD()">City Name Z-A</h3>
                        <h3 class = "op" onclick="sortTempLow()">Temp. Low ASC</h3>
                        <h3 class = "op" onclick = "sortTempLowD()">Temp. Low DESC</h3>
                        <h3 class = "op" onclick = "sortTempHigh()">Temp. High ASC</h3>
                        <h3 class = "op" onclick = "sortTempHighD()">Temp. High DESC</h3>
                    </div>
            </div>
            
        </div>
    </body>
    
    <script src="script.js"></script>
    <script>
        
    var Cities = new Array();
	<%-- <% for(int i = 0; i < w.cities.size(); i++){ %>
		Cities.push("<%=w.cities.get(i).getCity()%>");
	<%}%> --%>
	
	var Coord = new Array();
	
		<%-- <% for(int i = 0; i < w.cities.size(); i++){ %>
		Coord.push([parseFloat(<%=w.cities.get(i).getLatitude()%>),parseFloat(<%=w.cities.get(i).getLongitude()%>)]);
		<%}%> --%>
		
		
		function citysearch(){
	   		let city = document.getElementById("cityinput2").value;
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
            document.getElementById("cityinput2").hidden = false;
            document.getElementById("cityclick").hidden = false;

            document.getElementById("locclick").hidden = true;
            document.getElementById("li1").hidden = true;
            document.getElementById("li2").hidden = true;
            document.getElementById("google").hidden = true;
        }
        function loc(){
            document.getElementById("locclick").hidden = false;
            document.getElementById("li1").hidden = false;
            document.getElementById("li2").hidden = false;

            document.getElementById("cityinput2").hidden = true;
            document.getElementById("cityclick").hidden = true;
            document.getElementById("google").hidden = false;
            
        }

        function goToHome(){
            window.location = "index.jsp";
        }
        
       let name = "";
       let tr;
       let td1;
       sortName();
       assign();
       
       function assign(){
    	   var table = document.getElementById("table1"),rIndex,cIndex;
           for(var i = 1; i < table.rows.length; i++){ 
        	   name = table.rows[i].cells[0].innerHTML;
        	   table.rows[i].cells[0].onclick = function(){
        		   advance(this.id);
        	   }
           }
       }
       
       
       if(<%=cities.size()%> <= 1){
    	   document.getElementById("dropdown").style.display = "none";
    	   document.getElementById("allcities").style.display = "none";
       }
       
       function sortTempHigh(){
    	   clear();
    	   var table = document.getElementById("")
    	   <% for(int i = 0; i < byTempHigh.size(); i++){ %>
           
	        tr = document.createElement("tr");
	    	
	        td1 = document.createElement("td");
	    	td1.innerHTML = "<%= byTempHigh.get(i).getCity() %>" + ", " + "<%= byTempHigh.get(i).getCountry() %>" ;

	    	td1.setAttribute("id", "<%= byTempHigh.get(i).getId() %>");
	    	
	    	
	    	tr.appendChild(td1);
	    	
	    	td1 = document.createElement("td");
	    	td1.innerHTML = "<%= byTempHigh.get(i).getDayLow() %>";	
	    	tr.appendChild(td1);
	    	
	    	td1 = document.createElement("td");
	    	td1.innerHTML = "<%= byTempHigh.get(i).getDayHigh() %>";	
	    	tr.appendChild(td1);
	    		    	
	    	document.getElementById('tablecontent').appendChild(tr);   	
	    	assign();
       
       	<%}%>
       }
       
       function sortTempHighD(){
    	   clear();
    	   <% for(int i = 0; i < byTempHighD.size(); i++){ %>
           
	        tr = document.createElement("tr");
	    	
	        td1 = document.createElement("td");
	    	td1.innerHTML = "<%= byTempHighD.get(i).getCity() %>" + ", " + "<%= byTempHighD.get(i).getCountry() %>";	
	    	
	    	td1.setAttribute("id", "<%= byTempHighD.get(i).getId() %>");
	    	
	    	tr.appendChild(td1);
	    	
	    	td1 = document.createElement("td");
	    	td1.innerHTML = "<%= byTempHighD.get(i).getDayLow() %>";	
	    	tr.appendChild(td1);
	    	
	    	td1 = document.createElement("td");
	    	td1.innerHTML = "<%= byTempHighD.get(i).getDayHigh() %>";
	    	
	    	
	    	
	    	tr.appendChild(td1);
	    		    	
	    	document.getElementById('tablecontent').appendChild(tr);  
	    	assign();
      
      	<%}%>
       }
       
       function sortTempLow(){
    	   clear();
    	   <% for(int i = 0; i < byTempLow.size(); i++){ %>
           
	        tr = document.createElement("tr");
	    	
	        td1 = document.createElement("td");
	    	td1.innerHTML = "<%= byTempLow.get(i).getCity() %>" + ", " + "<%= byTempLow.get(i).getCountry() %>";

	    	td1.setAttribute("id", "<%= byTempLow.get(i).getId() %>");
	    	
	    	tr.appendChild(td1);
	    	
	    	td1 = document.createElement("td");
	    	td1.innerHTML = "<%= byTempLow.get(i).getDayLow() %>";	
	    	tr.appendChild(td1);
	    	
	    	td1 = document.createElement("td");
	    	td1.innerHTML = "<%= byTempLow.get(i).getDayHigh() %>";	
	    	tr.appendChild(td1);
	    		    	
	    	document.getElementById('tablecontent').appendChild(tr);   	
	    	assign();
      
      	<%}%>
       }
       
       function sortTempLowD(){
    	   clear();
    	   <% for(int i = 0; i < byTempLowD.size(); i++){ %>
           
	        tr = document.createElement("tr");
	    	
	        td1 = document.createElement("td");
	    	td1.innerHTML = "<%= byTempLowD.get(i).getCity() %>" + ", " + "<%= byTempLowD.get(i).getCountry() %>";	
	    	
	    	td1.setAttribute("id", "<%= byTempLowD.get(i).getId() %>");
	    	
	    	tr.appendChild(td1);
	    	
	    	td1 = document.createElement("td");
	    	td1.innerHTML = "<%= byTempLowD.get(i).getDayLow() %>";	
	    	tr.appendChild(td1);
	    	
	    	td1 = document.createElement("td");
	    	td1.innerHTML = "<%= byTempLowD.get(i).getDayHigh() %>";	
	    	tr.appendChild(td1);
	    		    	
	    	document.getElementById('tablecontent').appendChild(tr);   	
	    	assign();
     
     	<%}%>
       }
       function sortName(){
    	   clear();
    	   <% for(int i = 0; i < byName.size(); i++){ %>
           
	        tr = document.createElement("tr");
	    	
	        td1 = document.createElement("td");
	        td1.onclick = "test()";
	    	td1.innerHTML = "<%= byName.get(i).getCity() %>" + ", " + "<%= byName.get(i).getCountry() %>";		
	    	td1.setAttribute("id", "<%= byName.get(i).getId() %>");
	    	
	    	tr.appendChild(td1);
	    	
	    	td1 = document.createElement("td");
	    	td1.innerHTML = "<%= byName.get(i).getDayLow() %>";	
	    	tr.appendChild(td1);
	    	
	    	td1 = document.createElement("td");
	    	td1.innerHTML = "<%= byName.get(i).getDayHigh() %>";	
	    	tr.appendChild(td1);
	    		    	
	    	document.getElementById('tablecontent').appendChild(tr);   
	    	assign();
     
     	<%}%>
       }
       function sortNameD(){
    	   clear();
    	   <% for(int i = 0; i < byNameD.size(); i++){ %>
           
	        tr = document.createElement("tr");
	    	
	        td1 = document.createElement("td");
	    	td1.innerHTML = "<%= byNameD.get(i).getCity() %>" + ", " + "<%= byNameD.get(i).getCountry() %>";	
	    	td1.setAttribute("id", "<%= byNameD.get(i).getId() %>");
	    	tr.appendChild(td1);
	    	
	    	td1 = document.createElement("td");
	    	td1.innerHTML = "<%= byNameD.get(i).getDayLow() %>";	
	    	tr.appendChild(td1);
	    	
	    	td1 = document.createElement("td");
	    	td1.innerHTML = "<%= byNameD.get(i).getDayHigh() %>";	
	    	tr.appendChild(td1);
	    		    	
	    	document.getElementById('tablecontent').appendChild(tr); 
	    	assign();
    
    	<%}%>
       }
       
       
        function clear(){
        	var Table = document.getElementById("tablecontent");
        	Table.innerHTML = "";
        }
        
        function advance(name){
        	window.location = 'individual.jsp?cityname=' + name;
        }
        
        
        

    </script>
    <script>
	//Key is expired
  	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAS8&callback=initMap" async defer>
	</script>
</html>