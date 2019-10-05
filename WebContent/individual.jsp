<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ page import="weather.WeatherReader" %>
  <%@ page import="weather.Weather" %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.util.ArrayList" %>
<%@ page import = "java.util.Collections" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.io.BufferedReader" %>
<%@ page import = "java.io.InputStreamReader" %>
<%@ page import="weather.WtJson" %>
<%@ page import = "com.google.gson.*" %>
<%@ page import = "java.io.PrintWriter" %>
    
<% 

String username = (String)session.getAttribute("username");
String password = (String)session.getAttribute("password");

session.setAttribute("username", username);
session.setAttribute("password",password);

String city = request.getParameter("cityname");

if(city == null || city == ""){
	city = "";
}

String input = "http://api.openweathermap.org/data/2.5/weather?id=" + city +"&units=imperial&APPID=8f727ee320b1e83cccf26f96f2a48971";
URL url = new URL(input);

HttpURLConnection conn = (HttpURLConnection) url.openConnection();
conn.setRequestMethod("GET");
int code = conn.getResponseCode();
System.out.println(code);
if(code != 200){
	PrintWriter o = response.getWriter();	
	o.println("<script> alert('Invalid city') </script>");
	
}

BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
String resp = br.readLine();

WtJson wtjson = new Gson().fromJson(resp, WtJson.class);


//WeatherReader w = new WeatherReader();
//w.parseFile();

Weather c = new Weather();
c.setCity(wtjson.getName());
c.setCountry(wtjson.getSys().getCountry());
System.out.println(wtjson.getSys().getMessage());
c.setDayLow(wtjson.getMain().getTempMin());
c.setDayHigh(wtjson.getMain().getTempMax());
c.setId(wtjson.getId());
double speed = wtjson.getWind().getSpeed();
float f = (float)speed;
c.setWindspeed(f);
c.setHumidity(wtjson.getMain().getHumidity());
c.setLatitude(wtjson.getCoord().getLat());
c.setLongitude(wtjson.getCoord().getLon());
c.setCurrentTemperature(wtjson.getMain().getTemp());
c.setSrTime(wtjson.getSys().getSunrise() + "");
c.setSsTime(wtjson.getSys().getSunset() + "");




%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Weather</title>
        
        
        <link rel="stylesheet" href="style.css">
        <style>
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
           <!--  <form>             
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
				 <input type = "text" class = "locinput l2" id = "li1" placeholder = "Lat." name = "latinput">
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
        
        <div class="main icons">
                <h1>
                        <%= c.getCity() %>
                    </h1>
            <table id = "maintable">
                <tr>
                    <th>
                        <div class = "rtextdiv" id="one" onclick = "hide(this, 0)">
                            
                            <h3 class = "rtext" ><%=c.getCountry() %></h3>
                        </div>
                        <h3>Location</h3>
                    </th>
                    <th>
                        <div class = "rtextdiv" id = "two" onclick = "hide(this, 1)">
                            <h3 class = "rtext"><%= c.getDayLow() + " degrees Fahrenheit" %></h3>
                        </div>
                        <h3>Temp Low</h3> 
                    </th>
                    <th>

                        <div class = "rtextdiv" id="three" onclick = "hide(this, 2)">
                            <h3 class = "rtext"><%= c.getDayHigh() + " degrees Fahrenheit" %></h3>
                        </div>
                        <h3>Temp High</h3>
                    </th>
                    <th>
                        <div class = "rtextdiv" id="four" onclick = "hide(this, 3)">
                                <h3 class = "rtext"><%= c.getWindspeed() + " miles/hour" %></h3>
                        </div>
                        <h3>Wind</h3>  
                    </th>
                </tr>

                <tr>
                    <th>
                        <!-- <img class = "img" src = "images/drop.png"> -->
                        <div class = "rtextdiv" id="five" onclick = "hide(this, 4)">
                            <h3 class = "rtext"> <%= c.getHumidity() + "%" %> </h3>
                        </div>
                        <h3>Humidity</h3>   
                    </th>
                    <th>
                        <div class = "rtextdiv" id="six" onclick = "hide(this, 5)">
                            <h3 class = "rtext"><%= c.getLatitude() + ", " + c.getLongitude() %></h3>
                        </div>
                        <h3>Coordinates</h3>    
                    </th>
                    <th>
                        <div class = "rtextdiv" id="seven" onclick = "hide(this, 6)">
                            <h3 class = "rtext"><%= c.getCurrentTemperature() + " degrees Fahrenheit" %></h3>
                        </div>
                        <h3>Current Temp</h3>  
                    </th>
                    <th>
                        <div class = "rtextdiv" id="eight" onclick = "hide(this, 7)">
                            <h3 class = "rtext"> <%= c.getSrTime() +", " + c.getSsTime() %> </h3>
                        </div>
                        <h3>Sunrise/set</h3>  
                    </th>
                </tr>
            </table>
            
            <div id = "mapholder"> 
        		<div id = "map" style="height:100%; width:100%;"></div>
        	</div>
                   
            </div>
       
    </body>

	<script src="script.js"></script>
    <script>
    


        let array = new Array();
        for(let i = 0; i < 8; i++){
            array.push(true);
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
        function hide(element, index){
            if(array[index]){
                element.style.backgroundSize = '0';
                element.querySelector('.rtext').style.visibility = "visible";
                array[index] = false;
            }
            else{
                element.style.backgroundSize = 'contain';
                element.querySelector('.rtext').style.visibility = "hidden";
                array[index] = true;
            }
            
       
        }

        function show(id){
            document.getElementById(id).style.backgroundSize = 'contain';

            document.getElementById(id).querySelector('.rtext').style.visibility = "hidden";
        }
        

 

        

    </script>
    
    <script 
  	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAS8H7kq0xX5QNOzv__yFrBtqdURhP2zHA&callback=initMap" async defer>
	</script>
</html>