import 'package:flutter/material.dart';
import 'package:vimigotech_assessment/Controller/read_write_json.dart';
import 'package:vimigotech_assessment/Controller/time_mode.dart';
import 'package:vimigotech_assessment/Model/user.dart';
import 'package:vimigotech_assessment/View/Components/item_display.dart';
import 'package:vimigotech_assessment/View/Components/add_new_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<User> users = [];
  bool isTimeAgoActive = false;
  ReadWriteJson readWriteJson = ReadWriteJson();
  TimeModeControl timeMode = TimeModeControl();

  @override
  void initState() {
    intiMode();
    super.initState();
  }

  void intiMode() async {
    isTimeAgoActive = await timeMode.getMode();
    setState(() {
      isTimeAgoActive;
    });
  }

  AppBar myAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text('Attendance'),
      actions: [switcherTime()],
    );
  }

  Row switcherTime() {
    return Row(
      children: [
        Icon(isTimeAgoActive ? Icons.timelapse_rounded : Icons.timer_off_rounded),
        const SizedBox(
          width: 10,
        ),
        Switch(
          value: isTimeAgoActive,
          onChanged: (value) async {
            setState(() {
              isTimeAgoActive = value;
            });
            await timeMode.setTimeMode(mode: isTimeAgoActive);
          },
        ),
      ],
    );
  }

  ListView dataBuilder() {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return UserBoxDisplay(
          target: users[index],
          isTimeAgoActive: isTimeAgoActive,
        );
      },
    );
  }

  FutureBuilder buildBody() {
    return FutureBuilder(
      future: readWriteJson.readLocalJSON(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          users = snapshot.data!;
          users.sort(
            (a, b) => b.checkIn.compareTo(a.checkIn),
          );
          return dataBuilder();
        }
      },
    );
  }

  FloatingActionButton add() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        AddNewUser(context: context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: myAppBar(), body: buildBody(), floatingActionButton: add());
  }
}
