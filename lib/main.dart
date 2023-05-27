// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vimigotech_assessment/View/Pages/home_page.dart';
import 'package:vimigotech_assessment/View/Pages/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  final SharedPreferences pref = await preferences;

  runApp(MyApp(
    isFirstTime: pref.getBool('is_first') ?? true,
  ));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  const MyApp({
    Key? key,
    required this.isFirstTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isFirstTime ? const OnboardingScreen() : const HomePage(),
    );
  }
}
