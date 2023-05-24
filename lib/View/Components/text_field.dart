import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String name;
  final TextEditingController myController;
  final IconData icons;
  final bool isPhoneNumber;

  const MyTextField({
    Key? key,
    required this.name,
    required this.myController,
    required this.icons,
    required this.isPhoneNumber,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  String? errors;

  void validation({required String value}) {
    setState(() {
      if (value.isNotEmpty) {
        if (value.trim().isNotEmpty) {
          if (widget.isPhoneNumber) {
            if (value.length < 12 && value.length > 8) {
              //01119234237
              if (double.tryParse(value) != null) {
                errors = null;
              } else {
                errors = 'there\'s a letter';
              }
            } else {
              errors = 'Invalid phone number';
            }
          } else {
            errors = null;
          }
        } else {
          errors = 'Can\'t be space only';
        }
      } else {
        errors = 'Can\'t be empty';
      }
    });

  
  }

  InputDecoration boxDecor() {
    return InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      labelText: widget.name,
      errorText: errors,
      prefixIcon: Icon(widget.icons),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: boxDecor(),
      onChanged: (value) {
        validation(value: value);
      },
      controller: widget.myController,
      keyboardType: widget.isPhoneNumber ? TextInputType.phone : TextInputType.name,
    );
  }
}
