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
      color: const Color.fromARGB(255, 51, 105, 255),
      text: message,
      isSender: isSender,
      textStyle: const TextStyle(color: Colors.white, fontSize: 15.5),
    );
  }
}
