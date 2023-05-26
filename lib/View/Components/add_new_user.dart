// ignore_for_file: use_build_context_synchronously
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vimigotech_assessment/Controller/read_write_json.dart';
import 'package:vimigotech_assessment/Model/user.dart';
import 'package:vimigotech_assessment/View/Components/text_button.dart';
import 'package:vimigotech_assessment/View/Components/text_field.dart';

class AddNewUser {
  final BuildContext context;
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  DateTime? selectedDateTime;
  String? _errors;
  List<Widget> _listInput = [];
  bool _hasError = false;
  final Function update;

  AddNewUser({
    required this.context,
    this.selectedDateTime,
    required this.update,
  }) {
    _init();
    _showMyDialog();
  }

  void _init() {
    _listInput = [
      MyTextField(isPhoneNumber: false, name: 'User name', myController: _userName, icons: Icons.person),
      MyTextField(
        isPhoneNumber: true,
        name: 'Phone',
        myController: _phone,
        icons: Icons.phone_android_rounded,
      )
    ];
  }

  AlertDialog dialog({required Function setState}) {
    return AlertDialog(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.checklist_rounded,
            size: 35.0,
          ),
          Text('New Attendance')
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(children: [
          _listInput[0],
          _listInput[1],
          pickerTimeRow(state: setState),
          if (_hasError && _errors != null)
            Center(
                child: Text(
              _errors!,
              style: const TextStyle(color: Colors.red),
            ))
        ]),
      ),
      actions: [
        MyTextButton(label: 'Cancel', action: cancelBtnAction),
        MyTextButton(
            label: 'Approve',
            action: () {
              approveBtnAction(state: setState);
            }),
      ],
    );
  }

  void cancelBtnAction() {
    Navigator.of(context).pop();
  }

  void approveBtnAction({required Function state}) async {
    if (looksGood(state: state)) {
      ReadWriteJson readWriteJson = ReadWriteJson();
      User temp = User(user: _userName.text, phone: _phone.text, checkIn: selectedDateTime!);
      List<User> users = await readWriteJson.readLocalJSON();
      users.add(temp);
      await readWriteJson.writeLocalJSON(users);
      cancelBtnAction();
      update();
      successACtion();
    }
  }

  Future successACtion() {
    return AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: 'Success',
      desc: 'successfully completed the action',
      btnOkOnPress: () {},
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {},
    ).show();
  }

  bool looksGood({required Function state}) {
    state(() {
      validation(isPhone: false, value: _userName.text);
      validation(isPhone: true, value: _phone.text);

      if (selectedDateTime == null) {
        _errors = 'Can\'t be empty';
        _hasError = true;
      } else {
        _errors = null;
        _hasError = false;
      }
    });

    if (_hasError) {
      return false;
    } else {
      return true;
    }
  }

  void validation({required String value, required bool isPhone}) {
    if (value.isNotEmpty) {
      if (value.trim().isNotEmpty) {
        if (isPhone) {
          if (value.length < 12 && value.length > 8) {
            //01119234237
            if (double.tryParse(value) != null) {
              _errors = null;
              _hasError = false;
            } else {
              _errors = 'there\'s a letter';
              _hasError = true;
            }
          } else {
            _errors = 'Invalid phone number';
            _hasError = true;
          }
        } else {
          _errors = null;
          _hasError = false;
        }
      } else {
        _errors = 'Can\'t be space only';
        _hasError = true;
      }
    } else {
      _errors = 'Can\'t be empty';
      _hasError = true;
    }
  }

  Row pickerTimeRow({required Function state}) {
    return Row(
      mainAxisAlignment: selectedDateTime != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.calendar_month_rounded),
          onPressed: () => _selectDateTime(context: context, setState: state),
        ),
        if (selectedDateTime != null) Expanded(child: Text(DateFormat('dd MMM yyyy, h:mm a').format(selectedDateTime!)))
      ],
    );
  }

  Future<void> _selectDateTime({required BuildContext context, required Function setState}) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return dialog(setState: setState);
          },
        );
      },
    );
  }
}
