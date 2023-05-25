import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:intl/intl.dart';
import 'package:vimigotech_assessment/Model/user.dart';
import 'package:vimigotech_assessment/Services/time_ago.dart';
import 'package:vimigotech_assessment/View/Pages/selected_user_page.dart';

class UserBoxDisplay extends StatelessWidget {
  final User target;
  final bool isTimeAgoActive;

  const UserBoxDisplay({
    Key? key,
    required this.target,
    required this.isTimeAgoActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => SelectedUserPage(
                      userDisplayed: target,
                      isTimeAgoActive: isTimeAgoActive,
                    )),
          );
        },
        trailing: const Icon(Icons.keyboard_arrow_right_rounded),
        leading: CircleAvatar(child: Text(target.user[0].toUpperCase())),
        title: Text(target.user),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(target.phone),
            Text(
              isTimeAgoActive ? CountTimeAgo(target.checkIn).timeAgo() : DateFormat('dd MMM yyyy, h:mm a').format(target.checkIn),
            ),
          ],
        ),
      ).asGlass(
        tintColor: Colors.black,
        clipBorderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}
