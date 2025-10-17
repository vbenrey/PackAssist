import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:packassist/screens/scaffoldShow.dart';
import 'package:packassist/screens/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UpdateLuggageAndItemsPage extends StatefulWidget {

  @override
  State<UpdateLuggageAndItemsPage> createState() => _UpdateLuggageAndItemsPageState();
}

class _UpdateLuggageAndItemsPageState extends State<UpdateLuggageAndItemsPage> {

  //list that contains all luggage, with list of items per luggage yan
  List<Map<String, dynamic>> luggages = [];

  List<String> categories = [
    "Weather",
    "Electronics",
    "Toiletries",
    "Clothing",
    "Documents",
    "Food",
    "Entertainment",
    "Health",
    "Misc"
  ];

  int _currentCatIndex = 0;
  List<List<String>> categoryItems = [];

  //list containing recommended items
  List<String> weatherItems = [];
  List<String> electronicItems = [];
  List<String> toiletriesItems = [];
  List<String> clothingItems = [];
  List<String> documentsItems = [];
  List<String> foodItems = [];
  List<String> entertainmentItems = [];
  List<String> miscItems = [];
  List<String> healthItems = [];


  //for loading and hold
  bool _isLoading = false;

  //so it can be accessed outside the didChangeDependencies()
  late int travel_id;
  //travelID sent from trip.dart where travel data is made
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    travel_id = ModalRoute.of(context)!.settings.arguments as int;
    fetchRecommendData();
  }

  Future<void> fetchRecommendData() async {
    final supabase = Supabase.instance.client;

    try {
      final weatherResponse = await supabase.from('travel_weather')
          .select('weather_id').eq('travel_id', travel_id).eq('isAverage', true).maybeSingle();

      final weather_id = weatherResponse?['weather_id'];

      final weatherRecResponse = await supabase.from('recommendation_items')
          .select('item_name').eq('weather_id', weather_id);

      final electronicResponse = await supabase.from('recommendation_items')
          .select('item_name').eq('type_id', 1);

      final toiletriesResponse = await supabase.from('recommendation_items')
          .select('item_name').eq('type_id', 2);

      final clothingResponse = await supabase.from('recommendation_items')
          .select('item_name').eq('type_id', 3);

      final documentResponse = await supabase.from('recommendation_items')
          .select('item_name').eq('type_id', 4);

      final foodResponse = await supabase.from('recommendation_items')
          .select('item_name').eq('type_id', 5);

      final entertainmentResponse = await supabase.from('recommendation_items')
          .select('item_name').eq('type_id', 6);

      final miscResponse = await supabase.from('recommendation_items')
          .select('item_name').eq('type_id', 7);

      final healthResponse = await supabase.from('recommendation_items')
          .select('item_name').eq('type_id', 10);

      setState(() {
        if (weatherResponse == null || weather_id == null || weatherRecResponse.isEmpty) {
          weatherItems = ['No weather items needed for the travel.'];
        } else {
          weatherItems = weatherRecResponse.map((item) => item['item_name'] as String).toList();
        }
        electronicItems = electronicResponse.map((item) => item['item_name'] as String).toList();
        toiletriesItems = toiletriesResponse.map((item) => item['item_name'] as String).toList();
        clothingItems = clothingResponse.map((item) => item['item_name'] as String).toList();
        documentsItems = documentResponse.map((item) => item['item_name'] as String).toList();
        foodItems = foodResponse.map((item) => item['item_name'] as String).toList();
        entertainmentItems = entertainmentResponse.map((item) => item['item_name'] as String).toList();
        healthItems = healthResponse.map((item) => item['item_name'] as String).toList();
        miscItems = miscResponse.map((item) => item['item_name'] as String).toList();

        categoryItems = [
          weatherItems,
          electronicItems,
          toiletriesItems,
          clothingItems,
          documentsItems,
          foodItems,
          entertainmentItems,
          healthItems,
          miscItems
        ];

      });

    } on AuthException catch (exception) {
      showSnackBar(context, "Auth Error: ${exception.message}");
      return;
    } on Exception catch (exception) {
      showSnackBar(context, 'Error: $exception.');
      return;
    }
  }

  //add luggage (not items) like bag#1, suitcase#1
  void createLuggage() {
    setState(() {
      luggages.add(
          {
            'luggage_name': '', //'' placeholder for user input
            'items': [
              {
                'item_name': '',
                'quantity': ''
              }
            ] //basically an empty list palang
          }
      );
    });
  }

  void deleteLuggage(int index) {
    setState(() {
      luggages.removeAt(index); //need index to know which item to delete ya
    });
  }

  void addItemToLuggage(int index) {
    setState(() {
      luggages[index]['items'].add({
        'item_name': '', //'' placeholder for user input
        'quantity': '' //'' placeholder for user input
      });
    });
  }

  void removeItem(int luggageIndex, int itemIndex) {
    setState(() {
      luggages[luggageIndex]['items'].removeAt(itemIndex);
    });
  }

  //save details to supa db
  Future <void> saveLuggageData() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    try {

      //DELETE ANY INSTACE/ROW OF LUGGAGE
      await supabase.from('luggage').delete().eq('travel_id', travel_id);

      setState(() {
        _isLoading = true;
      });

      if (luggages.isEmpty) {
        showSnackBar(
            context, "No luggage to save. Please create luggage first.");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      for (final luggage in luggages) {
        if (luggage['luggage_name'].isEmpty || luggage['luggage_name']
            .toString()
            .trim()
            .isEmpty) {
          showSnackBar(context, 'Empty luggage name.');
          setState(() {
            _isLoading = false;
          });
          return;
        }

        if (luggage['items'].isEmpty) {
          showSnackBar(context,
              "Please add at least one item to ${luggage['luggage_name']}.");
          setState(() {
            _isLoading = false;
          });
          return;
        }

        for (final item in luggage['items']) {
          if (item['item_name']
              .toString()
              .trim()
              .isEmpty) {
            showSnackBar(context,
                "An item in ${luggage['luggage_name']} is missing a name. Delete or insert a name for the item.");
            setState(() {
              _isLoading = false;
            });
            return;
          }

          if (item['quantity']
              .toString()
              .trim()
              .isNotEmpty) {
            final quantity = int.tryParse(item['quantity'].toString().trim());

            if (quantity == null || quantity < 1) {
              showSnackBar(
                  context, "Invalid quantity for ${item['item_name']}.");
              setState(() {
                _isLoading = false;
              });
              return;
            }
          }
        }
      }

      //if all requirements are met
      for (final luggage in luggages) {
        final response = await supabase.from('luggage').insert({
          'luggage_name': luggage['luggage_name'],
          'travel_id': travel_id,
        }).select().single();
        // .select().single() is to retrieve the luggage row to
        // obtain luggage_id since need natin yun for items

        final luggage_id = response['luggage_id']; //get newly generated id of luggage

        for (final item in luggage['items']) {
          await supabase.from('items').insert({
            'luggage_id': luggage_id,
            'item_name': item['item_name'],
            'quantity': int.tryParse(item['quantity'].toString().trim()) ?? 1,
            //if no quantity specified, automatically 1
          });
        }
      }


      showSnackBar(context, "Luggage saved successfully.");

      setState(() {
        _isLoading = false;
      });

      Future.delayed(Duration(seconds: 5), () {
        if (!mounted) return;
        setState(() {
          luggages.clear();
        });

        if (mounted) {
          Navigator.pushReplacementNamed(
              context, '/viewLuggage', arguments: travel_id);
        }
      });
    } on AuthException catch (exception) {
      showSnackBar(context, "Auth Error: ${exception.message}.");
      setState(() {
        _isLoading = false;
      });
      return;
    } on Exception catch (exception) {
      showSnackBar(context, "Error: $exception.");
      setState(() {
        _isLoading = false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitish,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: EdgeInsets.only(top: 20),
              width: double.infinity,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.15,
              decoration: BoxDecoration(
                  color: whitish,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40)),
                  boxShadow: [BoxShadow(
                      offset: Offset(0, 5),
                      blurRadius: 10,
                      spreadRadius: 5,
                      color: Color.fromRGBO(0, 0, 0, .05)
                  )
                  ]
              ),
              child:
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                child: Text(
                  textAlign: TextAlign.center,
                  "Update Luggage",
                  style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Crimson',
                      color: black,
                      fontWeight: FontWeight.bold,
                      height: 1
                  ),
                ),
              ),
            ),

            if (categoryItems.isNotEmpty)
              GestureDetector(
                onHorizontalDragEnd: (content){
                  if (content.primaryVelocity == null) return;

                  if (content.primaryVelocity! > 0) {
                    //swipe right to prev
                    setState(() {
                      _currentCatIndex = (_currentCatIndex - 1 + categories.length) % categories.length;
                      //so it doesnt go negative values
                    });
                  }

                  else if (content.primaryVelocity! < 0) {
                    //swipe left to next
                    setState(() {
                      _currentCatIndex = (_currentCatIndex + 1) % categories.length;
                    });
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(left: 40, right: 40, bottom: 0, top: 40),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: sage,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, .05),
                        blurRadius: 10,
                        spreadRadius: 5
                    )],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline_rounded, color: whitish, size: 25),
                          SizedBox(width: 10),
                          Text(
                            "Recommended\n${categories[_currentCatIndex]} Items",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: whitish,
                                fontFamily: 'Crimson'
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),

                      Wrap(
                        spacing: 5,
                        runSpacing: 0,
                        children: categoryItems[_currentCatIndex].map((item) {

                          final noWeatherItem = (item == "No weather items needed for the travel.");
                          return noWeatherItem ?
                          Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 8, right: 8, top: 8),
                            child: Text(
                              item,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: black,
                                  fontFamily: 'Crimson'
                              ),
                            ),
                          )
                              :
                          ElevatedButton(
                            onPressed: (){

                              if (luggages.isEmpty) {
                                showSnackBar(context, "Please create a luggage first.");
                                return;
                              }

                              showDialog(context: context, builder: (context) {
                                return SimpleDialog(
                                  backgroundColor: whitish,
                                  title: Text("Save Item to:",
                                    style: TextStyle(
                                        fontFamily: 'Crimson',
                                        fontSize: 30,
                                        color: sagegreen,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),

                                  children: [

                                    SizedBox(height: 10),

                                    Center(
                                      child: Container(
                                        width: double.infinity,
                                        height: 2,
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(0, 0, 0, 0.04)
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 10),

                                    for (int index = 0 ; index < luggages.length; index++)
                                      SimpleDialogOption(
                                        child: Text(
                                          luggages[index]['luggage_name'].isEmpty ?
                                          "Luggage ${index + 1}"
                                              :
                                          luggages[index]['luggage_name']
                                          ,
                                          style: TextStyle(
                                              fontFamily: 'Crimson',
                                              fontSize: 18,
                                              color: black,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),

                                        onPressed: (){
                                          setState(() {
                                            luggages[index]['items'].add({
                                              'item_name': item,
                                              'quantity': '1'
                                            });
                                          });

                                          Navigator.pop(context);
                                        },
                                      ),
                                  ],
                                );
                              });
                            },

                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                minimumSize: Size(40, 35),
                                backgroundColor: whitish,
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                )
                            ),

                            child: Text(
                              item,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: black,
                                  fontFamily: 'Crimson'
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

            Padding(
              padding: EdgeInsets.only(left: 40, right: 40, top: 10),
              child:
              Text(
                textAlign: TextAlign.center,
                "Note: Swipe left or right to see suggestions.",
                style: TextStyle(
                    fontFamily: 'Crimson',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: grayblue
                ),
              ),
            ),

            SizedBox(height: 40),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 2,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.04)
                ),
              ),
            ),

            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: luggages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(
                        left: 40, top: 0, right: 40, bottom: 20),
                    padding: EdgeInsets.only(top: 5, bottom: 20),
                    decoration: BoxDecoration(
                        color: whitish,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, .05),
                            blurRadius: 10,
                            spreadRadius: 5
                        )
                        ]
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Padding(
                            padding: EdgeInsets.only(left: 20, right: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextField(
                                    onChanged: (value) =>
                                    luggages[index]['luggage_name'] = value,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: black,
                                        fontFamily: 'Crimson'
                                    ),
                                    decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                          color: grayblue,
                                          fontFamily: 'Crimson',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        hintText: "Enter Luggage Name",
                                        border: InputBorder.none
                                    ),
                                  ),
                                ),

                                IconButton(
                                    onPressed: (){
                                      setState(() {
                                        deleteLuggage(index);
                                      });
                                    },
                                    icon:
                                    Icon(Icons.close_rounded, color: Colors.redAccent, fontWeight: FontWeight.bold,size: 20,))
                              ],
                            )
                        ),

                        Center(
                          child: Container(
                            width: double.infinity,
                            height: 2,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0.04)
                            ),
                          ),
                        ),

                        Column(
                          children: [

                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20, right: 55, top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    "Item Name",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: black,
                                        fontFamily: 'Crimson'
                                    ),
                                  ),

                                  Text(
                                    "Quantity",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: black,
                                        fontFamily: 'Crimson'
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            for (int count = 0; count <
                                luggages[index]['items'].length; count++)
                              Padding(
                                padding: EdgeInsets.only(left: 20, right: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [

                                    Expanded(
                                      flex: 5,
                                      child: TextFormField(
                                        //initial value is for recommended items
                                        initialValue: luggages[index]['items'][count]['item_name'],
                                        onChanged: (value) =>
                                        luggages[index]['items'][count]['item_name'] =
                                            value,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: black,
                                            fontFamily: 'Crimson'
                                        ),
                                        decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                              color: grayblue,
                                              fontFamily: 'Crimson',
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            hintText: "Item Name...",
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 20),

                                    Expanded(
                                      child: TextFormField(
                                        textAlign: TextAlign.right,
                                        initialValue: luggages[index]['items'][count]['quantity'],
                                        onChanged: (value) =>
                                        luggages[index]['items'][count]['quantity'] =
                                            value,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: black,
                                            fontFamily: 'Crimson'
                                        ),
                                        decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                              color: grayblue,
                                              fontFamily: 'Crimson',
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            hintText: "1",
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 8),

                                    IconButton(
                                        onPressed: (){
                                          setState(() {
                                            removeItem(index, count);
                                          });
                                        },
                                        icon:
                                        Icon(Icons.close_rounded, color: Colors.redAccent, fontWeight: FontWeight.bold,size: 20,))
                                  ],
                                ),
                              ),
                          ],
                        ),

                        ElevatedButton(
                            onPressed: () {
                              addItemToLuggage(index);
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: black,
                                overlayColor: creamwhite,
                                minimumSize: Size(150, 40),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5))
                                )
                            ),
                            child:
                            Text(
                              "Add Item",
                              style: TextStyle(
                                  fontFamily: "Alice",
                                  fontWeight: FontWeight.bold,
                                  color: creamwhite,
                                  fontSize: 15
                              ),
                            )
                        )
                      ],
                    ),
                  );
                }
            ),

            SizedBox(height: 10),

            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 2,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.04)
                ),
              ),
            ),

            SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                  onPressed: () {
                    createLuggage();
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: grayblue,
                      overlayColor: creamwhite,
                      minimumSize: Size(MediaQuery
                          .of(context)
                          .size
                          .width * 0.8, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      )
                  ),
                  child:
                  Text(
                    "Add Luggage",
                    style: TextStyle(
                        fontFamily: "Alice",
                        fontWeight: FontWeight.bold,
                        color: whitish,
                        fontSize: 15
                    ),
                  )
              ),
            ),

            SizedBox(height: 5),

            Center(
              child: ElevatedButton(
                  onPressed: _isLoading ? null : () {
                    saveLuggageData();
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: sagegreen,
                      overlayColor: creamwhite,
                      minimumSize: Size(MediaQuery
                          .of(context)
                          .size
                          .width * 0.8, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      )
                  ),
                  child: _isLoading ? Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.65,
                    child: Center(
                      child: LoadingAnimationWidget.waveDots(color: sagegreen, size: 30),
                    ),
                  ) :
                  Text(
                    "Save Changes",
                    style: TextStyle(
                        fontFamily: "Alice",
                        fontWeight: FontWeight.bold,
                        color: creamwhite,
                        fontSize: 15
                    ),
                  )
              ),
            ),

            SizedBox(height: 5),

            Center(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: black,
                      overlayColor: creamwhite,
                      minimumSize: Size(MediaQuery
                          .of(context)
                          .size
                          .width * 0.8, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      )
                  ),
                  child: _isLoading ? Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.65,
                    child: Center(
                      child: LoadingAnimationWidget.waveDots(color: sagegreen, size: 30),
                    ),
                  ) :
                  Text(
                    "Cancel",
                    style: TextStyle(
                        fontFamily: "Alice",
                        fontWeight: FontWeight.bold,
                        color: creamwhite,
                        fontSize: 15
                    ),
                  )
              ),
            ),

            SizedBox(height: 5),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child:
              Text(
                textAlign: TextAlign.center,
                "Note: Click the Add Luggage button to add another bag/suitcase.",
                style: TextStyle(
                    fontFamily: 'Crimson',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: grayblue
                ),
              ),
            ),

            SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}