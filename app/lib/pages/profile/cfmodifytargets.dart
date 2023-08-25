import 'package:CapitalFlowAI/pages/welcome/cfsplash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CFModifyTargets extends ConsumerStatefulWidget {
  const CFModifyTargets({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CFModifyTargetsState();
}

class _CFModifyTargetsState extends ConsumerState<CFModifyTargets> {
  TextEditingController monthlyBudgetController = TextEditingController();
  TextEditingController eomController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 5,
              margin: const EdgeInsets.only(bottom: 50.0),
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 51, 105, 255),
              ),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      FeatherIcons.arrowLeft,
                      color: Colors.white,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Budget Details",
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 40.0, top: 40.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "EOM Balance",
                        style: GoogleFonts.nunito(
                            fontSize: 16.0, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 0.0, left: 0.0, right: 50.0),
                        child: TextFormField(
                          controller: eomController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty ||
                                double.parse(value) < 1.0 ||
                                double.parse(value) <
                                    double.parse(
                                        monthlyBudgetController.text)) {
                              return "Please check entered balance";
                            }

                            return null;
                          },
                          maxLines: 1,
                          decoration: const InputDecoration(
                            hintText: "0",
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15.0),
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 206, 58, 48),
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 206, 58, 48),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      Text(
                        "Target Monthly Budget",
                        style: GoogleFonts.nunito(
                            fontSize: 16.0, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 20.0),
                      //monthly budget
                      Container(
                        margin: const EdgeInsets.only(
                            top: 0.0, left: 0.0, right: 50.0),
                        child: TextFormField(
                          controller: monthlyBudgetController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty ||
                                double.parse(value) < 1.0 ||
                                double.parse(value) >
                                    double.parse(eomController.text)) {
                              return "Please check entered budget";
                            }
                            return null;
                          },
                          maxLines: 1,
                          decoration: const InputDecoration(
                            hintText: "0",
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15.0),
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 206, 58, 48),
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 206, 58, 48),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            Center(
              child: GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    ref.read(userProvider.notifier).state!.eomBalance =
                        double.parse(eomController.text);
                    ref.read(userProvider.notifier).state!.monthlyBudget =
                        double.parse(monthlyBudgetController.text);

                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(ref.read(userProvider.notifier).state!.uid)
                        .set(ref.read(userProvider.notifier).state!.toMap());
                    if (mounted) {
                      Navigator.of(context).pop(true);
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black),
                  child: const Text(
                    "Update Budget Details",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
