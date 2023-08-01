import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CFOnboardingOne extends StatefulWidget {
  const CFOnboardingOne({super.key});

  @override
  State<CFOnboardingOne> createState() => _CFOnboardingOneState();
}

class _CFOnboardingOneState extends State<CFOnboardingOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 205, 227, 243),
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
                      "New approach for your\nFinance",
                      style: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Now your finances are in one place and always under control",
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
                child: SvgPicture.asset('assets/onboardingone.svg'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
