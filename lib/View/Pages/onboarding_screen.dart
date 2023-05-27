// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimigotech_assessment/View/Components/onboarding_image.dart';
import 'package:vimigotech_assessment/View/Pages/home_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPageIndex = 0;
  final List<OnboardingImage> _pages = [
    const OnboardingImage(
      title: 'Effortless Sorting',
      description:
          'Easily organize your data by various criteria. Take full control of the sorting order by choosing between ascending or descending arrangements.',
      imagePath: 'lib/Assets/Onboarding/0.png',
    ),
    const OnboardingImage(
      title: 'Flexible Time Display',
      description: 'With a simple toggle, change the display format of time and rest assured that your preference will be saved for future use.',
      imagePath: 'lib/Assets/Onboarding/1.png',
    ),
    const OnboardingImage(
      title: 'Powerful Data Search',
      description:
          'Harness the power of our advanced search feature to find specific information in any field of your data, including names, phone numbers, and check-in dates',
      imagePath: 'lib/Assets/Onboarding/2.png',
    ),
    const OnboardingImage(
      title: 'Record New Attendance',
      description:
          'Initiate the recording process by clicking this button. A convenient form will appear, ready to be filled out for the new record.',
      imagePath: 'lib/Assets/Onboarding/3.png',
    ),
    const OnboardingImage(
      title: 'Enter Attendance Details',
      description:
          'Complete the form to submit your new record accurately. This intuitive interface ensures seamless entry of essential information.',
      imagePath: 'lib/Assets/Onboarding/4.png',
    ),
    const OnboardingImage(
      title: 'Share Information Easily',
      description:
          'Effortlessly capture and share information as an image accompanied by text. Share records with others conveniently and efficiently',
      imagePath: 'lib/Assets/Onboarding/5.png',
    ),
  ];

  Padding skipBtn() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ElevatedButton(
        child: const Text('Skip'),
        onPressed: () async {
          final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
          final SharedPreferences pref = await preferences;
          pref.setBool('is_first', false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        },
      ),
    );
  }

  DotsIndicator dotsBar() {
    return DotsIndicator(
      dotsCount: _pages.length,
      position: _currentPageIndex,
      decorator: DotsDecorator(
        activeSize: const Size(18.0, 9.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  Expanded imagesSlider() {
    return Expanded(
      child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            autoPlayCurve: Curves.ease,
            autoPlayAnimationDuration: const Duration(seconds: 2),
            autoPlayInterval: const Duration(seconds: 5),
            height: double.maxFinite,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentPageIndex = index;
              });
            },
          ),
          items: _pages),
    );
  }

  Column bottomPart() {
    return Column(
      children: [dotsBar(), skipBtn()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [imagesSlider(), bottomPart()],
      ),
    );
  }
}
