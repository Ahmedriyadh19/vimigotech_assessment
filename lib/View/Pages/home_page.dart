import 'package:flutter/material.dart';
import 'package:toggle_list/toggle_list.dart';
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
  List<User> users = [];
  bool isTimeAgoActive = false;
  ReadWriteJson readWriteJson = ReadWriteJson();
  TimeModeControl timeMode = TimeModeControl();

  @override
  void initState() {
    super.initState();
    intiMode();
    fetchData();
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
    );
  }

  Future<void> fetchData() async {
    try {
      List<User> data = await readWriteJson.readLocalJSON();
      setState(() {
        users = data;
        users.sort((a, b) => b.checkIn.compareTo(a.checkIn));
      });
    } catch (_) {}
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
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index) {
        return UserBoxDisplay(
          target: users[index],
          isTimeAgoActive: isTimeAgoActive,
        );
      },
    );
  }

  search() {
    return TextField(
      decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          labelText: 'Search',
          prefixIcon: Icon(Icons.search_rounded)),
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  Container pin() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ToggleList(shrinkWrap: true, children: [
        ToggleListItem(
            title: const Center(
                child: Text(
              'Settings',
              style: TextStyle(fontSize: 20),
            )),
            leading: const Icon(Icons.settings),
            content: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(child: search()),
                    switcherTime(),
                  ],
                ),
              ],
            )),
      ]),
    );
  }

  Column buildBody() {
    return Column(
      children: [
        pin(),
        Expanded(child: users.isEmpty ? const Center(child: CircularProgressIndicator()) : dataBuilder()),
      ],
    );
  }

  FloatingActionButton add() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        AddNewUser(context: context, update: _update);
      },
    );
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: myAppBar(), body: buildBody(), floatingActionButton: add());
  }
}
