import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/bloc/weather_bloc.dart';
import 'package:weatherapp/data/constants.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget getWeatherIcon(int code) {
    switch (code) {
      case >= 200 && < 300:
        return Image.asset('assets/icons/thunderstorm.png');
      case >= 300 && < 400:
        return Image.asset('assets/icons/drizzle.png');
      case >= 400 && < 500:
        return Image.asset('assets/icons/rainny.png');
      case >= 500 && < 600:
        return Image.asset('assets/icons/thunderstorm.png');
      case >= 600 && < 700:
        return Image.asset('assets/icons/snow.png');
      case >= 700 && < 800:
        return Image.asset('assets/icons/snowflake.png');
      case == 800:
        return Image.asset('assets/icons/sunny.png');
      case >= 801 && < 805:
        return Image.asset('assets/icons/winddy.png');

      default:
        return Image.asset('assets/icons/sunny.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ksizedboxheight = MediaQuery.of(context).size.height * 0.02;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ksizedboxheight * 2),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Align(
                alignment: const AlignmentDirectional(2, -0.3),
                child: Container(
                  height: ksizedboxheight * 15,
                  width: ksizedboxheight * 15,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.deepOrangeAccent),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(-2, -0.3),
                child: Container(
                  height: ksizedboxheight * 15,
                  width: ksizedboxheight * 15,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.deepOrangeAccent),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, -1.3),
                child: Container(
                  height: ksizedboxheight * 15,
                  decoration: const BoxDecoration(
                      shape: BoxShape.rectangle, color: Colors.green),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                child: BlocBuilder<WeatherBloc, WeatherState>(
                    builder: (context, state) {
                  if (state is WeatherLoaded) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                          "${state.weather.areaName}📍",
                            style: headerFontstyle
                          ),
                          SizedBox(height: ksizedboxheight),
                          Text(
                            '${state.weather.weatherDescription}'.toUpperCase(),
                            style: headerFontstyle.copyWith(
                              fontSize: 18
                            )
                          ),
                          SizedBox(
                            height: ksizedboxheight,
                          ),
                          SizedBox(
                            height: ksizedboxheight * 13,
                            child: Center(
                                child: getWeatherIcon(
                                    state.weather.weatherConditionCode!)),
                          ),
                          SizedBox(
                            height: ksizedboxheight * 3,
                          ),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${state.weather.temperature!.celsius!.round()} ℃",
                                  style: headerFontstyle.copyWith(
                                    fontSize: 40
                                  )
                                ),
                                SizedBox(
                                  height: ksizedboxheight,
                                ),
                                Text(
                                  "${state.weather.weatherMain}",
                                  style: headerFontstyle
                                ),
                                Text(
                                  DateFormat('EEEE dd ')
                                      .add_jm()
                                      .format(state.weather.date!),
                                  style: headerFontstyle.copyWith(
                                    fontSize: 15,
                                    color: Colors.grey
                                  )
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: ksizedboxheight * 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              DataWidget(
                                ksize: ksizedboxheight,
                                imageurl: 'assets/icons/sunrise.png',
                                title: 'sunrise',
                                subtitle: DateFormat()
                                    .add_jm()
                                    .format(state.weather.sunrise!),
                              ),
                              DataWidget(
                                ksize: ksizedboxheight,
                                imageurl: 'assets/icons/moon.png',
                                title: 'sunset',
                                subtitle: DateFormat()
                                    .add_jm()
                                    .format(state.weather.sunset!),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: ksizedboxheight,
                          ),
                          const Divider(),
                          SizedBox(
                            height: ksizedboxheight,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              DataWidget(
                                ksize: ksizedboxheight,
                                imageurl: 'assets/icons/temphigh.png',
                                title: 'Temp Max',
                                subtitle:
                                    '${state.weather.tempMax!.celsius!.round()} ℃',
                              ),
                              DataWidget(
                                ksize: ksizedboxheight,
                                imageurl: 'assets/icons/templow.png',
                                title: 'Temp Low',
                                subtitle:
                                    '${state.weather.tempMin!.celsius!.round()} ℃',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: ksizedboxheight,
                          )
                        ],
                      ),
                    );
                  } else {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.greenAccent)),
                        )
                      ],
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataWidget extends StatelessWidget {
  const DataWidget({
    Key? key,
    required this.imageurl,
    required this.title,
    required this.subtitle,
    required this.ksize,
  }) : super(key: key);

  final String imageurl;
  final String title;
  final String subtitle;
  final double ksize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: ksize * 3,
          child: Image.asset(imageurl),
        ),
        SizedBox(
          width: ksize,
        ),
        Column(
          children: [
            Text(
              title,
              style: headerFontstyle.copyWith(fontSize: 15,color: Colors.white)
            ),
            Text(subtitle)
          ],
        )
      ],
    );
  }
}
