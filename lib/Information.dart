import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Information extends StatefulWidget {
  Map<dynamic,dynamic> data ;
  Information(this.data);

  @override
  State<Information> createState() => _InformationState(data);
}

class _InformationState extends State<Information> {
  Map<dynamic,dynamic> data ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF34495e) ,
      body: Container(
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
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      size: 30,
                      Icons.arrow_back_ios_rounded ,
                      color: Colors.white ,
                    )
                  ),
                  Text(
                    "product information" ,
                    style: GoogleFonts.alumniSans(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 22 ,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ) ,
                  IconButton(
                    onPressed: (){
                      // Navigator.of(context).pop();
                    },
                    icon: Icon(
                      size: 30,
                      Icons.view_list_sharp ,
                      color: Colors.white ,
                    )
                  ),
                ],
              ),
            ) ,
            Container(
              padding: EdgeInsets.all(10),
              child: Table(
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.black ,
                    ),
                    children: [
                      Text(
                        "Barcode",
                        style: GoogleFonts.alumniSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20 ,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "itemCode",
                        style: GoogleFonts.alumniSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20 ,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "price" ,
                        style: GoogleFonts.alumniSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20 ,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "name",
                        style: GoogleFonts.alumniSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20 ,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]
                  ) ,
                  for(int i = 0; i < (data["data"] as List<dynamic>).length ; i++)...[
                    TableRow(
                      decoration: BoxDecoration(
                        color: Colors.black38 ,
                      ),
                      children: [
                        Text(
                          data["data"][i]["Barcode"].toString() ,
                          style: GoogleFonts.alumniSans(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20 ,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          data["data"][i]["itemCode"].toString() ,
                          style: GoogleFonts.alumniSans(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20 ,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          data["data"][i]["price"].toString() ,
                          style: GoogleFonts.alumniSans(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20 ,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          data["data"][i]["name"].toString() ,
                          style: GoogleFonts.alumniSans(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20 ,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ]
                    )
                  ]
                ],
              ),
            )
          ]
        )
      ),
    );
  }

  _InformationState(this.data);
}
