import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CFQuestion extends StatefulWidget {
  const CFQuestion({super.key, required this.question});

  final String question;

  @override
  State<CFQuestion> createState() => _CFQuestionState();
}

class _CFQuestionState extends State<CFQuestion> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 45.0, right: 45.0, top: 30.0),
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 244, 244, 244),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          widget.question,
          style: GoogleFonts.nunito(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17.0,
            ),
          ),
        ),
      ),
    );
  }
}
