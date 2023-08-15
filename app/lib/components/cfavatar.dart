import 'package:flutter/material.dart';

class CFAvatar extends StatelessWidget {
  final String name;
  final double width;
  final Color color;
  final int isSelected;
  final bool isBorder;
  const CFAvatar({
    super.key,
    required this.name,
    required this.width,
    required this.color,
    required this.isSelected,
    required this.isBorder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
          border: isBorder
              ? Border.all(
                  color: isSelected == 1
                      ? Colors.green
                      : isSelected == 0
                          ? Colors.grey
                          : Colors.red,
                  width: 3.0)
              : null,
          borderRadius: BorderRadius.circular(100.0),
          color: color),
      width: width,
      child: Image.asset(name),
    );
  }
}
