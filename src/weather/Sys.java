package weather;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class Sys {

@SerializedName("message")
@Expose
private Double message;
@SerializedName("sunrise")
@Expose
private Integer sunrise;
@SerializedName("sunset")
@Expose
private Integer sunset;
@SerializedName("country")
@Expose
private String country;

public void setCountry(String country) {
	this.country = country;
}
public String getCountry() {
	return country;
}

public Double getMessage() {
return message;
}

public void setMessage(Double message) {
this.message = message;
}

public Integer getSunrise() {
return sunrise;
}

public void setSunrise(Integer sunrise) {
this.sunrise = sunrise;
}

public Integer getSunset() {
return sunset;
}

public void setSunset(Integer sunset) {
this.sunset = sunset;
}

}