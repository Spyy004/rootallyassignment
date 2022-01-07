import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_balloon_slider/flutter_balloon_slider.dart';
import 'package:rootallyassignment/Services/firebase_database.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'constants_styles.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double value = 5.0;
  String displayMessage="";
  final DatabaseReference messagesRef =
  FirebaseDatabase.instance.reference();
  getDatafromServer(String val){
    messagesRef.child(val).once().then((value) {
      print(value.value);
      print(value.key);
      setState(() {
        displayMessage = value.value;
      });
    });
  }
  GetMessages g1 = GetMessages();
  Map<int,String>painValues={};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDatafromServer(value.toString().substring(0,1));
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  color: Colors.teal[200]
              ),
              child: Padding(
                padding: EdgeInsets.only(left: width * 0.1, top: height * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.black,),
                    SizedBox(height: height * 0.02,),
                    Text(
                      "You have 2 more\n sessions today", style: headerText,),
                  ],
                ),
              )),
          Positioned(
            top: 200,
            child: Container(
              width: width,
              height: height * 0.8,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30),
                      topLeft: Radius.circular(30))
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 0.15 * height, left: 0.07 * width),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Pain Score", style: headerText.copyWith(
                        fontSize: 26, fontWeight: FontWeight.w700),),
                    const Text("How does your knee feel now?",
                      style: TextStyle(fontSize: 20),),
                    SizedBox(height: 0.1 * height,),
                    Padding(
                      padding: EdgeInsets.only(right:width*0.05),
                      child: SfSlider(
                        showDividers: false,
                          max:10,
                          min: 0,
                          interval: 1,
                          showTicks: true,
                          showLabels: true,
                          labelPlacement: LabelPlacement.onTicks,
                          activeColor: Colors.black,
                          stepSize: 1,
                          value: value,
                          onChanged: (dynamic val){
                            setState(() {
                              value=val;
                              getDatafromServer(val.toString().split('.').first);
                            });
                      }),
                    ),
                    SizedBox(height: 0.15*width,),
                    Padding(
                      padding: EdgeInsets.only(left:width*0.25),
                      child: Text(healthEmoji[value.toInt()]+ "  "+ displayMessage,style: headerText.copyWith(color: Colors.green,fontSize: 20),),
                    ),
                    SizedBox(height: 0.1 * height,),
                    Container(
                        width: 0.8 * width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text("Submit",
                            style: headerText.copyWith(fontSize: 14),)),
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
