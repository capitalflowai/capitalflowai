import 'package:CapitalFlowAI/routes/cfroute_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';

class CFWelcome extends StatefulWidget {
  const CFWelcome({super.key});

  @override
  State<CFWelcome> createState() => _CFWelcomeState();
}

class _CFWelcomeState extends State<CFWelcome> {
  bool signInClick = false;
  bool signUpClick = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 55.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Text(
                'Budgeting\nJust Got Simpler!',
                style: TextStyle(
                  fontSize: 55.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 50.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(FeatherIcons.arrowRight),
                    SizedBox(
                      width: 7.5,
                    ),
                    Expanded(
                      child: Text(
                        "Cut, Save and Thrive!",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Divider(
                thickness: 2.0,
                color: Colors.black,
              ),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTapDown: (details) {
                      setState(() {
                        signUpClick = true;
                      });
                    },
                    onTapUp: (details) {
                      setState(() {
                        signUpClick = false;
                      });
                      GoRouter.of(context)
                          .pushNamed(CFRouteNames.signUpRouteName);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50.0),
                        boxShadow: [
                          !signUpClick
                              ? const BoxShadow(
                                  offset: Offset(3, 5),
                                  spreadRadius: .1,
                                  blurRadius: 5.5,
                                  color: Colors.black38,
                                )
                              : const BoxShadow(
                                  offset: Offset(0, 0),
                                  spreadRadius: 0.1,
                                  blurRadius: 3.0,
                                  color: Colors.black26,
                                ),
                        ],
                      ),
                      child: const Text(
                        'Sign Up',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTapDown: (details) {
                      setState(() {
                        signInClick = true;
                      });
                    },
                    onTapUp: (details) {
                      setState(() {
                        signInClick = false;
                      });
                      GoRouter.of(context)
                          .pushNamed(CFRouteNames.signInRouteName);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 20.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 51, 105, 255),
                        borderRadius: BorderRadius.circular(50.0),
                        boxShadow: [
                          !signInClick
                              ? const BoxShadow(
                                  offset: Offset(3, 5),
                                  spreadRadius: .1,
                                  blurRadius: 5.5,
                                  color: Colors.black38,
                                )
                              : const BoxShadow(
                                  offset: Offset(0, 0),
                                  spreadRadius: 1.5,
                                  blurRadius: 1.0,
                                  color: Colors.black45,
                                ),
                        ],
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
