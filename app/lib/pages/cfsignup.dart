import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class CFSignUp extends StatefulWidget {
  const CFSignUp({super.key});

  @override
  State<CFSignUp> createState() => _CFSignUpState();
}

class _CFSignUpState extends State<CFSignUp> {
  final _formKey = GlobalKey<FormState>();
  bool selectSign = false;
  String errorMessage = "";
  bool showPassword = false;
  bool showPasswordHint = false;
  bool passwordError1 = true;
  bool passwordError2 = true;
  bool passwordError3 = true;
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            padding: const EdgeInsets.only(
                top: 30.0, left: 65.0, right: 65.0, bottom: 30.0),
            shrinkWrap: true,
            children: [
              const Text(
                "CapitalFlow AI",
                style: TextStyle(
                  fontSize: 37,
                ),
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    //phone
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
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value!.isEmpty || value.length != 10) {
                            return "Check your phone number";
                          }
                          return null;
                        },
                        maxLength: 10,
                        decoration: InputDecoration(
                          counterText: "",
                          isDense: true,
                          fillColor: const Color.fromARGB(255, 246, 246, 246),
                          hintText: "phone number",
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
                    //email
                    Container(
                      key: const ValueKey<int>(0),
                      margin: const EdgeInsets.only(top: 55.0),
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
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty || !emailRegex.hasMatch(value)) {
                            return "Please check your email";
                          }
                          return null;
                        },
                        controller: emailController,
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
                    //password
                    Container(
                      key: const ValueKey<int>(2),
                      margin: const EdgeInsets.only(top: 55.0),
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
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please check your password";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _formKey.currentState!.validate();
                            showPasswordHint = true;
                            if (value.length > 8) {
                              passwordError1 = false;
                            } else {
                              passwordError1 = true;
                            }
                            if (value.contains(RegExp(r'[A-Z]'))) {
                              passwordError2 = false;
                            } else {
                              passwordError2 = true;
                            }
                            if (value.contains(RegExp(r'[0-9]'))) {
                              passwordError3 = false;
                            } else {
                              passwordError3 = true;
                            }
                            setState(() {});
                          } else {
                            setState(() {
                              showPasswordHint = false;
                            });
                          }
                        },
                        controller: passwordController,
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                          suffix: GestureDetector(
                            onTap: () {
                              showPassword = !showPassword;
                              setState(() {});
                            },
                            child: Icon(
                              !showPassword
                                  ? FeatherIcons.eyeOff
                                  : FeatherIcons.eye,
                            ),
                          ),
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
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: showPasswordHint
                      ? Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "\u2022 Must have more than 8 characters\n",
                                style: TextStyle(
                                  color: passwordError1
                                      ? const Color.fromARGB(255, 220, 39, 26)
                                      : Colors.green,
                                ),
                              ),
                              TextSpan(
                                text: "\u2022 At least one uppercase letter\n",
                                style: TextStyle(
                                  color: passwordError2
                                      ? const Color.fromARGB(255, 220, 39, 26)
                                      : Colors.green,
                                ),
                              ),
                              TextSpan(
                                text: "\u2022 At least one number",
                                style: TextStyle(
                                  color: passwordError3
                                      ? const Color.fromARGB(255, 220, 39, 26)
                                      : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
              ),
              GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    selectSign = true;
                  });
                },
                onTapUp: (details) async {
                  setState(() {
                    selectSign = false;
                  });
                  if (_formKey.currentState!.validate() &&
                      (!passwordError1 && !passwordError2 && !passwordError3)) {
                    try {
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      print(credential);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        errorMessage =
                            'The account already exists for that email.';
                        Future.delayed(
                          const Duration(seconds: 5),
                          () {
                            errorMessage = "";
                            setState(() {});
                          },
                        );
                      }
                      setState(() {});
                    } catch (e) {
                      print(e);
                    }
                  }
                },
                child: Align(
                  alignment: Alignment.center,
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
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: errorMessage.isNotEmpty
                    ? Text(
                        errorMessage,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 220, 39, 26)),
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
