import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'CONSTANTS.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey _globalKey = GlobalKey() ;
  late QRViewController scanController ;
  bool stop = false ;
  bool back = true ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ,
      body: Container(
        child: Stack(
          children: [
            QRView(
              cameraFacing: back ? CameraFacing.back : CameraFacing.front ,
              key: _globalKey,
              onQRViewCreated: (QRViewController controller) {
                scanController = controller ;
                controller.scannedDataStream.listen((scanData) {
                  controller.stopCamera();
                  print("===> "+scanData.code.toString());
                  Timer(Duration(seconds: 2), () {
                    Navigator.of(context).pop(scanData.code);
                  });
                });
              },
            ),
            Positioned(
              bottom: 5 ,
              right: 5 ,
              child: IconButton(
                onPressed: (){
                  if(stop) {
                    stop = false;
                    scanController.resumeCamera();
                  } else {
                    stop = true;
                    scanController.stopCamera();
                  }
                  setState(() {

                  });
                },
                icon: Icon(
                  stop ? Icons.stop : Icons.circle ,
                  color: Colors.white,
                ),
              )
            ),
            Positioned(
              bottom: 40 ,
              right: 5 ,
              child: IconButton(
                onPressed: (){
                  if(back) {
                    back = false ;
                  } else {
                    back = true;
                  }
                  setState(() {

                  });
                },
                icon: Icon(
                  back ? Icons.back_hand : Icons.front_hand ,
                  color: Colors.white,
                ),
              )
            ),
            Positioned(
              left : 0,
              top: MediaQuery.of(context).size.height / 4,
              child: Container(
                width: MediaQuery.of(context).size.width ,
                height: MediaQuery.of(context).size.height / 2 ,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 100 ,
                          height: 100 ,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.red ,
                                width: 2,
                              ) ,
                              top: BorderSide(
                                color: Colors.red ,
                                width: 2,
                              )
                            )
                          ),
                        ),
                        Container(
                          width: 100 ,
                          height: 100 ,
                          decoration: BoxDecoration(
                            border: Border(
                              right : BorderSide(
                                color: Colors.red ,
                                width: 2,
                              ) ,
                              top: BorderSide(
                                color: Colors.red ,
                                width: 2,
                              )
                            )
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 100 ,
                          height: 100 ,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.red ,
                                width: 2,
                              ) ,
                              bottom: BorderSide(
                                color: Colors.red ,
                                width: 2,
                              )
                            )
                          ),
                        ),
                        Container(
                          width: 100 ,
                          height: 100 ,
                          decoration: BoxDecoration(
                            border: Border(
                              right : BorderSide(
                                color: Colors.red ,
                                width: 2,
                              ) ,
                              bottom: BorderSide(
                                color: Colors.red ,
                                width: 2,
                              )
                            )
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
