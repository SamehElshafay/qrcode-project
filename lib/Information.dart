import 'dart:convert';
import 'dart:typed_data';
import 'package:coding/TapToScan.dart';
import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as ima;
import 'package:dio/dio.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Information extends StatefulWidget {
  Map<dynamic,dynamic> data ;
  Information(this.data);
  @override
  State<Information> createState() => _InformationState(data);
}

class _InformationState extends State<Information> {
  Map<dynamic, dynamic> data;

  _InformationState(this.data);

  ScreenshotController screenshotController = new ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF34495e),
        leading: IconButton(
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TapToScan(),));
          },
          icon: Icon(CupertinoIcons.back),
        ),
      ),
      backgroundColor: Color(0xFF34495e),
      body: Container(
          color: Color(0xFF34495e),
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: Column(
              children: [
                SizedBox(height: 40,),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            size: 30,
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                          )
                      ),
                      Text(
                        "product information",
                        style: GoogleFonts.alumniSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            // Navigator.of(context).pop();
                            screenshotController.capture(delay: const Duration(milliseconds: 30)).then((capturedImage) async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              if (await prefs.getString("IP") != null)
                                testprint( (await prefs.getString("IP")).toString()  , capturedImage!);
                              else
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("يجب عليك اضافة عنوان الطابعة اولا"),
                                ));
                            });

                          },
                          icon: Icon(
                            size: 30,
                            Icons.local_printshop_outlined,
                            color: Colors.white,
                          )
                      ),
                    ],
                  ),
                ),
                Screenshot(
                  controller: screenshotController,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Table(
                      children: [
                        TableRow(
                            decoration: BoxDecoration(
                              color: Colors.black,
                            ),
                            children: [
                              Text(
                                "Barcode",
                                style: GoogleFonts.alumniSans(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                "itemCode",
                                style: GoogleFonts.alumniSans(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                "price",
                                style: GoogleFonts.alumniSans(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                "name",
                                style: GoogleFonts.alumniSans(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ]
                        ),
                        for(int i = 0; i < (data["data"] as List<dynamic>).length; i++)...[
                          TableRow(
                              decoration: BoxDecoration(
                                color: Colors.black38,
                              ),
                              children: [
                                Text(
                                  data["data"][i]["Barcode"].toString(),
                                  style: GoogleFonts.alumniSans(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  data["data"][i]["itemCode"].toString(),
                                  style: GoogleFonts.alumniSans(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  data["data"][i]["price"].toString(),
                                  style: GoogleFonts.alumniSans(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  data["data"][i]["name"].toString(),
                                  style: GoogleFonts.alumniSans(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ]
                          )
                        ]
                      ],
                    ),
                  ),
                )
              ]
          )
      ),
    );
  }

  Future<Type> testprint(String printerIp , Uint8List theimage) async {
    const PaperSize paper = PaperSize.mm58;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    final PosPrintResult res = await printer.connect(printerIp , port: 9100);

    if(res == PosPrintResult.success){
      await testRcipt( printer , theimage);
      print(res.msg);
      try{printer.drawer(pin: PosDrawer.pin2);} catch(e){}
      await Future.delayed(const Duration(seconds: 3),(){
        print("printer disconnected");
        printer.disconnect();
      });
    }

    return PosPrintResult ;
  }

  testRcipt(NetworkPrinter printer , Uint8List theimage){
    final ima.Image? image = ima.decodeImage(theimage) ;
    printer.image(image! , align: PosAlign.center);
    printer.cut();
  }
}
  // printReciptScreanShot_PAY(List<Item> data1 , String ip , double paid){
  //   showDialog(
  //     barrierDismissible: false ,
  //     context: context, builder: (context2) {
  //     return AlertDialog(
  //       content: Container(
  //           color: Colors.transparent,
  //           width: 100,
  //           height: 50 ,
  //           child: LinearProgressIndicator()
  //       ),
  //     );
  //   },
  //   );
  //
  //   double total = 0.0 ;
  //   data1.forEach((element) {
  //     total = total + (double.parse(element.price.toString()) * double.parse(element.count.toString())) ;
  //   });
  //   BuildContext context22 = context ;
  //   showDialog(
  //     context: context, builder: (context2) {
  //     context22 = context2 ;
  //     return AlertDialog(
  //       content: Container(
  //         width: 500,
  //         child: Column(
  //           children: [
  //             Screenshot(
  //               controller: screenshotController ,
  //               child: Column(
  //                 children: [
  //                   Image(
  //                     image: AssetImage("images/logonewicon.png"),
  //                     height: 100,
  //                   ),
  //                   Container(
  //                     child: Table(
  //                       columnWidths: {
  //                         0: FlexColumnWidth(1),
  //                         1: FlexColumnWidth(1),
  //                         2: FlexColumnWidth(1),
  //                       },
  //                       children: [
  //                         TableRow(
  //                           children: [
  //                             Center(
  //                               child: Text(
  //                                 "",
  //                                 style: TextStyle(
  //                                     fontSize: 30
  //                                 ),
  //                               ),
  //                             ),
  //                             Center(
  //                               child: Text(
  //                                 data["order_id"].toString(),
  //                                 style: TextStyle(
  //                                     fontSize: 30
  //                                 ),
  //                               ),
  //                             ),
  //                             Center(
  //                               child: Text(
  //                                 "",
  //                                 style: TextStyle(
  //                                     fontSize: 30
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         TableRow(
  //                           decoration: BoxDecoration(
  //                               border: Border.all(color: Colors.black) ,
  //                               color: Colors.black
  //                           ),
  //                           children: [
  //                             Center(
  //                               child: Text(
  //                                 "السعر",
  //                                 style: TextStyle(
  //                                     fontSize: 30 ,
  //                                     color: Colors.white
  //                                 ),
  //                               ),
  //                             ),
  //                             Center(
  //                               child: Text(
  //                                 "الكمية",
  //                                 style: TextStyle(
  //                                     fontSize: 30 ,
  //                                     color: Colors.white
  //                                 ),
  //                               ),
  //                             ),
  //                             Center(
  //                               child: Text(
  //                                 "الاسم",
  //                                 style: TextStyle(
  //                                     fontSize: 30,
  //                                     color: Colors.white
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         for(int i = 0 ; i < data1.length ; i++)...[
  //                           TableRow(
  //                             decoration: BoxDecoration(
  //                                 border: Border(bottom: BorderSide(width: 2,color: Colors.black) )
  //                             ),
  //                             children: [
  //                               Center(
  //                                 child: Container(
  //                                   padding: EdgeInsets.all(10),
  //                                   child: Text(
  //                                     data1[i].price.toString() ,
  //                                     style: TextStyle(
  //                                       fontSize: 20 ,
  //                                       color: Colors.black ,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                               Center(
  //                                 child: Container(
  //                                   padding: EdgeInsets.all(10),
  //                                   child: Text(
  //                                     data1[i].count.toString(),
  //                                     style: TextStyle(
  //                                       fontSize: 20 ,
  //                                       color: Colors.black ,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                               Center(
  //                                 child: Container(
  //                                   padding: EdgeInsets.all(10),
  //                                   child: Text(
  //                                     data1[i].name ,
  //                                     style: TextStyle(
  //                                         fontSize: 20 ,
  //                                         color: Colors.black
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           )
  //                         ],
  //                         TableRow(
  //                           decoration: BoxDecoration(
  //                             border: Border.all(color: Colors.black) ,
  //                             color: Colors.black ,
  //                           ),
  //                           children: [
  //                             Center(
  //                               child: Text(
  //                                 "${paid - total} :متبقي",
  //                                 style: TextStyle(
  //                                     fontSize: 25,
  //                                     color: Colors.white
  //                                 ),
  //                               ),
  //                             ),
  //                             Center(
  //                               child: Text(
  //                                 "$paid :دفع",
  //                                 style: TextStyle(
  //                                     fontSize: 25 ,
  //                                     color: Colors.white
  //                                 ),
  //                               ),
  //                             ),
  //                             Center(
  //                               child: Text(
  //                                 "$total :الاجمالي",
  //                                 style: TextStyle(
  //                                     fontSize: 25 ,
  //                                     color: Colors.white
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Center(
  //                     child: Text(
  //                       noteController.value.text.isEmpty ? "" : "Note : "+noteController.value.text  ,
  //                       style: TextStyle(
  //                           fontSize: 25,
  //                           color: Colors.black
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ) ,
  //             SizedBox(height: 10,),
  //           ],
  //         ),
  //       ),
  //     );
  //   },
  //   ).then((value){
  //
  //     });
  //   });
  //
  //   Future.delayed(const Duration(milliseconds: 400), () {
  //     Navigator.of(context22).pop();
  //   });
