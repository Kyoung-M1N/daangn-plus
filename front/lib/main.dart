import 'package:daangnpuls/homeView.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "당근 플러스",
      home: HomeView(),
      routes: {
        // "/": (_) => HomeView(),
      },
    );
  }
}
