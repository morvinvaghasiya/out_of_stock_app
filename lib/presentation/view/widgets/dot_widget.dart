import 'package:flutter/material.dart';

class DotWidget extends StatelessWidget {
  final int activeIndex;
  final int dotIndex;

  const DotWidget({Key? key, required this.activeIndex, required this.dotIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 10.0,
        width: 10.0,
        decoration: BoxDecoration(
            color:
                (dotIndex == activeIndex) ? Colors.black38 : Colors.grey[200],
            shape: BoxShape.circle),
      ),
    );
  }
}
