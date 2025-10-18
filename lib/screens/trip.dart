import 'package:flutter/material.dart';
import 'package:packassist/screens/scaffoldShow.dart';
import 'package:packassist/screens/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:packassist/screens/functions.dart';

class Trip extends StatefulWidget {
  const Trip({super.key});

  @override
  State<Trip> createState() => _TripState();
}

class _TripState extends State<Trip> {
  final TextEditingController _controller = TextEditingController();
  final supabase = Supabase.instance.client;
  String? userID;
  String cityName = "Search City...";
  String displayCity = "";

  //date time stuff
  DateTime? selectedDate;
  //placeholder
  String startDate = "Select Date...";
  //placeholder
  String endDate = "Select Date...";

  //long lat for city
  double lat = 0;
  double long = 0;

  //holding the averages
  double avgWind = 0;
  double avgTemp = 0;
  double avgHumidity = 0;
  double avgPrecipitation = 0;
  String modeWeather = "";
  String modeSpeed = "";
  int modeWeatherCode = 0;

  //list holding the values
  List<String> dateRange = [];
  List<double> temperatures = [];
  List<String> tempClass = [];
  List<String> weathers = [];
  List<int> weatherCodes = [];
  List<double> humidities = [];
  List<double> precipitationChances = [];
  List<double> windSpeed = [];
  List<String> windClassification = [];

  //holds what the weather recommendation code to database
  int? weatherID;
  dynamic travelID = 0;

  //for ui purposes
  String showWeatherList = "hide";
  String buttonText = "Enter";
  List<String> purposeList = ["Vacation", "Work", "Personal"];
  String chosenPurpose = "";
  int selectedIndex = -1;

  void getCity(String city) {
    //gets the coords of the input and stores the cities with the parameter string in a list
    getCoords(city).then((List<Location> locations) {
      setState(() {
        if (locations.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "Search Results for: $city",
                  style: TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 76, 103, 76),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Crimson",
                  ),
                ),
                content: SizedBox(
                  height: 300,
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(locations[index].fullName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: "Crimson",
                                color: black
                            )),
                        onTap: () {
                          setState(() {
                            setState(() {
                              // data pass happens here
                              cityName = locations[index].fullName;
                              //gets the weather per index (long lat)
                              getWeather(
                                locations[index].latitude,
                                locations[index].longitude,
                                startDate,
                                endDate,
                              );
                              lat = locations[index].latitude;
                              long = locations[index].longitude;
                              //if the values are null, then display nothing and pop out
                              Navigator.pop(context);
                              _controller.clear();
                            });
                          });
                        },
                      );
                    },
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _controller.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(50, 40),
                      backgroundColor: darkgreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontSize: 15, color: whitish, fontFamily: "Crimson",),
                    ),
                  ),
                ],
              );
            },
          );
          //if user input is empty
        }
        else if (city.trim().isEmpty) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "Error",
                  style: TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 76, 103, 76),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Crimson",
                  ),
                ),
                content: Text("Please enter a City Name.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: "Crimson",
                        color: black
                    )),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _controller.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(50, 40),
                      backgroundColor: darkgreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Confirm",
                      style: TextStyle(fontSize: 15, color: whitish, fontFamily: "Crimson",),
                    ),
                  ),
                ],
              );
            },
          );
          //invalid input, gibberish
        }
        else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "Search Results for: $city",
                  style: TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 76, 103, 76),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Crimson",
                  ),
                ),
                content: Text(
                    "No results found for '$city'",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: "Crimson",
                        color: black
                    )),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _controller.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(50, 40),
                      backgroundColor: darkgreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Confirm",
                      style: TextStyle(fontSize: 15, color: whitish, fontFamily: "Crimson",),
                    ),
                  ),
                ],
              );
            },
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void confirmTravel() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Travel Confirmation",
            style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 76, 103, 76),
              fontWeight: FontWeight.bold,
              fontFamily: "Crimson",
            ),
          ),
          content: Text(
            "Do you want to confirm and finalize this trip?",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontFamily: "Crimson",
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(50, 40),
                    backgroundColor: darkgreen,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: 15, color: whitish, fontFamily: "Crimson",),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    //add trip
                    final response = await supabase.from('travels').insert({
                      'location': cityName,
                      'date_start' : startDate,
                      'date_end' : endDate,
                      'user_id' : userID,
                      'purpose': chosenPurpose
                    }).select();
                    //add weather averages to the database
                    //fetch the travel id first
                    travelID = response[0]['travel_id'];
                    final modeTempClass = WeatherUtility.getTemperatureCategory(avgTemp);

                    //this is for adding the average for the entire trip to the database
                    //if the date is null, it means its for the entire trip
                    final responseWeather = await supabase.from('travel_weather').insert({
                      'travel_id': travelID,
                      'weather_id': weatherID,
                      'temperature': avgTemp,
                      'temp_classification': modeTempClass,
                      'wind_speed': avgWind,
                      'wind_classification': modeSpeed,
                      'humidity': avgHumidity,
                      'precipitation': avgPrecipitation,
                      'specific_weather': modeWeather,
                      'isAverage': true
                    });

                    //this is for adding the per day average for the entire trip to the database
                    for (int i = 0; i < dateRange.length; i++) {
                      if (dateRange[i].isNotEmpty) {
                        final int weatherclass = weatherClassifier(weatherCodes[i], tempClass[i], windClassification[i], humidities[i]);
                        print(weatherclass);
                        await supabase.from(
                            'travel_weather').insert({
                          'travel_id': travelID,
                          'weather_id': weatherclass,
                          'temperature': temperatures[i].toStringAsFixed(2),
                          'temp_classification': tempClass[i],
                          'wind_speed': windSpeed[i].toStringAsFixed(2),
                          'wind_classification': windClassification[i],
                          'humidity': humidities[i].toStringAsFixed(2),
                          'precipitation': precipitationChances[i]
                              .toStringAsFixed(2),
                          'specific_weather': weathers[i],
                          'date': dateRange[i],
                          'isAverage': false
                        });
                      }
                    }
                    print("hello");
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(context, '/addLuggage', (route) => false, arguments: travelID as int);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(50, 40),
                    backgroundColor: darkgreen,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Confirm",
                    style: TextStyle(fontSize: 15, color: whitish, fontFamily: "Crimson",),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  //date dropbox thing from flutter modules
  Future<void> _selectDate(String dateCat) async {
    dynamic pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      pickedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
      DateTime now = DateTime.now();
      now = DateTime(now.year, now.month, now.day);
      Duration difference = pickedDate.difference(now);
      if (difference.inDays > 14) {
        showSnackBar(context, "Date is too far to predict. Please choose a date less than or 14 days from now.");
      }
      else if (difference.inDays.isNegative) {
        showSnackBar(context, "Date chosen does not meet prediction range.");
      }
      else {
        setState(() {
          DateTime current = pickedDate;
          if (dateCat == "start") {
            startDate = "${current.year}-${current.month}-${current.day}";
          } else {
            if (startDate != "Select Date...") {
              DateTime start = DateTime.parse(startDate);
              if (start.compareTo(pickedDate) != 0) {
                if (start.isAfter(pickedDate)) {
                  showSnackBar(context, "End Date is before Start Date. Please enter a valid date range.");
                }
              }
              endDate = "${current.year}-${current.month}-${current.day}";
            }
          }
        });
      }
    }
  }

  Future<dynamic> getWeatherList(String name) async {
    dateRange = getDates(startDate, endDate);
    //make sure na walang old data na sasama
    temperatures.clear();
    weathers.clear();
    humidities.clear();
    precipitationChances.clear();
    windSpeed.clear();
    weatherCodes.clear();
    tempClass.clear();

    for (int i = 0; i < dateRange.length; i++) {
      final weatherData = await getWeather(lat, long, dateRange[i], dateRange[i]);
      if (weatherData != null) {
        temperatures.add(weatherData.temperature);
        weathers.add(getWeatherClassification(weatherData.weatherCode));
        weatherCodes.add(weatherData.weatherCode);
        humidities.add(weatherData.humidity);
        precipitationChances.add(weatherData.precipitationProbability);
        windSpeed.add(weatherData.windSpeed);
        windClassification.add(getWindDescription(windSpeed[i]));
        tempClass.add(WeatherUtility.getTemperatureCategory(temperatures[i]));
      }
    }
    setState(() {
      showWeatherList = "show";
      buttonText = "Resubmit";
      avgTemp = double.parse(averageCounter(temperatures).toStringAsFixed(2));
      avgHumidity = double.parse(averageCounter(humidities).toStringAsFixed(2));
      avgPrecipitation = double.parse(averageCounter(precipitationChances).toStringAsFixed(2));
      avgWind = double.parse(averageCounter(windSpeed).toStringAsFixed(2));
      modeWeather = getMode(weathers);
      modeSpeed = getMode(windClassification);
      modeWeatherCode = getMode(weatherCodes);
      weatherID = weatherClassifier(modeWeatherCode, WeatherUtility.getTemperatureCategory(avgTemp), modeSpeed, avgHumidity);
    });
    return [];
  }

  @override
  void initState() {
    super.initState();
    final current = supabase.auth.currentUser;
    if (current != null) {
      userID = current.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, size: 40, color: black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Text("Plan Travels",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: "Crimson",
                color: black
            )),
        backgroundColor: whitish,
        iconTheme: IconThemeData(
            size: 40,
            color: black
        ),
      ),
      drawer: Drawer(
        backgroundColor: black,
        child: Padding(
          padding: EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 30),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  flex: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.menu_rounded, size: 50, color: sand,)),
                      SizedBox(height: 10),
                      Text("PackAssist",
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold,
                            fontFamily: "Crimson", color: sand
                        ),),
                      SizedBox(height: 30),
                      Divider(
                        height: 4,
                        color: sand,
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: ()
                        {Navigator.pushNamed(context, '/home');},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("  Home",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold,
                                  fontFamily: "Crimson", color: sand
                              ),),
                            Icon(Icons.arrow_forward_ios_rounded, size: 20, color: sand, fontWeight: FontWeight.bold,)
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: ()
                        {Navigator.pushNamed(context, '/travel');},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("  Check Travels",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold,
                                  fontFamily: "Crimson", color: sand
                              ),),
                            Icon(Icons.arrow_forward_ios_rounded, size: 20, color: sand, fontWeight: FontWeight.bold,)
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: ()
                        {Navigator.pushNamed(context, '/profile');},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("  User Profile",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold,
                                  fontFamily: "Crimson", color: sand
                              ),),
                            Icon(Icons.arrow_forward_ios_rounded, size: 20, color: sand, fontWeight: FontWeight.bold,)
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: ()
                        {Navigator.pushNamed(context, '/about');},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("  About Us",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold,
                                  fontFamily: "Crimson", color: sand
                              ),),
                            Icon(Icons.arrow_forward_ios_rounded, size: 20, color: sand, fontWeight: FontWeight.bold,)
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: ()
                        {Navigator.pushNamed(context, '/tutorial');},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("  FAQ Page",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold,
                                  fontFamily: "Crimson", color: sand
                              ),),
                            Icon(Icons.arrow_forward_ios_rounded, size: 20, color: sand, fontWeight: FontWeight.bold,)
                          ],
                        ),
                      ),
                      SizedBox(height: 130),
                    ],
                  ),),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(onPressed: () {
                    //for signing out
                    Supabase.instance.client.auth.signOut();
                    Supabase.instance.client.auth.refreshSession();
                    Navigator.pushNamedAndRemoveUntil(context, '/preview', (route) => false);
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: sand,
                      minimumSize: Size(MediaQuery.widthOf(context), 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Log Out",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Crimson",
                          color: black,
                          fontSize: 25
                      ),),
                  ),),
                //Expanded(child: SizedBox(height: 50,)),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //user input form
                  Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: whitish,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(
                          offset: Offset(1, 5),
                          blurRadius: 10,
                          spreadRadius: 5,
                          color: Colors.black.withOpacity(.2)
                      )],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          "Enter City Name",
                          style: TextStyle(
                              fontFamily: "Crimson",
                              fontWeight: FontWeight.bold,
                              fontSize: 22
                          ),),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: _controller,
                                  decoration: InputDecoration(
                                      hintText: cityName,
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Crimson",
                                          fontSize: 17
                                      )
                                  ),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Crimson",
                                      color: black
                                  ),
                                )),
                            SizedBox(width: 10),
                            Expanded(child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    //pagkapindot, city name from textfield is passed to get weather na
                                    getCity(_controller.text);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(50, 55),
                                    backgroundColor: black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                ),
                                child: Text(
                                  "Search",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: whitish,
                                    fontSize: 18,
                                    fontFamily: "Crimson",
                                  ),
                                )))
                          ],
                        ),
                        SizedBox(height: 10),
                        //start date
                        Text(
                          "Select Start Date",
                          style: TextStyle(
                              fontFamily: "Crimson",
                              fontWeight: FontWeight.bold,
                              fontSize: 22
                          ),),
                        SizedBox(height: 5),
                        ElevatedButton(
                            onPressed: () {
                              _selectDate("start");
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              backgroundColor: Colors.grey[200],
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child:
                            Row(
                              children: [
                                Icon(Icons.calendar_month, color: sagegreen, size: 25,),
                                SizedBox(width: 20),
                                Text(
                                  startDate,
                                  style: TextStyle(fontSize: 17, color: Colors.grey[500], fontWeight: FontWeight.bold, fontFamily: "Crimson",),
                                ),
                              ],
                            )
                        ),
                        SizedBox(height: 10),
                        //end date
                        Text(
                          "Select End Date",
                          style: TextStyle(
                              fontFamily: "Crimson",
                              fontWeight: FontWeight.bold,
                              fontSize: 22
                          ),),
                        SizedBox(height: 5),
                        ElevatedButton(
                            onPressed: () {
                              _selectDate("end");
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              backgroundColor: Colors.grey[200],
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child:
                            Row(
                              children: [
                                Icon(Icons.calendar_month, color: sagegreen, size: 25,),
                                SizedBox(width: 20),
                                Text(
                                  endDate,
                                  style: TextStyle(fontSize: 17, color: Colors.grey[500], fontWeight: FontWeight.bold, fontFamily: "Crimson",),
                                ),
                              ],
                            )
                        ),
                        //travel purposes
                        SizedBox(height: 10),
                        Text(
                          "Travel Purposes",
                          style: TextStyle(
                              fontFamily: "Crimson",
                              fontWeight: FontWeight.bold,
                              fontSize: 22
                          ),),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedIndex = 0;
                                        chosenPurpose = purposeList[0];
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(50, 54),
                                        //if its 0 it becomes green, if not it stays gray
                                        backgroundColor: selectedIndex == 0 ? sage : Colors.grey[200],
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)
                                        )
                                    ),
                                    child: Text(
                                      purposeList[0],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: black,
                                        fontSize: 12,
                                        fontFamily: "Crimson",
                                      ),
                                    )),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedIndex = 1;
                                      chosenPurpose = purposeList[1];
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: Size(50, 54),
                                      backgroundColor: selectedIndex == 1 ? sage : Colors.grey[200],
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      )
                                  ),
                                  child: Text(
                                    purposeList[1],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: black,
                                      fontSize: 12,
                                      fontFamily: "Crimson",
                                    ),
                                  )),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedIndex = 2;
                                      chosenPurpose = purposeList[2];
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: Size(50, 54),
                                      backgroundColor: selectedIndex == 2 ? sage : Colors.grey[200],
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      )
                                  ),
                                  child: Text(
                                    purposeList[2],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: black,
                                      fontSize: 12,
                                      fontFamily: "Crimson",
                                    ),
                                  )),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                //pagkapindot, city name from textfield is passed to get weather na
                                setState(() {
                                  if (startDate == "Select Date..." || endDate == "Select Date..." || cityName == "Search City...") {
                                    showWeatherList = "hide";
                                    showSnackBar(context, "Please fill out the form.");
                                  } else {
                                    DateTime start = DateTime.parse(startDate);
                                    DateTime end = DateTime.parse(endDate);
                                    if(start.isAfter(end)) {
                                      showSnackBar(context, "End Date is before Start Date. Please enter a valid date range.");
                                    } else if (chosenPurpose.isEmpty) {
                                      showSnackBar(context, "Please state your Travel Purpose.");
                                    } else {
                                      showWeatherList = "wait";
                                      getWeatherList(cityName);
                                      displayCity = cityName;
                                    }
                                  }
                                });
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                                backgroundColor: black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                )
                            ),
                            child: Text(
                              buttonText,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: whitish,
                                fontSize: 17,
                                fontFamily: "Crimson",
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  if (showWeatherList == "hide")
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 70),
                          Container(
                            decoration: BoxDecoration(
                                color: whitish,
                                boxShadow: [BoxShadow(
                                    offset: Offset(1, 5),
                                    blurRadius: 10,
                                    spreadRadius: 5,
                                    color: Colors.black.withOpacity(.1)
                                )],
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Column(
                              children: [
                                Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                      color: sage,
                                    ),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      "Message",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: black,
                                        fontSize: 20,
                                        fontFamily: "Crimson",
                                      ),
                                    )),
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      "PackAssist can only return weather forecasts of the next 14 days. If your trip is not for another 14 days, come back later to check the forecast!",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: darkgreen,
                                        fontSize: 18,
                                        fontFamily: "Crimson",
                                      ),
                                    )
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  if (showWeatherList == "wait")
                    Column(
                      children: [
                        SizedBox(height: 100),
                        Text("Loading. Please wait...",
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: black,
                              fontFamily: "Crimson"
                          ),),
                        SizedBox(height: 25),
                        Center(child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(sage),
                        ),),
                      ],
                    ),
                  if (showWeatherList == "show")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          "NOTE: To finalize the trip, navigate to the bottom of the page and press the button.",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: grayblue,
                              fontFamily: "Crimson"
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: whitish,
                              boxShadow: [BoxShadow(
                                  offset: Offset(1, 5),
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                  color: Colors.black.withOpacity(.2)
                              )],
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Showing Weather Results for: ",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: black,
                                    fontFamily: "Crimson"
                                ),
                              ),
                              Text(
                                displayCity,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: sagegreen,
                                    fontFamily: "Crimson"
                                ),
                              ),
                              SizedBox(height: 5),
                              Divider(
                                thickness: 2,
                                color: Colors.grey[300],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Temperature ",
                                    style: TextStyle(
                                        fontFamily: "Crimson",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: darkgreen
                                    ),
                                  ),
                                  Text(
                                    "$avgTemp°C | ${WeatherUtility.getTemperatureCategory(avgTemp)}",
                                    style: TextStyle(
                                        fontFamily: "Crimson",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: sagegreen
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Common Weather: ",
                                    style: TextStyle(
                                        fontFamily: "Crimson",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: darkgreen
                                    ),
                                  ),
                                  Text(
                                    "$modeWeather",
                                    style: TextStyle(
                                        fontFamily: "Crimson",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: sagegreen
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Windspeeds",
                                    style: TextStyle(
                                        fontFamily: "Crimson",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: darkgreen
                                    ),
                                  ),
                                  Text(
                                    "$avgWind kmh | $modeSpeed",
                                    style: TextStyle(
                                        fontFamily: "Crimson",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: sagegreen
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Humidity",
                                    style: TextStyle(
                                        fontFamily: "Crimson",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: darkgreen
                                    ),
                                  ),
                                  Text(
                                    "$avgHumidity%",
                                    style: TextStyle(
                                        fontFamily: "Crimson",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: sagegreen
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Precipitation",
                                    style: TextStyle(
                                        fontFamily: "Crimson",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: darkgreen
                                    ),
                                  ),
                                  Text(
                                    "$avgPrecipitation%",
                                    style: TextStyle(
                                        fontFamily: "Crimson",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: sagegreen
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        SingleChildScrollView(
                            child:
                            ListView.builder(
                                shrinkWrap: true,
                                //NAGSCROLL KSI UNG LISTVIEW, nagiinterfere so double single scroll..
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: dateRange.length,
                                itemBuilder: (context, index) {
                                  final temp = double.parse(temperatures[index].toStringAsFixed(2));
                                  final dates = dateRange[index];
                                  final humidity = double.parse(humidities[index].toStringAsFixed(2));
                                  final wind = double.parse(windSpeed[index].toStringAsFixed(2));
                                  final precip = double.parse(precipitationChances[index].toStringAsFixed(2));
                                  final weather = weathers[index];
                                  final fahrenheit = double.parse(convert(temp)!.toStringAsFixed(2));
                                  final windClass = windClassification[index];
                                  return Column(
                                    children: [
                                      SizedBox(height: 20),
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: creamwhite,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  dates,
                                                  style: TextStyle(
                                                      fontFamily: "Crimson",
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                Text(
                                                  weather,
                                                  style: TextStyle(
                                                      fontFamily: "Crimson",
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: darkgreen
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              height: 10,
                                              color: darkgreen,
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Temperature: ",
                                                  style: TextStyle(
                                                      fontFamily: "Crimson",
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: black
                                                  ),
                                                ),
                                                Text(
                                                  "$temp°C  | ${fahrenheit}°F | ${WeatherUtility.getTemperatureCategory(temp)}",
                                                  style: TextStyle(
                                                      fontFamily: "Crimson",
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: darkgreen
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Humidity (%): ",
                                                  style: TextStyle(
                                                      fontFamily: "Crimson",
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: black
                                                  ),
                                                ),
                                                Text(
                                                  "$humidity%",
                                                  style: TextStyle(
                                                      fontFamily: "Crimson",
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: darkgreen
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Wind Speeds: ",
                                                  style: TextStyle(
                                                      fontFamily: "Crimson",
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: black
                                                  ),
                                                ),
                                                Text(
                                                  "$wind kmh | $windClass",
                                                  style: TextStyle(
                                                      fontFamily: "Crimson",
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: darkgreen
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Precipitation Chance: ",
                                                  style: TextStyle(
                                                      fontFamily: "Crimson",
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: black
                                                  ),
                                                ),
                                                Text(
                                                  "$precip%",
                                                  style: TextStyle(
                                                      fontFamily: "Crimson",
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: darkgreen
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                }
                            )
                        ),
                        ElevatedButton(
                            onPressed: ()  {
                              confirmTravel();
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 55),
                                backgroundColor: sagegreen,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                )
                            ),
                            child: Text(
                              "Finalize Travel",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: whitish,
                                fontSize: 20,
                                fontFamily: "Crimson",
                              ),
                            )),
                      ],
                    )
                ]
            ),
          ),
        ),
      ),
    );
  }
}
