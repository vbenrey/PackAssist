import 'package:flutter/material.dart';
import 'package:packassist/screens/functions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:packassist/screens/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();
  //default city + weather
  String cityName = "Manila, Philippines";
  //date time stuff
  DateTime current = DateTime.now();
  String currentString = "";
  String dateToday = "";
  String tempClassification = "";
  String weather = "";
  double precipitationProbability = 0;
  double humidity = 0;
  double celsius = 0;
  double fahrenheit = 0;

  //get the weather data of manila
  //this is future since we have to wait for api to give it to the app, so we have async and await and future
  Future<WeatherData?> getDefaultWeather(String name) async {
    //stores long and lat of manilacords in a list
    //getcoords returns Location objects that stores data which includes long and lat
    List<Location> cords = await getCoords(name);
    // //we store it in double so we can pass it to get weather function
    double latitude = cords[0].latitude;
    double longitude = cords[0].longitude;
    return getWeather(latitude, longitude, currentString, currentString);
  }

  //initialize the default data and format them to 2 decimal spaces
  @override
  void initState() {
    super.initState();
    getDefaultWeather(cityName).then((weatherData) {
      if (weatherData != null) {
        setState(() {
          //only rounds to two decimal places
          celsius = double.parse(weatherData.temperature.toStringAsFixed(2));
          fahrenheit = double.parse(convert(celsius)!.toStringAsFixed(2));
          tempClassification = WeatherUtility.getTemperatureCategory(celsius);
          weather = getWeatherClassification(weatherData.weatherCode);
          precipitationProbability = double.parse(weatherData.precipitationProbability.toStringAsFixed(2));
          humidity = double.parse(weatherData.humidity.toStringAsFixed(2));
          dateToday = "${WeatherUtility.monthNames[current.month-1]} ${current.day}, ${current.year}";
          currentString = "${current.year}-${current.month}-${current.day}";
        });
      }
    });
  }

  //this returns the search results for whatever the user searches
  //built-in function of meteo api which is "/v1/search"
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
                                currentString,
                                currentString
                              ).then((weatherData) {
                                //if not null, pass the values
                                if (weatherData != null) {
                                  setState(() {
                                    celsius = double.parse(weatherData.temperature.toStringAsFixed(2));
                                    fahrenheit = double.parse(convert(celsius)!.toStringAsFixed(2));
                                    tempClassification = WeatherUtility.getTemperatureCategory(celsius);
                                    weather = getWeatherClassification(weatherData.weatherCode);
                                    precipitationProbability = double.parse(weatherData.precipitationProbability.toStringAsFixed(2));
                                    humidity = double.parse(weatherData.humidity.toStringAsFixed(2));
                                  });
                                }
                              });
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

  //dispose the text controllers
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        title: Text("Dashboard",
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
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/tutorial');
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: whitish,
                      boxShadow: [BoxShadow(
                          offset: Offset(1, 5),
                          blurRadius: 10,
                          spreadRadius: 5,
                          color: Color.fromRGBO(0, 0, 0, 0.1)
                      )],
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Need help navigating the app?",
                        style: TextStyle(
                          fontSize: 20,
                          color: black,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Crimson",
                        ),),
                      SizedBox(height: 10),
                      Text("Click here to view the FAQ page!",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontFamily: "Crimson",
                        ),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: whitish,
                  boxShadow: [BoxShadow(
                    offset: Offset(1, 5),
                    blurRadius: 10,
                    spreadRadius: 5,
                    color: Color.fromRGBO(0, 0, 0, 0.07)
                  )],
                  borderRadius: BorderRadius.circular(20)
                ),
                  child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: sage,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                              ),
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cityName,
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Crimson",
                                  ),),
                                Text(dateToday,
                                  style: TextStyle(
                                    color: darkergreen,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Crimson",
                                  ),),
                              ],
                            ),
                            ),
                            Container(
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                color: whitish,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                                  child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Current Weather",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Crimson",
                                  ),),
                                Text("  $weather",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: sagegreen,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Crimson",
                                  ),),
                              ],
                            ),
                                  ),
                                  SizedBox(height: 5),
                                  Divider(
                                    thickness: 2,
                                    color: creamwhite,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Temperature",
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Crimson",
                                          ),),
                                        Text("$celsius°C | $tempClassification",
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: sagegreen,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Crimson",
                                          ),),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Divider(
                                    thickness: 2,
                                    color: creamwhite,
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Precipitation \nChance",
                                        style: TextStyle(
                                          height: 1,
                                          fontSize: 17,
                                          color: black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Crimson",
                                        ),),
                                      Text("  $precipitationProbability%",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: sagegreen,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Crimson",
                                        ),),
                                    ],
                                  ),
                                  ),
                                  SizedBox(height: 5),
                                  Divider(
                                    thickness: 2,
                                    color: creamwhite,
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Humidity",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Crimson",
                                        ),),
                                      Text("  $humidity%",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: sagegreen,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Crimson",
                                        ),),
                                    ],
                                  ),)
                                ],
                              ),
                            ),
                          ],
                        ),
              ),
              SizedBox(height: 25),
              //this is the search button and the enter thing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                            hintText: "Search City...",
                            prefixIcon: Icon(Icons.search),
                            fillColor: Colors.grey[300],
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none
                            ),
                            hintStyle: TextStyle(
                              color: sage,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Crimson",
                              fontSize: 16
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
                          minimumSize: Size(50, 52),
                          backgroundColor: black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          )
                      ),
                      child: Text(
                        "Enter",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: whitish,
                          fontSize: 16,
                          fontFamily: "Crimson",
                        ),
                      )))
                ],
              ),
              SizedBox(height: 15),
              Column(
                    children: [
                      SizedBox(height: 10),
                      GestureDetector(
                            onTap: () {Navigator.pushNamed(context, "/travel");},
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: whitish,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(
                                  offset: Offset(1, 0),
                                  blurRadius: 10,
                                  spreadRadius: 0.05,
                                  color: Colors.black.withOpacity(.15)
                                )]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: AssetImage('assets/images/travel.png'),
                                              fit: BoxFit.cover
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "View Travel Log",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Crimson",
                                            ),
                                          ),
                                          Text(
                                            "View your current travels",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: sage,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Crimson",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: sagegreen,
                                    fontWeight: FontWeight.bold,
                                  )
                                ],
                              ),
                            ),
                          ),
                      SizedBox(height: 10),
                      GestureDetector(
                            onTap: () {Navigator.pushNamed(context, "/previewTrip");},
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: whitish,
                                borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(
                                      offset: Offset(1, 0),
                                      blurRadius: 10,
                                      spreadRadius: 0.05,
                                      color: Colors.black.withOpacity(.15)
                                  )]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: AssetImage('assets/images/trip.png'),
                                              fit: BoxFit.cover
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Add a Trip",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Crimson",
                                            ),
                                          ),
                                          Text(
                                            "Start planning your trips",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: sage,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Crimson",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: sagegreen,
                                    fontWeight: FontWeight.bold,
                                  )
                                ],
                              ),
                            ),
                          ),
                      SizedBox(height: 10),
                      GestureDetector(
                            onTap: () {Navigator.pushNamed(context, "/weather");},
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: whitish,
                                borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(
                                      offset: Offset(1, 0),
                                      blurRadius: 10,
                                      spreadRadius: 0.05,
                                      color: Colors.black.withOpacity(.15)
                                  )]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: AssetImage('assets/images/weather.png'),
                                              fit: BoxFit.cover
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "View Weather Forecast",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Crimson",
                                            ),
                                          ),
                                          Text(
                                            "View a detailed weather forecast",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: sage,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Crimson",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: sagegreen,
                                    fontWeight: FontWeight.bold,
                                  )
                                ],
                              ),
                            ),
                          ),
                    ],
              )
            ],
          )
          ),
        ),
      );
  }
}
