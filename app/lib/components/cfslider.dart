import 'package:CapitalFlowAI/pages/welcome/cfsplash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CFBalanceSlider extends ConsumerStatefulWidget {
  final double spentRatio;
  const CFBalanceSlider(this.spentRatio, {super.key});

  @override
  ConsumerState<CFBalanceSlider> createState() => _CFBalanceSliderState();
}

class _CFBalanceSliderState extends ConsumerState<CFBalanceSlider> {
  double width = 0.0;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      width = widget.spentRatio / 100;
      width = width >= 1 ? 1 : width;
      isVisible = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isVisible) {
      if (width >= 0.5) {
        return Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                spreadRadius: 1.0,
                blurRadius: 15.0,
                color: Colors.black26,
              ),
            ],
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            heightFactor: 1,
            widthFactor: width,
            child: Container(
              padding: const EdgeInsets.only(left: 20.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 105, 81, 243),
                borderRadius: width != 1.0
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      )
                    : BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Money Spent",
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Rs. ${(ref.read(userProvider.notifier).state!.monthlyBudget * (widget.spentRatio / 100)).toInt()}",
                    style: const TextStyle(fontSize: 17.0, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return Container(
          height: 100,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 105, 81, 243),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                spreadRadius: 1.0,
                blurRadius: 15.0,
                color: Colors.black26,
              ),
            ],
          ),
          child: FractionallySizedBox(
            heightFactor: 1,
            widthFactor: 1 - width,
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.only(left: 10.0, right: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: width != 0.0
                    ? const BorderRadius.only(
                        bottomRight: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      )
                    : BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Total Budget",
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Rs. ${(ref.read(userProvider.notifier).state!.monthlyBudget).toInt()}",
                    style: const TextStyle(fontSize: 17.0, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } else {
      return Container(
        height: 100,
        color: Colors.white,
      );
    }
  }
}