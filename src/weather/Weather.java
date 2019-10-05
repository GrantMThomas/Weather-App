package weather;
import java.util.ArrayList;
import java.util.Comparator;

public class Weather {
	private String city;
	private String state; //
	private String country; //
	private double latitude; //
	private double longitude; //
	private String srTime; //
	private String ssTime; //
	private double currentTemperature;
	private double dayLow;
	private double dayHigh;
	private int humidity;
	private float pressure;
	private float visibility;
	private float windspeed;
	private int windDirection;
	private int id;
	private ArrayList<String> conditionDescription = new ArrayList<String>();
	
	
	public void setId(int id) {
		this.id = id;
	}
	public int getId() {
		return this.id;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	////////
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	
	public double getLatitude() {
		return latitude;
	}
	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}
	
	public double getLongitude() {
		return longitude;
	}
	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}
	
	public String getSrTime() {
		return srTime;
	}
	public void setSrTime(String srTime) {
		this.srTime = srTime;
	}
	
	public String getSsTime() {
		return ssTime;
	}
	public void setSsTime(String ssTime) {
		this.ssTime = ssTime;
	}
	////////
	
	public double getCurrentTemperature() {
		return currentTemperature;
	}
	public void setCurrentTemperature(double currentTemperature) {
		this.currentTemperature = currentTemperature;
	}
	public double getDayLow() {
		return dayLow;
	}
	public void setDayLow(double dayLow) {
		this.dayLow = dayLow;
	}
	public double getDayHigh() {
		return dayHigh;
	}
	public void setDayHigh(double dayHigh) {
		this.dayHigh = dayHigh;
	}
	public int getHumidity() {
		return humidity;
	}
	public void setHumidity(int humidity) {
		this.humidity = humidity;
	}
	public float getPressure() {
		return pressure;
	}
	public void setPressure(float pressure) {
		this.pressure = pressure;
	}
	public float getVisibility() {
		return visibility;
	}
	public void setVisibility(float visibility) {
		this.visibility = visibility;
	}
	public float getWindspeed() {
		return windspeed;
	}
	public void setWindspeed(float windspeed) {
		this.windspeed = windspeed;
	}
	public int getWindDirection() {
		return windDirection;
	}
	public void setWindDirection(int windDirection) {
		this.windDirection = windDirection;
	}
	public ArrayList<String> getConditionDescription() {
		return conditionDescription;
	}
	
	public static Comparator<Weather> byTempHigh = new Comparator<Weather>() {

		@Override
		public int compare(Weather o1, Weather o2) {
			double t1 = o1.getDayHigh();
			double t2 = o2.getDayHigh();
			
			return (int) (t1-t2);
			
		}
		
	};
	public static Comparator<Weather> byTempHighD = new Comparator<Weather>() {

		@Override
		public int compare(Weather o1, Weather o2) {
			double t1 = o1.getDayHigh();
			double t2 = o2.getDayHigh();
			
			return (int) (t2-t1);
			
		}
		
	};
	
	public static Comparator<Weather> byTempLow = new Comparator<Weather>() {

		@Override
		public int compare(Weather o1, Weather o2) {
			double t1 = o1.getDayLow();
			double t2 = o2.getDayLow();
			
			return (int) (t1-t2);
			
		}
		
	};
	
	public static Comparator<Weather> byTempLowD = new Comparator<Weather>() {

		@Override
		public int compare(Weather o1, Weather o2) {
			double t1 = o1.getDayLow();
			double t2 = o2.getDayLow();
			
			return (int) (t2-t1);
			
		}
		
	};
	
	public static Comparator<Weather> byName = new Comparator<Weather>() {

		@Override
		public int compare(Weather o1, Weather o2) {
			String t1 = o1.getCity().toUpperCase();
			String t2 = o2.getCity().toUpperCase();			
			return t1.compareTo(t2);
			
		}
		
	};
	
	public static Comparator<Weather> byNameD = new Comparator<Weather>() {

		@Override
		public int compare(Weather o1, Weather o2) {
			String t1 = o1.getCity().toUpperCase();
			String t2 = o2.getCity().toUpperCase();			
			return t2.compareTo(t1);
			
		}
		
	};
	
}
