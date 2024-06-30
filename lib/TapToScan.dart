import 'dart:async';
import 'dart:convert';
import 'package:coding/Information.dart';
import 'package:coding/Report.dart';
import 'package:coding/ScanScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TapToScan extends StatefulWidget {
  const TapToScan({super.key});

  @override
  State<TapToScan> createState() => _TapToScanState();
}

class _TapToScanState extends State<TapToScan> {
  String scanedCode = "NONECODE" ;
  Map<dynamic,dynamic> information = {} ;
  TextEditingController IP_ADDRESS_CONTROLLER = new TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeShared();
  }

  initializeShared() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? IPADD = await sp.getString("IP") ;
    IP_ADDRESS_CONTROLLER = new TextEditingController(text: IPADD == null ? "" : IPADD );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            color: Color(0xFF34495e) ,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(height: 40,),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                    children: [
                      IconButton(
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Container(
                                  height: 200,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextField(
                                        decoration: InputDecoration(
                                          hintText: "اضف عنوان الطابعه" ,
                                          hintTextDirection: TextDirection.rtl ,
                                          hintStyle: TextStyle(
                                            // fontWeight: FontWeight.bold
                                          )
                                        ),
                                        controller: IP_ADDRESS_CONTROLLER ,
                                      ),
                                      SizedBox(height: 20,),
                                      ElevatedButton(
                                        onPressed: () async {
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          prefs.setString("IP", IP_ADDRESS_CONTROLLER.value.text);
                                          setState(() {

                                          });
                                        },
                                        child: Text("اضف")
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(
                          size: 30,
                          Icons.settings_outlined ,
                          color: Colors.white ,
                        )
                      ),
                      Text(
                        scanedCode == "NONECODE" ? "Scan" : "Code Scanned Successfully" ,
                        style: GoogleFonts.alumniSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: scanedCode == "NONECODE" ? 30 : 22 ,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ) ,
                      IconButton(
                        onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Report(),));
                        },
                        icon: Icon(
                          size: 30,
                          Icons.view_list_sharp ,
                          color: Colors.white ,
                        )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100,),
                scanedCode == "NONECODE" ?
                GestureDetector(
                  onTap: () async {
                    scanedCode = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScanScreen()));

                    BuildContext secondContext = context ;

                    showDialog(
                      barrierDismissible: false ,
                      barrierColor: Colors.transparent ,
                      context: context,
                      builder: (context) {
                        secondContext = context ;
                        return AlertDialog(
                          backgroundColor: Colors.transparent ,
                          content: Container(
                            color: Colors.transparent ,
                            child: LoadingAnimationWidget.beat(
                              color: Colors.white,
                              size: 150 ,
                            ),
                          ),
                        );
                      },
                    );

                    var dio = Dio();
                    var response = await dio.post(
                      "http://188.161.159.226:8081/qistas/search.php",
                      data: FormData.fromMap({
                        'code': '$scanedCode'
                      }),
                    );

                    Timer(Duration(seconds: 2), () {
                      information = response.data == null ? {} : (json.decode(response.data)) ;
                      Navigator.of(secondContext).pop();

                      if(information["success"] == false){
                        scanedCode = "NONECODE" ;
                        showDialog(
                          context: context,
                          builder: (context) {
                            secondContext = context ;
                            return AlertDialog(
                              content: Container(
                                child: Text(
                                  information["data"] != null ? "product is available" : "product is not available" ,
                                  textAlign: TextAlign.center ,
                                  style: GoogleFonts.alumniSans(
                                    textStyle: TextStyle(
                                      fontSize: 30 ,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ) ,
                              ),
                            );
                          },
                        );

                      }

                      setState(() {

                      });
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    decoration: BoxDecoration(
                      color: Color(0xFF34495e) ,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes the position of the shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "TAP TO SCAN" ,
                          style: GoogleFonts.alumniSans(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 30 ,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ) ,
                        Text(
                          "The app will require access to the camera" ,
                          style: GoogleFonts.alumniSans(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15 ,
                            ),
                          ),
                        ) ,
                        Image.asset(
                          "assets/images/animatedicon.png" ,
                          scale: 2,
                        )
                      ],
                    ),
                  ),
                ) :
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Now You Can display the product information" ,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.alumniSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 30 ,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ) ,
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF34495e) ,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes the position of the shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/animatedicon.png" ,
                            scale: 2,
                          ),
                          Text(
                            scanedCode ,
                            style: GoogleFonts.alumniSans(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: scanedCode == "NONECODE" ? 30 : 22 ,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ) ,
                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Information(information),));
                      },
                      child: Text(
                        "Information" ,
                        style: GoogleFonts.alumniSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 30 ,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.grey),
                      ),
                    ),
                  ],
                ) ,
              ],
            ),
          ),
      ),
    );
  }
}
