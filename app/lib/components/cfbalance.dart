import 'dart:math';
import 'package:CapitalFlowAI/components/cfconstants.dart';
import 'package:CapitalFlowAI/pages/welcome/cfsplash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CFBalance extends ConsumerStatefulWidget {
  final double spentPercentage;
  const CFBalance({super.key, required this.spentPercentage});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CFBalanceState();
}

class _CFBalanceState extends ConsumerState<CFBalance> {
  final indianRupeesFormat =
      NumberFormat.currency(name: "Rs. ", locale: 'en_IN', decimalDigits: 2);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: const RadialGradient(
          colors: [CFConstants.cardBlue, CFConstants.cardwhite],
          radius: 1.0,
          center: Alignment.topRight,
          stops: [0.2, 1],
        ),
        boxShadow: const [
          BoxShadow(
            spreadRadius: 4.0,
            blurRadius: 15.0,
            color: Colors.black26,
          ),
        ],
      ),
      child: Stack(
        children: [
          //squiggly line
          Positioned(
            top: 75,
            right: 60,
            child: SizedBox(
              height: 200,
              width: 300,
              child: CustomPaint(
                painter: CustomSineCurvePainter(
                  amplitude: 40,
                  frequency: 3.0,
                  phase: 9,
                  angle: pi / 8,
                ),
              ),
            ),
          ),
          //money spent text
          const Padding(
            padding: EdgeInsets.only(top: 40.0, left: 25.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Account Balance',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          //money spent value
          Padding(
            padding: const EdgeInsets.only(top: 70.0, left: 25.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                indianRupeesFormat.format(double.parse(ref
                        .read(userProvider.notifier)
                        .state!
                        .transactions['Payload'][0]['data'][0]['decryptedFI']
                    ['account']['summary']['currentBalance'])),
                style: const TextStyle(
                    fontSize: 17.5,
                    color: Colors.black,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          //Masked Account Number
          Padding(
            padding: const EdgeInsets.only(bottom: 45.0, right: 45.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                  "${ref.read(userProvider.notifier).state!.transactions['Payload'][0]['data'][0]['maskedAccNumber']}"),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 20.0, bottom: 25.0, right: 45.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "${ref.read(userProvider.notifier).state!.transactions['Payload'][0]['data'][0]['decryptedFI']['account']['summary']['type']}",
                style: const TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSineCurvePainter extends CustomPainter {
  final double amplitude;
  final double frequency;
  final double phase;
  final double angle;

  CustomSineCurvePainter({
    required this.amplitude,
    required this.frequency,
    required this.phase,
    required this.angle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final path = Path();

    final startX = width / 5;

    for (double x = startX; x <= width * 1.2; x += 1) {
      final y =
          amplitude * sin(((x + startX) / width * frequency * 2 * pi) + phase) +
              -height / 1.5;
      final rotatedX = x * cos(angle) - y * sin(angle);
      final rotatedY = x * sin(angle) + y * cos(angle);
      if (x == startX) {
        path.moveTo(rotatedX, rotatedY);
      } else {
        path.lineTo(rotatedX, rotatedY);
      }
    }

    final strokePaint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
