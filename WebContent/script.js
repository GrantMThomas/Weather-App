 
function ajax(endpoint, _callback){
    let xhr = new XMLHttpRequest();
    

    xhr.open("GET",endpoint);
    xhr.send();

    xhr.onreadystatechange = function(){     
        if(this.readyState == this.DONE){
            if(xhr.status == 200){
                //Got a successful resonse
                console.log(xhr.responseText);

                //Convert the response JSON string to JS objects
                let responseObjects = JSON.parse(xhr.responseText);
                _callback(xhr.responseText);
                //return xhr.responseText;
            }
            else {
            	_callback("");
                console.log("Error");
                console.log(xhr.status);
                
            }
        }
    }  
}

function initMap() {
	var myLatlng = {lat: -25.363, lng: 131.044};
    map = new google.maps.Map(document.getElementById('map'), {
      center: {lat: 0, lng: 0},
      zoom: 8
    });
    console.log(map);
    
    map.addListener('click', function(e) {
       	var lat = e.latLng.lat();
       	var lon = e.latLng.lng();
       	lat = lat.toFixed(2);
       	lon = lon.toFixed(2);
       	
       	document.getElementById("li1").value = lat;
       	document.getElementById("li2").value = lon;
       	document.getElementById("mapholder").style.display = "none";
       	
     });
          
}


function lsearch(){
	let lat = parseFloat(document.getElementById("li1").value);
	let lon = parseFloat(document.getElementById("li2").value);
	
	if(!(lat >= -180 && lat <= 180 && lon >= -180 && lon <= 180)){
		alert("Invalid latitude");
		return false;
	}
	else if(lat == "" || lon == ""){
		alert("Enter value for latitude and longitude");
		return false;
	}
}

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

function mp() {
	document.getElementById("mapholder").style.display = "block";
}

function login(){
	window.location = "login.jsp";
}

function goToHome(){
    window.location = "index.jsp";
}
function signup(){
	window.location = "signup.jsp";
}

function signout(){
	window.location="index.jsp?signout=true";
}
function prof(){
	window.location = "history.jsp";
}

