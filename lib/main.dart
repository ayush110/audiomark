import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songhut/constants.dart';
import 'package:songhut/provider/songModelProvider.dart';
import 'package:songhut/screens/homepage/home_page.dart';
import 'package:songhut/screens/splash_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => SongModelProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Naviation Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always,
          rangeValueIndicatorShape: PaddleRangeSliderValueIndicatorShape(),
          trackHeight: 2,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
