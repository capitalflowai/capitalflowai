import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CFOnboardingThree extends StatefulWidget {
  const CFOnboardingThree({super.key});

  @override
  State<CFOnboardingThree> createState() => _CFOnboardingThreeState();
}

class _CFOnboardingThreeState extends State<CFOnboardingThree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          decoration: BoxDecoration(
            // color: const Color.fromARGB(255, 248, 238, 213),
            color: const Color.fromARGB(255, 204, 181, 251),
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
                      "Finance at your fingertips",
                      style: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Never again need to log your expense, we track it as you spend. Stay on top of your financial goals with personalized insights.",
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 91, 92, 96),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Positioned(
                top: 320.0,
                right: -90.0,
                child: SvgPicture.asset('assets/onboardingthree.svg'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
