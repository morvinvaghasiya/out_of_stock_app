import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String name;
  final GestureTapCallback? onTap;

  const CustomButton({Key? key, required this.name, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(name),
    );
  }
}
