import 'package:CapitalFlowAI/pages/welcome/cfsplash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CFSetTargets extends ConsumerStatefulWidget {
  const CFSetTargets({super.key});

  @override
  ConsumerState<CFSetTargets> createState() => _CFSetTargetsState();
}

class _CFSetTargetsState extends ConsumerState<CFSetTargets> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController eomBalanceController = TextEditingController();
  TextEditingController monthlyBudgetController = TextEditingController();
  bool selectedSubmit = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context2, state) {
        return Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height / 2.1,
          padding: const EdgeInsets.only(
              bottom: 0.0, top: 30.0, left: 20.0, right: 20.0),
          child: ListView(
            children: [
              const Text(
                "Set Targets",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    //eom balance
                    Container(
                      margin: const EdgeInsets.only(
                          top: 50.0, left: 50.0, right: 50.0),
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
                        controller: eomBalanceController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value!.isEmpty ||
                              double.parse(value) < 1.0 ||
                              double.parse(value) <
                                  double.parse(monthlyBudgetController.text)) {
                            return "Please check entered balance";
                          }

                          return null;
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                          counterText: "",
                          isDense: true,
                          fillColor: const Color.fromARGB(255, 246, 246, 246),
                          hintText: "EOM Balance",
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
                    //monthly budget
                    Container(
                      margin: const EdgeInsets.only(
                          top: 50.0, left: 50.0, right: 50.0),
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
                        controller: monthlyBudgetController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value!.isEmpty ||
                              double.parse(value) < 1.0 ||
                              double.parse(value) >
                                  double.parse(eomBalanceController.text)) {
                            return "Please check entered budget";
                          }
                          return null;
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                          counterText: "",
                          isDense: true,
                          fillColor: const Color.fromARGB(255, 246, 246, 246),
                          hintText: "Monthly Budget",
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
                    !isLoading
                        ? GestureDetector(
                            onTapDown: (details) {
                              state(() {
                                selectedSubmit = true;
                              });
                            },
                            onTapUp: (details) async {
                              state(() {
                                selectedSubmit = false;
                              });

                              if (_formKey.currentState!.validate()) {
                                isLoading = true;
                                setState(() {});
                                ref
                                        .read(userProvider.notifier)
                                        .state!
                                        .eomBalance =
                                    double.parse(eomBalanceController.text);
                                ref
                                        .read(userProvider.notifier)
                                        .state!
                                        .monthlyBudget =
                                    double.parse(monthlyBudgetController.text);
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(ref
                                        .read(userProvider.notifier)
                                        .state!
                                        .uid)
                                    .set(ref
                                        .read(userProvider.notifier)
                                        .state!
                                        .toMap());
                                Navigator.of(context).pop();
                              }
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 100),
                                margin: const EdgeInsets.only(top: 40.0),
                                padding: const EdgeInsets.only(
                                    top: 15.0,
                                    bottom: 15.0,
                                    left: 50.0,
                                    right: 50.0),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFF3369FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  shadows: [
                                    !selectedSubmit
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
                                  "I'm Ready!",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: const Color.fromARGB(255, 16, 64, 221),
                              size: 35.0,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
