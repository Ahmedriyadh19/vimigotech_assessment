import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  final String label;
  final Function action;
  const MyTextButton({
    Key? key,
    required this.label,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(label),
      onPressed: () {
        action();
      },
    );
  }
}
