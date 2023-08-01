import 'package:app/pages/components/cfonboardingp1.dart';
import 'package:app/pages/components/cfonboardingp2.dart';
import 'package:app/pages/components/cfonboardingp3.dart';
import 'package:app/routes/cfroute_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';

class CFOnboarding extends StatefulWidget {
  const CFOnboarding({super.key});

  @override
  State<CFOnboarding> createState() => _CFOnboardingState();
}

class _CFOnboardingState extends State<CFOnboarding> {
  int index = 0;
  PageController pageController = PageController();
  bool isPressed = false;

  List<Widget> onboardingScreens = [
    const CFOnboardingOne(),
    const CFOnboardingTwo(),
    const CFOnboardingThree()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (value) {
                  index = value;
                  setState(() {});
                },
                itemCount: 3,
                itemBuilder: (context, index) {
                  return onboardingScreens[index];
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: index == 0
                        ? 10
                        : index != 2
                            ? 5
                            : 0,
                    height: index == 0
                        ? 10
                        : index != 2
                            ? 5
                            : 0,
                    decoration: BoxDecoration(
                        color:
                            index == 0 ? Colors.purple : Colors.purple.shade300,
                        borderRadius: BorderRadius.circular(12.0)),
                  ),
                  const SizedBox(
                    width: 2.0,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: index == 1
                        ? 10
                        : index != 2
                            ? 5
                            : 0,
                    height: index == 1
                        ? 10
                        : index != 2
                            ? 5
                            : 0,
                    decoration: BoxDecoration(
                        color:
                            index == 1 ? Colors.purple : Colors.purple.shade300,
                        borderRadius: BorderRadius.circular(12.0)),
                  ),
                  const SizedBox(
                    width: 2.0,
                  ),
                  GestureDetector(
                    onTapDown: index == 2
                        ? (details) {
                            setState(() {
                              isPressed = true;
                            });
                            GoRouter.of(context).pushReplacementNamed(
                                CFRouteNames.welcomeRouteName);
                          }
                        : null,
                    onTapUp: index == 2
                        ? (details) {
                            setState(() {
                              isPressed = false;
                            });
                          }
                        : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: index == 2 ? 50 : 5,
                      height: index == 2 ? 50 : 5,
                      decoration: BoxDecoration(
                        color:
                            index == 2 ? Colors.purple : Colors.purple.shade300,
                        borderRadius:
                            BorderRadius.circular(index == 2 ? 100.0 : 12.0),
                        boxShadow: index == 2
                            ? [
                                BoxShadow(
                                  spreadRadius: !isPressed ? .5 : 0,
                                  blurRadius: !isPressed ? 7.5 : 0,
                                  color: Colors.black54,
                                ),
                              ]
                            : [],
                      ),
                      child: const Center(
                        child: Icon(
                          FeatherIcons.arrowRight,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
