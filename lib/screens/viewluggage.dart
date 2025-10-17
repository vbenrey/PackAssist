import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:packassist/screens/scaffoldShow.dart';
import 'package:packassist/screens/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ViewLuggage extends StatefulWidget {

  @override
  State<ViewLuggage> createState() => _ViewLuggageState();
}

class _ViewLuggageState extends State<ViewLuggage> {

  //list that contains all luggage, with list of items per luggage yan
  List<Map<String, dynamic>> luggages = [];

  //so it can be accessed outside the didChangeDependencies()
  late int travel_id;
  //travelID sent from trip.dart where travel data is made
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    travel_id = ModalRoute.of(context)!.settings.arguments as int;
    fetchLuggageData();
  }

  Future<void> fetchLuggageData() async {
    final supabase = Supabase.instance.client;

    try {
      final luggageResponse = await supabase.from('luggage').select().eq('travel_id', travel_id);

      List<Map<String, dynamic>> fetchedLuggages = [];

      for (var luggage in luggageResponse) {
        final itemsResponse = await supabase.from('items').select().eq('luggage_id', luggage['luggage_id']);

        fetchedLuggages.add({
          'luggage_name': luggage['luggage_name'],
          'items': (itemsResponse as List<dynamic>?)?.map((item) => {
            'item_name': item['item_name'] ?? 'No item saved.',
            'quantity': item['quantity'].toString()
          }).toList() ?? []
        });
      }

      if (!mounted) return;
      setState(() {
        luggages = fetchedLuggages;
      });

    } on AuthException catch (exception) {
      showSnackBar(context, "Auth Error: ${exception.message}.");
      return;
    } on Exception catch (exception) {
      showSnackBar(context, "Error: $exception.");
    }
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: whitish,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 20),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.15,
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

              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 15),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, '/travel', (route) => false);
                        },
                        icon: Icon(
                            Icons.chevron_left_rounded, size: 40,
                            color: black)
                    ),
                  ),

                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery
                            .of(context)
                            .size
                            .height * 0.05, left: 20),
                        child: Text(
                          "View Luggage",
                          style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'Crimson',
                              color: black,
                              fontWeight: FontWeight.bold,
                              height: 1
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            if (luggages.isEmpty) ...{
                SizedBox(height: 150),

                Center(
                  child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "No luggage added yet.",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Crimson',
                            color: black,
                            fontWeight: FontWeight.bold),
                      )
                  ),
                ),

                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/addluggage', arguments: travel_id);
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: sagegreen,
                          overlayColor: creamwhite,
                          minimumSize: Size(MediaQuery
                              .of(context)
                              .size
                              .width * 0.65, 40),
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
                            color: creamwhite,
                            fontSize: 15
                        ),
                      )
                  ),
                ),
            },

            if (luggages.isNotEmpty)
              ListView.builder(
                  itemCount: luggages.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      decoration: BoxDecoration(
                        color: whitish,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, .05),
                          blurRadius: 10,
                          spreadRadius: 5
                        )]
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              luggages[index]['luggage_name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: black,
                                  fontFamily: 'Crimson'
                              ),
                            ),
                          ),

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

                          SizedBox(height: 15),

                          Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 20),
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
                                  textAlign: TextAlign.right,
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

                          SizedBox(height: 10),

                          for (var item in luggages[index]['items'])
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      item['item_name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: black,
                                          fontFamily: 'Crimson'
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      textAlign: TextAlign.right,
                                      item['quantity']?.toString() ?? '1',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: black,
                                          fontFamily: 'Crimson'
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 25),
                                ],
                              ),
                            )
                        ],
                      ),
                    );
                  }
              ),

            SizedBox(height: 50),

            Center(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/editLuggage', arguments: travel_id);
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
                  child: Text(
                    "Repack Luggage",
                    style: TextStyle(
                        fontFamily: "Alice",
                        fontWeight: FontWeight.bold,
                        color: creamwhite,
                        fontSize: 15
                    ),
                  )
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child:
              Text(
                textAlign: TextAlign.start,
                "Note: Upon clicking Repack Luggage, you will be required to re-enter all previous luggage.",
                style: TextStyle(
                    fontFamily: 'Crimson',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: grayblue
                ),
              ),
            ),

            SizedBox(height: 30),

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
                  child: Text(
                    "Return to Home",
                    style: TextStyle(
                        fontFamily: "Alice",
                        fontWeight: FontWeight.bold,
                        color: creamwhite,
                        fontSize: 15
                    ),
                  )
              ),
            ),

            SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}