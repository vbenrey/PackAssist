// ignore_for_file: curly_braces_in_flow_control_structures, empty_statements

import 'package:http/http.dart' as http;
import 'dart:convert';

//this is for the api calls
//this is for geolocator only
class Location {
  //cityname
  final String name;
  final String country;
  //gets the full name of the address ex: angeles city (pampanga), pampanga is the admin1
  final String? admin1;
  final double latitude;
  final double longitude;

  Location({
    required this.name,
    required this.country,
    this.admin1,
    required this.latitude,
    required this.longitude,
  });

  //sets weather results into a json file
  //factory is more flexible
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      //city name
      name: json['name'],
      country: json['country'],
      //this is the full name of the address ex: angeles city (pampanga), pampanga is the admin1
      admin1: json['admin1'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }

  //get full address of city
  String get fullName {
    String? completeAdd = "";
    //if admin is not null, iassign ung buong name like Mexico City, pampanga
    if (admin1 != null) {
      completeAdd = ", $admin1";
    } else {
      //kung empty, blanko and city name lang madidisplay like Mexico City
      completeAdd = " ";
    }
    return "$name$completeAdd, $country";
  }
}
//starting here for weather lang sya, above is geolocator
// weather data class to hold weather info
class WeatherData {
  final double temperature;
  final int weatherCode;
  final double windSpeed;
  //probability of rain, snow, showers
  final double precipitationProbability;
  final double humidity;

  WeatherData({
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
    required this.precipitationProbability,
    required this.humidity,
  });

  //fetching data from api again like getCoords
  //this is a function that returns weather data ok?
  factory WeatherData.fromJson(Map<String, dynamic> json, index) {
    return WeatherData(
      //based sa meteo website, 2 meters above ground ung standard for getting temp
      //we convert it to respectives data types para mastore sya sa variables sa taas
      temperature: json["temperature_2m"][index].toDouble(),
      weatherCode: json["weather_code"][index].toInt(),
      windSpeed: json["wind_speed_10m"][index].toDouble(),
      precipitationProbability: json["precipitation_probability"][index].toDouble(),
      humidity: json['relative_humidity_2m'][index].toDouble()
    );
  }
}

//this is for weather
class WeatherUtility {
  static List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  //we use celsius and will convert later to fahrenheit
  static String getTemperatureCategory(double tempC) {
    if (tempC < 0)
      return "Freezing";
    else if (tempC < 10)
      return "Cold";
    else if (tempC < 20)
      return "Cool";
    else if (tempC < 30)
      return "Warm";
    else
      return "Hot";
  }
}

//functions for getting weather data
//location objects to, results will be stored in the location variables
//hindi asap nafefech ng api ung data, so u cna use the app WHILE it fetches at hndi mag freeze,
//it assigns future so app is usable habang nagwawait
Future<List<Location>> getCoords(String city) async {
  //remove the null
  final cityName = city.trim();
  //fetch long lat based on city name
  final uri = Uri.https("geocoding-api.open-meteo.com", "/v1/search", {
    //city name
    "name": cityName,
    //only fetches 10 similarly named cities to whatever user searched
    //if user searched angeles only, itll list angeles us, angeles ph, etc
    "count": "10",
    //english lang
    "language": "en",
    //results is in json format
    "format": "json",
  });
  //fetches meteo's geolocator api call
  final response = await http.get(uri);
  //200 means successful sya, nakapagconnect sa api pero if not, itll just return nthing
  //ung nakita na return []
  if (response.statusCode == 200) {
    //decodes json into map string
    final data = json.decode(response.body);
    //if the data is not empty
    if (data["results"] != null && data["results"].isNotEmpty) {
      //store results in map
      final results = List<Map<String, dynamic>>.from(data["results"]);
      //return map
      //instead of doing this name = getCoords(name) per variable, u do this shortcut
      return results.map(Location.fromJson).toList();
    }
  }
  //return nothing if nagkaerror sa connection
  return [];
}

// getting the weather data based on coordinates we gave it
// tho this is only for current date
// nullchecker kasi nageeror sya if wala ?
Future<WeatherData?> getWeather(double latitude, double longitude, String start, String end) async {
  final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
    'latitude': latitude.toString(),
    'longitude': longitude.toString(),
    'current_weather': 'true',
    //nakastore sa hourly ung temperature 2m above ground level, weather, windspeed, chance of rain/snow/showers
    'hourly': 'temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m,precipitation_probability',
    'timezone': 'auto',
    //for meteo free version, it can only predict up to 16 days from now, so yan na ung max
    'start_date': start,
    'end_date': end,
  });
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    //decodes json into string map
    final data = json.decode(response.body) as Map<String, dynamic>;
    //hourly is the temp, windspeed, precipitation
    final hourly = data['hourly'];
    //we store the values per day in a list
    List temps = hourly['temperature_2m'];
    List wind = hourly['wind_speed_10m'];
    List precipitation = hourly['precipitation_probability'];
    List humidity = hourly['relative_humidity_2m'];

    double avgTemp = averageCounter(temps);
    double avgWind = averageCounter(wind);
    double avgPrecipitation = averageCounter(precipitation);
    double avgHumidity = averageCounter(humidity);

    // Pick a representative weather code (like the mode or last one)
    int weatherCode = hourly['weather_code'].first.toInt();
    //return them na
    return WeatherData(
      temperature: avgTemp,
      weatherCode: weatherCode,
      windSpeed: avgWind,
      precipitationProbability: avgPrecipitation,
      humidity: avgHumidity
    );
  }
  return null;
}

//this is for wind speeds, if windy ung location
String getWindDescription(num windSpeed) {
  if (windSpeed < 5) return "Calm Winds";
  if (windSpeed < 15) return "Light Winds";
  if (windSpeed < 25) return "Moderate Winds";
  if (windSpeed < 35) return "Strong Winds";
  if (windSpeed < 50) return "Harsh Winds";
  return "Extreme Winds";
}

//this is for weather classifications based on meteo's WMO Weather Interpretation codes
String getWeatherClassification(int weatherCode) {
  String weather = "";
  switch (weatherCode) {
    case 0: weather = "Clear Sky"; break;
    case 1: weather = "Mainly Clear"; break;
    case 2: weather = "Partially Cloudly"; break;
    case 3: weather = "Cloudy"; break;
    //regular fog
    case 45: weather = "Fog"; break;
    //icy and super cold fog
    case 48: weather = "Depositing Rime Fog"; break;
    case 51: weather = "Light Drizzle"; break;
    case 53: weather = "Moderate Drizzle"; break;
    case 55: weather = "Dense Drizzle"; break;
    case 56: weather = "Light Freezing Drizzle"; break;
    case 57: weather = "Dense Freezing Drizzle"; break;
    case 61: weather = "Slight Rain"; break;
    case 62: weather = "Moderate Rain"; break;
    case 63: weather = "Heavy Rain"; break;
    //wet raindrops, but when it touches ground it becomes ice
    case 66: weather = "Light Freezing Rain"; break;
    case 67: weather = "Heavy Freezing Rain"; break;
    case 71: weather = "Slight Snow Fall"; break;
    case 73: weather = "Moderate Snow Fall"; break;
    case 75: weather = "Heavy Snow Fall"; break;
    case 77: weather = "Snow Grains"; break;
    case 80: weather = "Slight Rain Showers"; break;
    case 81: weather = "Moderate Rain Showers"; break;
    case 82: weather = "Violent Rain Showers"; break;
    case 85: weather = "Slight Snow Showers"; break;
    case 86: weather = "Heavy Snow Showers"; break;
    case 95: weather = "Thunderstorm"; break;
    case 96: weather = "Thunderstorm with Light Hail"; break;
    case 99: weather = "Thunderstorm with Heavy Hail"; break;
    default: return "Unknown Weather";
  }
  return weather;
}

//for conversion, celsius to fahrenheit
double? convert(double celsius) {
  return (celsius * 1.8) + 32;
}

List<String> getDates (String start, String end) {
  DateTime startTime = DateTime.parse(start);
  DateTime endTime = DateTime.parse(end);
  List<String> dateList = [];
  while (!startTime.isAfter(endTime)) {
    String date = "${startTime.year}-${startTime.month}-${startTime.day}";
    dateList.add(date);
    startTime = startTime.add(Duration(days: 1));
  }
  return dateList;
}

dynamic getMode (List<dynamic> searchList) {
  Map <dynamic, int> counter = {};
  for (var value in searchList) {
    counter[value] = (counter[value] ?? 0) + 1;
  }
  dynamic mode = searchList[0];
  int maxCount = 0;
  counter.forEach((key, value) {
    if (value > maxCount) {
      maxCount = value;
      mode = key;
    }
  });
  return mode;
}

//average natin ung values HOURLY for that day only
//this is for the states, kasi nagnunull sya?? this removes the null and makes it only accept nonnull values
List<double> cleanList (List<dynamic> rawList) {
  List<double> fixList = [];
  for (var item in rawList) {
    if (item != null) {
      fixList.add(item.toDouble());
    }
  }
  return fixList;
}

double averageCounter (List<dynamic> messy) {
  double average = cleanList(messy).reduce((a, b) => a + b) / cleanList(messy).length;
  return average;
}

int weatherClassifier (dynamic weatherCode, String tempClassification, String windClassification, double humid) {
  List<int> rainy = [51, 53, 55, 61, 62, 63, 80, 81, 82, 95];
  List<int> clear = [0, 1, 2, 3, 45, 48];
  List<int> snowy = [56, 57, 66, 67, 71, 73, 75, 77, 85, 86, 96, 99];
  if (rainy.contains(weatherCode)) {
    return 2;
  } else if (snowy.contains(weatherCode)) {
    return 3;
  } else if (clear.contains(weatherCode)) {
    if (tempClassification == "Hot") {
      return 1;
    } else if (tempClassification == "Freezing" || tempClassification == "Cold") {
      return 3;
    } else if (windClassification == "Strong Winds" || windClassification == "Harsh Winds" || windClassification == "Extreme Speeds") {
      return 4;
    } else if (humid >= 70) {
      return 5;
    } else if (humid < 30) {
      return 6;
    } else {
      return 7;
    }
  } return 0;
}
