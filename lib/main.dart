import 'package:flutter/material.dart';
import 'package:quran_app/screens/welcome_screen.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}
