


import 'package:flutter/material.dart';
import 'splash.dart';

void main() { 
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(

    debugShowCheckedModeBanner: false,

    home: const Splash(),

    );
  
  }

}