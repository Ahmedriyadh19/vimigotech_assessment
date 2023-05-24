import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimigotech_assessment/Controller/read_write_json.dart';
import 'package:vimigotech_assessment/Model/user.dart';
import 'package:vimigotech_assessment/View/Components/item_display.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  List<User> users = [];
  bool isTimeAgoActive = true;
  ReadWriteJson readWriteJson = ReadWriteJson(path: 'lib/Data/dataset.json');

  @override
  void initState() {
    super.initState();
    getMode();
  }

  void getMode() async {
    final SharedPreferences pref = await preferences;
    setState(() {
      isTimeAgoActive = pref.getBool('timeMode') ?? false;
    });
  }

  void setTimeMode({required bool mode}) async {
    final SharedPreferences pref = await preferences;
    setState(() {
      pref.setBool('timeMode', mode);
    });
  }

  AppBar myAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text('Attendance'),
      actions: [switcherTime()],
    );
  }

  switcherTime() {
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
            setTimeMode(mode: isTimeAgoActive);
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
          return dataBuilder();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: myAppBar(), body: buildBody());
  }
}
