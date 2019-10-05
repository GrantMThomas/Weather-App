package weather;

import java.util.List;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;


public class WtJson {

@SerializedName("coord")
@Expose
private Coordinate coord;
@SerializedName("weather")
@Expose
private List<Weath> weather = null;
@SerializedName("base")
@Expose
private String base;
@SerializedName("main")
@Expose
private Main main;
@SerializedName("wind")
@Expose
private Wind wind;
@SerializedName("clouds")
@Expose
private Clouds clouds;
@SerializedName("dt")
@Expose
private Integer dt;
@SerializedName("sys")
@Expose
private Sys sys;
@SerializedName("id")
@Expose
private Integer id;
@SerializedName("name")
@Expose
private String name;
@SerializedName("cod")
@Expose
private Integer cod;

public Coordinate getCoord() {
return coord;
}

public void setCoord(Coordinate coord) {
this.coord = coord;
}

public List<Weath> getWeather() {
return weather;
}

public void setWeather(List<Weath> weather) {
this.weather = weather;
}

public String getBase() {
return base;
}

public void setBase(String base) {
this.base = base;
}

public Main getMain() {
return main;
}

public void setMain(Main main) {
this.main = main;
}

public Wind getWind() {
return wind;
}

public void setWind(Wind wind) {
this.wind = wind;
}

public Clouds getClouds() {
return clouds;
}

public void setClouds(Clouds clouds) {
this.clouds = clouds;
}

public Integer getDt() {
return dt;
}

public void setDt(Integer dt) {
this.dt = dt;
}

public Sys getSys() {
return sys;
}

public void setSys(Sys sys) {
this.sys = sys;
}

public Integer getId() {
return id;
}

public void setId(Integer id) {
this.id = id;
}

public String getName() {
return name;
}

public void setName(String name) {
this.name = name;
}

public Integer getCod() {
return cod;
}

public void setCod(Integer cod) {
this.cod = cod;
}

}