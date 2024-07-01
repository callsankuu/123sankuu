import 'package:flutter/material.dart';
import 'package:maps/polyline.dart';
import 'package:maps/weatherAPI/weather.dart';
import 'package:maps/weatherAPI/weather2.dart';


import 'Gmaps.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
     debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:WeatherApp(),
    );
  }
}
