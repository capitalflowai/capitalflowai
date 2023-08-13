import 'package:CapitalFlowAI/components/cfconstants.dart';
import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CFBalance extends ConsumerStatefulWidget {
  final double remainingPercentage;
  final double spentPercentage;

  const CFBalance(
      {super.key,
      required this.remainingPercentage,
      required this.spentPercentage});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CFBalanceState();
}

class _CFBalanceState extends ConsumerState<CFBalance> {
  List<double> stops = [];

  @override
  void initState() {
    super.initState();
    if (widget.remainingPercentage < widget.spentPercentage) {
      stops = [widget.remainingPercentage, widget.spentPercentage];
    } else if (widget.remainingPercentage > widget.spentPercentage) {
      stops = [widget.spentPercentage, widget.remainingPercentage];
    } else {
      double data = calculateAverage(
          [widget.remainingPercentage, widget.spentPercentage]);
      print(data);
    }
  }

  double calculateAverage(List<double> stops) {
    return stops.reduce((sum, value) => sum + value) / stops.length;
  }

  @override
  Widget build(BuildContext context) {
    print((widget.remainingPercentage - widget.spentPercentage).abs());
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.only(
          top: 30.0, left: 20.0, right: 20.0, bottom: 30.0),
      width: double.maxFinite,
      height: 175,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: (widget.remainingPercentage - widget.spentPercentage).abs() <=
                  0.15
              ? [
                  CFConstants.anotherColor,
                  const Color.fromARGB(255, 225, 98, 79),
                ]
              : widget.remainingPercentage > widget.spentPercentage
                  ? [
                      CFConstants.remainingColor,
                      CFConstants.balanceColor,
                    ]
                  : [
                      CFConstants.balanceColor,
                      CFConstants.remainingColor,
                    ],
          stops: (widget.remainingPercentage - widget.spentPercentage).abs() <=
                  0.15
              ? [0.3, 0.7]
              : widget.remainingPercentage <= widget.spentPercentage
                  ? [widget.remainingPercentage, widget.spentPercentage]
                  : [widget.spentPercentage, widget.remainingPercentage],
        ),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 0),
            spreadRadius: 1.0,
            blurRadius: 20.5,
            color: Colors.grey,
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Monthly Budget"),
              Text("5000"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Money Spent So Far"),
              Text("5000"),
            ],
          ),
        ],
      ),
    );
  }
}
