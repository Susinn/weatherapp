import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/bloc/weather_bloc.dart';
import 'package:weatherapp/data/constants.dart';

import 'views/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent)),
      home: FutureBuilder(
          future: _determinePosition(),
          builder: (context, snapshot) {
            final kheight = MediaQuery.of(context).size.height * 0.02;
            if (snapshot.hasData) {
              return BlocProvider(
                create: (context) =>
                    WeatherBloc()..add(GetWeather(snapshot.data as Position)),
                child: const MyHomePage(),
              );
            } else {
              return Scaffold(
                  body: Stack(children: [
                Align(
                  alignment: const AlignmentDirectional(2, -0.3),
                  child: Container(
                    height: kheight * 15,
                    width: kheight * 15,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.deepOrangeAccent),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(-2, -0.3),
                  child: Container(
                    height: kheight * 15,
                    width: kheight * 15,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.deepOrangeAccent),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, -1.3),
                  child: Container(
                    height: kheight * 15,
                    decoration: const BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.green),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text("WeatherApp", style: headingFontstyle),
                      ),
                    
                    ],
                  ),
                )
              ]));
            }
          }),
    );
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}
