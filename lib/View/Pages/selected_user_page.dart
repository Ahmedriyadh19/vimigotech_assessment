// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:intl/intl.dart';

import 'package:vimigotech_assessment/Model/user.dart';
import 'package:vimigotech_assessment/Services/time_ago.dart';
import 'package:vimigotech_assessment/View/Components/background.dart';

class SelectedUserPage extends StatelessWidget {
  final User userDisplayed;
  final bool isTimeAgoActive;
  const SelectedUserPage({
    Key? key,
    required this.isTimeAgoActive,
    required this.userDisplayed,
  }) : super(key: key);

  body({required BuildContext ctx}) {
    return Column(
      children: [backButton(ctx: ctx), dataDisplay()],
    );
  }

  dataDisplay() {
    return Container(
        margin: const EdgeInsets.all(18),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: CircleAvatar(
                  radius: 60,
                  child: Text(
                    userDisplayed.user[0].toUpperCase(),
                    style: const TextStyle(fontSize: 60),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 20),
                  Text(userDisplayed.user),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.phone_android_rounded),
                  const SizedBox(width: 20),
                  Text(userDisplayed.phone),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_rounded),
                  const SizedBox(width: 20),
                  Text(
                    isTimeAgoActive ? CountTimeAgo(userDisplayed.checkIn).timeAgo() : DateFormat('dd MMM yyyy, h:mm a').format(userDisplayed.checkIn),
                  ),
                ],
              ),
            )
          ],
        ).asGlass(
          tintColor: Colors.black,
          clipBorderRadius: BorderRadius.circular(12.0),
        ));
  }

  backButton({required BuildContext ctx}) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(ctx);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MyBackground(
      child: body(ctx: context),
    ));
  }
}
