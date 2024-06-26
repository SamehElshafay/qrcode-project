import 'dart:async';
import 'package:coding/TapToScan.dart';
import 'package:flutter/material.dart';

class SplachScreen extends StatefulWidget {
  const SplachScreen({super.key});

  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {
  @override
  Widget build(BuildContext context) {
    map();
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Image.asset(
            'assets/images/logo.gif',
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 2,
          ),
        ),
      ),
    );
  }

  map(){
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => TapToScan()));
    });
  }
}
