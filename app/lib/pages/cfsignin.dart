import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CFSignIn extends StatefulWidget {
  const CFSignIn({super.key});

  @override
  State<CFSignIn> createState() => _CFSignInState();
}

class _CFSignInState extends State<CFSignIn> {
  final _formKey = GlobalKey<FormState>();
  bool selectSign = false;
  String errorMessage = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 65.0, right: 65.0, bottom: 30.0),
          child: Column(
            children: [
              const Spacer(),
              const Text(
                "CapitalFlow AI",
                style: TextStyle(
                  fontSize: 37,
                ),
              ),
              const SizedBox(height: 75),
              Form(
                key: _formKey,
                child: Wrap(
                  runSpacing: 50.0,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 4),
                            spreadRadius: 1.0,
                            blurRadius: 10.0,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          isDense: true,
                          fillColor: const Color.fromARGB(255, 246, 246, 246),
                          hintText: "email",
                          contentPadding: const EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 4),
                            spreadRadius: 1.0,
                            blurRadius: 10.0,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          isDense: true,
                          fillColor: const Color.fromARGB(255, 246, 246, 246),
                          hintText: "password",
                          contentPadding: const EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: errorMessage.isNotEmpty ? Text(errorMessage) : null,
                ),
              ),
              GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    selectSign = true;
                  });
                },
                onTapUp: (details) {
                  setState(() {
                    selectSign = false;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  margin: const EdgeInsets.only(top: 40.0),
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 15.0, left: 50.0, right: 50.0),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF3369FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    shadows: [
                      !selectSign
                          ? const BoxShadow(
                              offset: Offset(0, 4),
                              color: Colors.black26,
                              blurRadius: 10,
                              spreadRadius: 1.0,
                            )
                          : const BoxShadow(
                              offset: Offset(0, 0),
                              spreadRadius: 2.0,
                              blurRadius: 1.0,
                              color: Colors.black12,
                            ),
                    ],
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).pushReplacementNamed('sign-up');
                },
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: Color(0xFF959595),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          color: Color(0xFF313131),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: ' now.',
                        style: TextStyle(
                          color: Color(0xFF959595),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
