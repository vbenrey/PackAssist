import 'package:flutter/material.dart';
import 'package:packassist/screens/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:packassist/screens/functions.dart';

class Viewtravel extends StatefulWidget {
  const Viewtravel({super.key});

  @override
  State<Viewtravel> createState() => _ViewtravelState();
}

class _ViewtravelState extends State<Viewtravel> {
  dynamic? userID;
  //how many trips a user has
  int? count;
  //holds the trips
  dynamic? response;
  final supabase = Supabase.instance.client;
  //for UI purposes
  bool isLoading = true;
  bool isTravelInfo = false;
  String? packed;

  //for delete button
  Color red = Color.fromRGBO(99, 44, 44, 1.0);

  //list for holding travel info
  List<int> travelID = [];
  List<String> locations = [];
  List<String> dateStart = [];
  List<String> dateEnd = [];
  List<String> purposes = [];
  List<bool> havePacked = [];

  //list holding the values for sub weathers
  List<String?> dateRange = [];
  List<double> temperatures = [];
  List<String> tempClass = [];
  List<String> weathers = [];
  List<int> weatherIDs = [];
  List<double> humidities = [];
  List<double> precipitationChances = [];
  List<double> windSpeed = [];
  List<String> windClassification = [];
  List<bool> isAverage = [];

  @override
  void initState() {
    super.initState();
    final current = supabase.auth.currentUser;
    if (current != null) {
      userID = current.id;
      fetchMainTravel();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showError() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Confirmation Message",
            style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 76, 103, 76),
              fontWeight: FontWeight.bold,
              fontFamily: "Crimson",
            ),
          ),
          content: Text(
            "Travel Plan has been successfully deleted.",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontFamily: "Crimson",
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/travel', (route) => false);
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

  void showMessage(String city, int num) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Confirmation Message",
            style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 76, 103, 76),
              fontWeight: FontWeight.bold,
              fontFamily: "Crimson",
            ),
          ),
          content: Text(
            "Delete trip planned for $city?",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontFamily: "Crimson",
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final response = await supabase.from('travels')
                    .delete()
                    .eq('travel_id', num);
                final response2 = await supabase.from('travel_weather')
                    .delete()
                    .eq('travel_id', num);
                  Navigator.pop(context);
                  showError();
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
  
  //fetch the main travel info - average for the whole trip
  void fetchMainTravel () async {
    response = await supabase.from('travels')
        .select('*')
        .eq('user_id', userID);
    count = response.length;
    for (final data in response) {
      travelID.add(data['travel_id']);
      locations.add(data['location']);
      dateStart.add(data['date_start']);
      dateEnd.add(data['date_end']);
      purposes.add(data['purpose']);
      }
    for (final data in travelID) {
      final response2 = await supabase.from('luggage').select('luggage_id').eq('travel_id', data);
      if (response2.isEmpty) {
        havePacked.add(false);
      } else {
        havePacked.add(true);
      }
    }
    setState(() {
      isLoading = false;
    });
    }

  //fetch weather data PER DAY in each travel
  void fetchWeatherTravel (int num) async {
    weatherIDs.clear();
    temperatures.clear();
    tempClass.clear();
    windSpeed.clear();
    windClassification.clear();
    humidities.clear();
    precipitationChances.clear();
    dateRange.clear();
    weathers.clear();
    isAverage.clear();
    response = await supabase.from('travel_weather').select('*').eq('travel_id', num);
      setState(() {
        for (final data in response) {
          weatherIDs.add(data['weather_id']);
          temperatures.add(data['temperature']);
          tempClass.add(data['temp_classification']);
          windSpeed.add(data['wind_speed']);
          windClassification.add(data['wind_classification']);
          humidities.add(data['humidity']);
          precipitationChances.add(data['precipitation']);
          weathers.add(data['specific_weather']);
          if (data['date'] == null) {
            //null means that the weather data is for average
            dateRange.add(null);
          } else {
            dateRange.add(data['date']);
          }
          isAverage.add(data['isAverage']);
        }
      });
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
        title: Text("View Travels",
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
              child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Welcome!",
                            style: TextStyle(
                                fontFamily: "Crimson",
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: black
                            ),
                          ),
                          Icon(Icons.airplanemode_active, color: sage,)
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        "You have planned a total of $count trips! ",
                        style: TextStyle(
                            fontFamily: "Crimson",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkgreen
                        ),
                      ),
                      Text(
                        "Tap on the trip to view travel and weather information.",
                        style: TextStyle(
                            fontFamily: "Crimson",
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text("Current Travels",
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: black,
                      fontFamily: "Crimson"
                  ),),
                if (isLoading == true)
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
                if (isLoading == false)
                  if (isTravelInfo == false)
                  SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: ListView.builder(
                      shrinkWrap: true,
                      //NAGSCROLL KSI UNG LISTVIEW, nagiinterfere so double single scroll..
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: travelID.length,
                      itemBuilder: (context, index) {
                        final currentTravelID = travelID[index];
                        final currentLocation = locations[index];
                        final currentStart = dateStart[index];
                        final currentEnd = dateEnd[index];
                        final currentPurpose = purposes[index];
                        if (havePacked[index] == false) {
                            packed = "N0";
                            return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    final selectedID = currentTravelID;
                                    isTravelInfo = true;
                                    fetchWeatherTravel(selectedID);
                                  });
                                },
                                child: Column(
                                  children: [
                                    SizedBox(height: 20),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: whitish,
                                          boxShadow: [BoxShadow(
                                              offset: Offset(1, 5),
                                              blurRadius: 7,
                                              spreadRadius: 1,
                                              color: Colors.black.withOpacity(.3)
                                          )],
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                              decoration: BoxDecoration(
                                                  color: grayblue,
                                                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          currentLocation,
                                                          style: TextStyle(
                                                              color: black,
                                                              fontFamily: "Crimson",
                                                              fontSize: 21,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),),
                                                      IconButton(onPressed: () {
                                                        showMessage(currentLocation, currentTravelID);
                                                      }, icon: Icon(Icons.delete, size: 28, color: red))
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Duration:",
                                                        style: TextStyle(
                                                            fontFamily: "Crimson",
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                            color: darkergreen
                                                        ),
                                                      ),
                                                      Text(
                                                        " $currentStart  to $currentEnd",
                                                        style: TextStyle(
                                                            fontFamily: "Crimson",
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                            color: darkergreen
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Travel Purpose: ",
                                                      style: TextStyle(
                                                          fontFamily: "Crimson",
                                                          fontSize: 17,
                                                          fontWeight: FontWeight.bold,
                                                          color: black
                                                      ),
                                                    ),
                                                    Text(
                                                      "$currentPurpose",
                                                      style: TextStyle(
                                                          fontFamily: "Crimson",
                                                          fontSize: 17,
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
                                                      "Have Packed: ",
                                                      style: TextStyle(
                                                          fontFamily: "Crimson",
                                                          fontSize: 17,
                                                          fontWeight: FontWeight.bold,
                                                          color: black
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pushNamed(context, '/addLuggage', arguments: currentTravelID);
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        minimumSize: Size(20, 30),
                                                        backgroundColor: darkgreen,
                                                        elevation: 0,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        "Add",
                                                        style: TextStyle(fontSize: 15, color: whitish, fontFamily: "Crimson",),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )
                            );
                        } else {
                          return GestureDetector(
                              onTap: () {
                                setState(() {
                                  final selectedID = currentTravelID;
                                  isTravelInfo = true;
                                  fetchWeatherTravel(selectedID);
                                });
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: whitish,
                                        boxShadow: [BoxShadow(
                                            offset: Offset(1, 5),
                                            blurRadius: 7,
                                            spreadRadius: 1,
                                            color: Colors.black.withOpacity(.3)
                                        )],
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                            decoration: BoxDecoration(
                                                color: grayblue,
                                                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                      currentLocation,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontFamily: "Crimson",
                                                          fontSize: 21,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    ),),
                                                    IconButton(onPressed: () {
                                                      showMessage(currentLocation, currentTravelID);
                                                    }, icon: Icon(Icons.delete, size: 30, color: red))
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Duration:",
                                                      style: TextStyle(
                                                          fontFamily: "Crimson",
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                          color: darkergreen
                                                      ),
                                                    ),
                                                    Text(
                                                      " $currentStart  to $currentEnd",
                                                      style: TextStyle(
                                                          fontFamily: "Crimson",
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                          color: darkergreen
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Travel Purpose: ",
                                                    style: TextStyle(
                                                        fontFamily: "Crimson",
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.bold,
                                                        color: black
                                                    ),
                                                  ),
                                                  Text(
                                                    "$currentPurpose",
                                                    style: TextStyle(
                                                        fontFamily: "Crimson",
                                                        fontSize: 17,
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
                                                    "Have Packed: ",
                                                    style: TextStyle(
                                                        fontFamily: "Crimson",
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.bold,
                                                        color: black
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pushNamed(context, '/viewLuggage', arguments: currentTravelID);
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      minimumSize: Size(20, 30),
                                                      backgroundColor: darkgreen,
                                                      elevation: 0,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "View",
                                                      style: TextStyle(fontSize: 15, color: whitish, fontFamily: "Crimson",),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                          );
                        }
                      }
                  )
                ),
                  if (isTravelInfo == true)
                    SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: ListView.builder(
                            shrinkWrap: true,
                            //NAGSCROLL KSI UNG LISTVIEW, nagiinterfere so double single scroll..
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: temperatures.length,
                            itemBuilder: (context, index) {
                              final currentDate = dateRange[index];
                              final currentTemp = temperatures[index];
                              final currentTempClass = tempClass[index];
                              final currentWeather = weathers[index];
                              final currentHumidity = humidities[index];
                              final currentPrecipitation = precipitationChances[index];
                              final currentWindSpeed = windSpeed[index];
                              final currentWindClass = windClassification[index];
                              if (currentDate == null) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(onPressed: () {
                                      setState(() {
                                        isTravelInfo = false;
                                      });
                                    }, icon: Icon(Icons.arrow_circle_left_rounded, size: 35, color: Colors.grey[400],)),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          color: grayblue,
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
                                          Text("Average Weather Information: ",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: black,
                                                fontFamily: "Crimson"
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Divider(
                                            thickness: 2,
                                            color: sagegreen,
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
                                                    color: darkergreen
                                                ),
                                              ),
                                              Text(
                                                "$currentTemp°C | $currentTempClass",
                                                style: TextStyle(
                                                    fontFamily: "Crimson",
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: darkergreen
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
                                                    color: darkergreen
                                                ),
                                              ),
                                              Text(
                                                "$currentWeather",
                                                style: TextStyle(
                                                    fontFamily: "Crimson",
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: darkergreen
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
                                                    color: darkergreen
                                                ),
                                              ),
                                              Text(
                                                "$currentWindSpeed kmh | $currentWindClass",
                                                style: TextStyle(
                                                    fontFamily: "Crimson",
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: darkergreen
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
                                                    color: darkergreen
                                                ),
                                              ),
                                              Text(
                                                "$currentHumidity%",
                                                style: TextStyle(
                                                    fontFamily: "Crimson",
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: darkergreen
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
                                                    color: darkergreen
                                                ),
                                              ),
                                              Text(
                                                "$currentPrecipitation%",
                                                style: TextStyle(
                                                    fontFamily: "Crimson",
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: darkergreen
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                );
                              }
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
                                              "$currentDate",
                                              style: TextStyle(
                                                  fontFamily: "Crimson",
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            Text(
                                              currentWeather,
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
                                              "$currentTemp°C | $currentTempClass",
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
                                              "$currentHumidity%",
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
                                              "$currentWindSpeed kmh | $currentWindClass",
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
                                              "$currentPrecipitation%",
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
                    )
              ],
          ),
        ),
      ),
    );
  }
}
