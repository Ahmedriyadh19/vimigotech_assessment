import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toggle_list/toggle_list.dart';
import 'package:vimigotech_assessment/Controller/read_write_json.dart';
import 'package:vimigotech_assessment/Controller/time_mode.dart';
import 'package:vimigotech_assessment/Model/user.dart';
import 'package:vimigotech_assessment/View/Components/background.dart';
import 'package:vimigotech_assessment/View/Components/item_display.dart';
import 'package:vimigotech_assessment/View/Components/add_new_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> allUsers = [];
  List<User> filteredUsers = [];
  bool isTimeAgoActive = false;
  bool _isChecked = false;
  int _selectedValue = 2;
  ReadWriteJson readWriteJson = ReadWriteJson();
  TimeModeControl timeMode = TimeModeControl();

  @override
  void initState() {
    super.initState();
    intiMode();
    fetchData();
  }

  void sort() {
    switch (_selectedValue) {
      case 0:
        _isChecked ? filteredUsers.sort((a, b) => b.user.compareTo(a.user)) : filteredUsers.sort((a, b) => a.user.compareTo(b.user));
        break;
      case 1:
        _isChecked ? filteredUsers.sort((a, b) => b.phone.compareTo(a.phone)) : filteredUsers.sort((a, b) => a.phone.compareTo(b.phone));
        break;
      case 2:
        _isChecked ? filteredUsers.sort((a, b) => a.checkIn.compareTo(b.checkIn)) : filteredUsers.sort((a, b) => b.checkIn.compareTo(a.checkIn));
        break;
    }
  }

  void intiMode() async {
    isTimeAgoActive = await timeMode.getMode();
    setState(() {
      isTimeAgoActive;
    });
  }

  void _update() async {
    await fetchData();
    setState(() {});
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
        allUsers = data;
      });
      sort();
      filteredUsers = List.from(allUsers);
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
    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        Fluttertoast.showToast(
            msg: 'You have reached the end of the list', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1);
      }
    });
    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        return UserBoxDisplay(
          target: filteredUsers[index],
          isTimeAgoActive: isTimeAgoActive,
        );
      },
    );
  }

  TextField search() {
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
        setState(() {
          filteredUsers = allUsers
              .where((user) =>
                  user.user.toLowerCase().contains(value.toLowerCase()) ||
                  user.phone.toLowerCase().contains(value.toLowerCase()) ||
                  user.checkIn.toString().toLowerCase().contains(value.toLowerCase()))
              .toList();
        });
      },
    );
  }

  Container pin() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ToggleList(shrinkWrap: true, children: [
        ToggleListItem(
            title: const SizedBox(
              height: 60,
              child: Center(
                child: Text(
                  'Settings',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            leading: const Icon(Icons.settings),
            content: Column(
              children: [
                sortControl(),
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

  Row sortControl() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Column(
            children: [
              Radio(
                value: 0,
                groupValue: _selectedValue,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value!;
                    sort();
                  });
                },
              ),
              const Icon(Icons.person),
              const Text(
                'User Name',
                style: TextStyle(fontSize: 9),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Column(
            children: [
              Radio(
                value: 1,
                groupValue: _selectedValue,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value!;
                    sort();
                  });
                },
              ),
              const Icon(Icons.phone_android),
              const Text(
                'Phone Number',
                style: TextStyle(fontSize: 9),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Column(
            children: [
              Radio(
                value: 2,
                groupValue: _selectedValue,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value!;
                    sort();
                  });
                },
              ),
              const Icon(Icons.calendar_month_rounded),
              const Text(
                'Phone Number',
                style: TextStyle(fontSize: 9),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Column(
            children: [
              Checkbox(
                value: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value!;
                    sort();
                  });
                },
              ),
              _isChecked
                  ? const Icon(Icons.sort)
                  : Transform.flip(
                      flipY: true,
                      child: const Icon(Icons.sort),
                    ),
              Text(
                _isChecked ? 'Descending' : 'Ascending',
                style: const TextStyle(fontSize: 9),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildBody() {
    return Column(
      children: [
        pin(),
        Expanded(child: filteredUsers.isEmpty ? noData() : dataBuilder()),
      ],
    );
  }

  Column noData() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(
          height: 20,
        ),
        Text('No Data!'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MyBackground(child: buildBody()), floatingActionButton: add());
  }
}
