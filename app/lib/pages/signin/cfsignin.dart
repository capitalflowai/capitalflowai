import 'package:CapitalFlowAI/backend/cfserver.dart';
import 'package:CapitalFlowAI/components/cfuser.dart';
import 'package:CapitalFlowAI/pages/welcome/cfsplash.dart';
import 'package:CapitalFlowAI/routes/cfroute_names.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CFSignIn extends ConsumerStatefulWidget {
  const CFSignIn({super.key});

  @override
  ConsumerState<CFSignIn> createState() => _CFSignInState();
}

class _CFSignInState extends ConsumerState<CFSignIn> {
  final _formKey = GlobalKey<FormState>();
  bool selectSign = false;
  bool showPassword = false;
  String errorMessage = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");

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
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(
                top: 30.0, left: 65.0, right: 65.0, bottom: 30.0),
            children: [
              const Text(
                "CapitalFlow AI",
                style: TextStyle(
                  fontSize: 37,
                ),
              ),
              const SizedBox(height: 55),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    //email
                    Container(
                      key: const ValueKey<int>(0),
                      margin: const EdgeInsets.only(top: 35.0),
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
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //error message
              Align(
                alignment: Alignment.centerLeft,
                child: AnimatedOpacity(
                  opacity: errorMessage.isNotEmpty ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: errorMessage.isNotEmpty
                      ? Text(
                          errorMessage,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 220, 39, 26),
                          ),
                        )
                      : Container(),
                ),
              ),
              //sign in button
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTapDown: (details) {
                    setState(() {
                      selectSign = true;
                    });
                  },
                  onTapUp: (details) async {
                    setState(() {
                      selectSign = false;
                    });
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);

                        DocumentReference documentReference = FirebaseFirestore
                            .instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid);
                        DocumentSnapshot snapshot =
                            await documentReference.get();
                        Map<String, dynamic> data =
                            snapshot.data() as Map<String, dynamic>;
                        ref.read(userProvider.notifier).state = CFUser.fromMap(
                            data, FirebaseAuth.instance.currentUser);
                        if (ref
                            .read(userProvider.notifier)
                            .state!
                            .sessionID
                            .isNotEmpty) {
                          DocumentSnapshot documentSnapshot =
                              await documentReference
                                  .collection('data')
                                  .doc(ref
                                      .read(userProvider.notifier)
                                      .state!
                                      .sessionID)
                                  .get();
                          if (documentSnapshot.exists) {
                            ref
                                    .read(userProvider.notifier)
                                    .state!
                                    .transactions =
                                documentSnapshot.data() as Map<String, dynamic>;
                            Map<String, dynamic> data = ref
                                .read(userProvider.notifier)
                                .state!
                                .transactions;
                            data['budget'] = ref
                                .read(userProvider.notifier)
                                .state!
                                .monthlyBudget;
                            ref.read(userProvider.notifier).state!.spentRatio =
                                await CFServer.sliderGraph(data);
                          }
                        }
                        if (mounted) {
                          GoRouter.of(context)
                              .goNamed(CFRouteNames.homeRouteName);
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          errorMessage = 'No user found for that email.';
                        } else if (e.code == 'wrong-password') {
                          errorMessage = 'Incorrect password.';
                        }
                        Future.delayed(
                          const Duration(seconds: 3),
                          () {
                            errorMessage = "";
                            if (mounted) {
                              setState(() {});
                            }
                          },
                        );
                        setState(() {});
                      }
                    }
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
              ),
              const SizedBox(
                height: 25.0,
              ),
              //sign up page
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
            ],
          ),
        ),
      ),
    );
  }
}
