// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vimigotech_assessment/Model/user.dart';
import 'package:vimigotech_assessment/Services/time_ago.dart';
import 'package:vimigotech_assessment/View/Components/background.dart';

class SelectedUserPage extends StatefulWidget {
  final User userDisplayed;
  final bool isTimeAgoActive;

  const SelectedUserPage({
    Key? key,
    required this.isTimeAgoActive,
    required this.userDisplayed,
  }) : super(key: key);

  @override
  State<SelectedUserPage> createState() => _SelectedUserPageState();
}

class _SelectedUserPageState extends State<SelectedUserPage> {
  final ScreenshotController screenshotController = ScreenshotController();
  bool _isShot = false;

  Column body({required BuildContext ctx}) {
    return Column(
      children: [backButton(ctx: ctx), Screenshot(controller: screenshotController, child: dataDisplay()), share()],
    );
  }

  Padding oneRow({required String txt, required IconData iconData}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(iconData),
          const SizedBox(width: 20),
          Text(txt),
        ],
      ),
    );
  }

  Padding pic() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: CircleAvatar(
          radius: 60,
          child: Text(
            widget.userDisplayed.user[0].toUpperCase(),
            style: const TextStyle(fontSize: 60),
          )),
    );
  }

  Container dataDisplay() {
    return Container(
        decoration: BoxDecoration(color: _isShot ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(12.0)),
        margin: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            pic(),
            oneRow(iconData: Icons.person, txt: widget.userDisplayed.user),
            oneRow(iconData: Icons.phone_android_rounded, txt: widget.userDisplayed.phone),
            oneRow(
              iconData: Icons.calendar_month_rounded,
              txt: widget.isTimeAgoActive
                  ? CountTimeAgo(widget.userDisplayed.checkIn).timeAgo()
                  : DateFormat('dd MMM yyyy, h:mm a').format(widget.userDisplayed.checkIn),
            )
          ],
        ).asGlass(
          tintColor: _isShot ? Colors.white : Colors.black,
          clipBorderRadius: BorderRadius.circular(12.0),
        ));
  }

  ClipRRect share() {
    return IconButton(
      icon: const Icon(Icons.share_rounded),
      onPressed: () async {
        setState(() {
          _isShot = true;
        });
        final b = await screenshotController.capture();
        await saveImage(bytes: b);
        await loadImage();
        setState(() {
          _isShot = false;
        });
      },
    ).asGlass(
      tintColor: Colors.black,
      clipBorderRadius: BorderRadius.circular(10),
    );
  }

  saveImage({required var bytes}) async {
    final appStorages = await getApplicationDocumentsDirectory();
    final file = File('${appStorages.path}/image.png');
    file.writeAsBytes(bytes);
  }

  loadImage() async {
    final appStorages = await getApplicationDocumentsDirectory();
    final file = XFile('${appStorages.path}/image.png');

    if (file.path.isNotEmpty) {
      debugPrint(widget.userDisplayed.toString());
      Share.shareXFiles([file], text: widget.userDisplayed.toStringPrint(format: widget.isTimeAgoActive));
    }
  }

  Align backButton({required BuildContext ctx}) {
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
