import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';

class CFUserMessage extends StatelessWidget {
  final String message;
  final bool isSender;
  const CFUserMessage(
      {super.key, required this.message, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return BubbleNormal(
      color: isSender
          ? const Color.fromARGB(255, 51, 105, 255)
          : const Color.fromARGB(255, 213, 244, 255),
      text: message,
      isSender: isSender,
      textStyle: TextStyle(
          color: isSender ? Colors.white : Colors.black, fontSize: 15.5),
    );
  }
}
