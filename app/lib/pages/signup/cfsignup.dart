import 'package:CapitalFlowAI/backend/cfsetu.dart';
import 'package:CapitalFlowAI/components/cfavatar.dart';
import 'package:CapitalFlowAI/components/cfconstants.dart';
import 'package:CapitalFlowAI/components/cfuser.dart';
import 'package:CapitalFlowAI/pages/welcome/cfsplash.dart';
import 'package:CapitalFlowAI/routes/cfroute_names.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

final consentAcceptCheck = StateProvider<bool>((ref) {
  bool temp = false;
  return temp;
});

class CFSignUp extends ConsumerStatefulWidget {
  const CFSignUp({super.key});

  @override
  ConsumerState<CFSignUp> createState() => _CFSignUpState();
}

class _CFSignUpState extends ConsumerState<CFSignUp> {
  int selectedAvatar = -1;
  bool showAvatarError = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  ScrollController controller = ScrollController();
  bool selectSign = false;
  bool selectConsent = false;
  String errorMessage = "";
  bool showPassword = false;
  bool showPasswordHint = false;
  bool passwordError1 = true;
  bool passwordError2 = true;
  bool passwordError3 = true;
  bool isLoadingConsent = false;

  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");

  @override
  void initState() {
    super.initState();
  }

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
      key: _scaffoldKey,
      body: SafeArea(
        child: Center(
          child: ListView(
            controller: controller,
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
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAvatar = 0;
                        showAvatarError = false;
                      });
                    },
                    child: CFAvatar(
                      name: "assets/maleAvatar.png",
                      width: 75,
                      color: CFConstants.maleColor,
                      isSelected: selectedAvatar == 0
                          ? 1
                          : showAvatarError
                              ? -1
                              : 0,
                      isBorder: true,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAvatar = 1;
                        showAvatarError = false;
                      });
                    },
                    child: CFAvatar(
                      name: "assets/femaleAvatar.png",
                      width: 75,
                      color: CFConstants.femaleColor,
                      isSelected: selectedAvatar == 1
                          ? 1
                          : showAvatarError
                              ? -1
                              : 0,
                      isBorder: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50.0),
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
                    //name
                    Container(
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
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Name cannot be empty";
                          }
                          return null;
                        },
                        maxLength: 10,
                        decoration: InputDecoration(
                          counterText: "",
                          isDense: true,
                          fillColor: const Color.fromARGB(255, 246, 246, 246),
                          hintText: "name",
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
              //sign up button
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
                      (!passwordError1 && !passwordError2 && !passwordError3) &&
                      selectedAvatar != -1) {
                    showModalBottomSheet(
                      context: _scaffoldKey.currentContext!,
                      builder: (context2) {
                        return StatefulBuilder(builder: (context2, state) {
                          return Container(
                            width: double.maxFinite,
                            height: MediaQuery.of(context).size.height / 2.5,
                            padding: const EdgeInsets.only(
                              bottom: 30.0,
                              top: 30.0,
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  FeatherIcons.shield,
                                  color: Color.fromARGB(255, 25, 127, 210),
                                ),
                                const SizedBox(height: 20.0),
                                const Text(
                                  "Consent Required",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                const SizedBox(height: 15.0),
                                const Text(
                                  "This will redirect you to an external website",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                                !isLoadingConsent
                                    ? GestureDetector(
                                        onTapDown: (details) {
                                          state(() {
                                            selectConsent = true;
                                          });
                                        },
                                        onTapUp: (details) async {
                                          state(() {
                                            selectConsent = false;
                                            isLoadingConsent = true;
                                          });
                                          // GoRouter.of(context).pushNamed(
                                          //     "webview",
                                          //     pathParameters: {
                                          //       'url': "google"
                                          //     }).then((value) {
                                          //   // GoRouter.of(context).pushNamed(
                                          //   //     CFRouteNames.homeRouteName);
                                          // });

                                          try {
                                            await FirebaseAuth.instance
                                                .createUserWithEmailAndPassword(
                                              email: emailController.text,
                                              password: passwordController.text,
                                            );
                                            FirebaseAuth.instance.currentUser!
                                                .updateDisplayName(
                                                    nameController.text);
                                            Map response =
                                                await SetuAPI.createConsent(
                                                    phoneController.text);
                                            if (response.isNotEmpty) {
                                              if (mounted) {
                                                GoRouter.of(context).pushNamed(
                                                    "webview",
                                                    pathParameters: {
                                                      'url': response['id']
                                                    }).then((value) async {
                                                  FirebaseAuth
                                                      .instance.currentUser!
                                                      .reload();
                                                  if (ref
                                                      .read(consentAcceptCheck
                                                          .notifier)
                                                      .state) {
                                                    Map consentDetails =
                                                        await SetuAPI
                                                            .getConsent(
                                                                response['id']);
                                                    String sessionID =
                                                        await SetuAPI
                                                            .createDataSesion(
                                                                response['id']);
                                                    ref
                                                            .read(userProvider
                                                                .notifier)
                                                            .state =
                                                        CFUser.fromMap(
                                                            {
                                                          'consentID':
                                                              response['id'],
                                                          'hasConsented': true,
                                                          'sessionID':
                                                              sessionID,
                                                          'consentDetails':
                                                              consentDetails,
                                                          'eomBalance': 0.0,
                                                          'monthlyBudget': 0.0,
                                                          'avatar':
                                                              selectedAvatar ==
                                                                      0
                                                                  ? "maleAvatar"
                                                                  : 'femaleAvatar'
                                                        },
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser);
                                                    FirebaseFirestore.instance
                                                        .collection("users")
                                                        .doc(ref
                                                            .read(userProvider
                                                                .notifier)
                                                            .state!
                                                            .uid)
                                                        .set(ref
                                                            .read(userProvider
                                                                .notifier)
                                                            .state!
                                                            .toMap());
                                                  } else {
                                                    ref
                                                            .read(userProvider
                                                                .notifier)
                                                            .state =
                                                        CFUser.fromMap(
                                                            {
                                                          'consentID': '',
                                                          'hasConsented': false,
                                                          'consentDetails': Map<
                                                              String,
                                                              dynamic>.from({}),
                                                          'eomBalance': 0.0,
                                                          'monthlyBudget': 0.0,
                                                          'avatar':
                                                              selectedAvatar ==
                                                                      0
                                                                  ? "maleAvatar"
                                                                  : 'femaleAvatar'
                                                        },
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser);
                                                  }

                                                  if (mounted) {
                                                    GoRouter.of(context)
                                                        .goNamed(CFRouteNames
                                                            .homeRouteName);
                                                  }
                                                });
                                              }
                                            }
                                          } on FirebaseAuthException catch (e) {
                                            Navigator.of(context).pop();
                                            if (e.code ==
                                                'email-already-in-use') {
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
                                          }
                                        },
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 100),
                                          margin:
                                              const EdgeInsets.only(top: 40.0),
                                          padding: const EdgeInsets.only(
                                              top: 15.0,
                                              bottom: 15.0,
                                              left: 50.0,
                                              right: 50.0),
                                          decoration: ShapeDecoration(
                                            color: const Color(0xFF3369FF),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            shadows: [
                                              !selectConsent
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
                                            "I Accept",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(top: 25.0),
                                        child: LoadingAnimationWidget
                                            .staggeredDotsWave(
                                          color: const Color.fromARGB(
                                              255, 16, 64, 221),
                                          size: 35.0,
                                        ),
                                      ),
                                const SizedBox(height: 10.0),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel"),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                    ).then((value) {
                      setState(() {
                        isLoadingConsent = false;
                      });
                    });
                  } else if (selectedAvatar == -1) {
                    setState(() {
                      showAvatarError = true;
                    });
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
                          color: Color.fromARGB(255, 220, 39, 26),
                        ),
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
