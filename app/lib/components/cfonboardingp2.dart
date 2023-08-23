import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CFOnboardingTwo extends StatefulWidget {
  const CFOnboardingTwo({super.key});

  @override
  State<CFOnboardingTwo> createState() => _CFOnboardingTwoState();
}

class _CFOnboardingTwoState extends State<CFOnboardingTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 212, 236, 205),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 30.0, bottom: 10.0),
                child: Column(
                  children: [
                    Text(
                      "Insights today for a wealthy tomorrow",
                      style: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Learn your spending habits, investment opportunities and more to gain insights today for a wealthy tomorrow and secure your financial future.",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300,
                        color: Color.fromARGB(255, 91, 92, 96),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Positioned(
                top: 350.0,
                right: -75.0,
                child: SvgPicture.asset('assets/onboardingtwo.svg'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
