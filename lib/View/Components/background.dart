// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MyBackground extends StatelessWidget {
  final Widget child;
  const MyBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('lib/Assets/background.png'), fit: BoxFit.cover),
      ),
      child: child,
    );
  }
}
