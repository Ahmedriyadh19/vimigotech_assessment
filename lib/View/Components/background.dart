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
        image: DecorationImage(image: AssetImage('lib/Assets/Background/background.png'), fit: BoxFit.cover),
      ),
      child: child,
    );
  }
}
