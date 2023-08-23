import 'package:CapitalFlowAI/components/cfavatar.dart';
import 'package:CapitalFlowAI/components/cfconstants.dart';
import 'package:CapitalFlowAI/pages/profile/cfmodifytargets.dart';
import 'package:CapitalFlowAI/pages/profile/cfrevokeconsent.dart';
import 'package:CapitalFlowAI/pages/welcome/cfsplash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CFProfile extends ConsumerStatefulWidget {
  const CFProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CFProfileState();
}

class _CFProfileState extends ConsumerState<CFProfile> {
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool updateNameSelect = false;
  bool updateBudgetDetails = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
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
                          GoRouter.of(context).pop(updateBudgetDetails);
                        },
                        child: const Icon(
                          FeatherIcons.arrowLeft,
                          color: Colors.white,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Profile",
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
                Positioned.fill(
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white, width: 5.0),
                      ),
                      child: CFAvatar(
                          name:
                              "assets/${ref.read(userProvider.notifier).state!.avatar}.png",
                          width: 120,
                          color:
                              ref.read(userProvider.notifier).state!.avatar ==
                                      "maleAvatar"
                                  ? CFConstants.maleColor
                                  : CFConstants.femaleColor,
                          isSelected: -1,
                          isBorder: false),
                    ),
                  ),
                ),
              ],
            ),
            //sticky header
            Container(
              margin: const EdgeInsets.only(top: 30.0, bottom: 10.0),
              padding: const EdgeInsets.only(left: 15.0, top: 5.0, bottom: 5.0),
              width: double.maxFinite,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 246, 246, 246),
              ),
              child: Text(
                "Your data",
                style: GoogleFonts.nunito(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.5,
                  ),
                ),
              ),
            ),
            //name
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Name",
                    style: TextStyle(fontSize: 15.5),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${ref.watch(userProvider.notifier).state!.name.substring(0, 1).toUpperCase()}${ref.watch(userProvider.notifier).state!.name.substring(1)}",
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: GestureDetector(
                onTap: () async {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: StatefulBuilder(
                          builder: (context2, state) {
                            return Container(
                              width: double.maxFinite,
                              height: MediaQuery.of(context).size.height / 2.5,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 20.0),
                              child: ListView(
                                children: [
                                  Text(
                                    "Update Your Name",
                                    style: GoogleFonts.nunito(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 55.0, left: 30.0, right: 30.0),
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
                                            return "New name cannot be empty";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          counterText: "",
                                          isDense: true,
                                          fillColor: const Color.fromARGB(
                                              255, 246, 246, 246),
                                          hintText: ref
                                              .read(userProvider.notifier)
                                              .state!
                                              .name,
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          contentPadding: const EdgeInsets.only(
                                              top: 10.0,
                                              bottom: 10.0,
                                              left: 10.0,
                                              right: 10.0),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: GestureDetector(
                                      onTapDown: (details) {
                                        state(() {
                                          updateNameSelect = true;
                                        });
                                      },
                                      onTapUp: (details) async {
                                        state(() {
                                          updateNameSelect = false;
                                        });
                                        if (_formKey.currentState!.validate()) {
                                          ref
                                              .read(userProvider.notifier)
                                              .state!
                                              .name = nameController.text;
                                          await FirebaseAuth
                                              .instance.currentUser!
                                              .updateDisplayName(
                                                  nameController.text);
                                          await FirebaseAuth
                                              .instance.currentUser!
                                              .reload();
                                          if (mounted) {
                                            Navigator.pop(context);
                                          }
                                        }
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 100),
                                        margin:
                                            const EdgeInsets.only(top: 50.0),
                                        padding: const EdgeInsets.only(
                                            top: 15.0,
                                            bottom: 15.0,
                                            left: 30.0,
                                            right: 30.0),
                                        decoration: ShapeDecoration(
                                          color: const Color.fromARGB(
                                              255, 51, 105, 255),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          shadows: [
                                            !updateNameSelect
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
                                          "Confirm",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ).then((value) {
                    nameController.text = "";
                    setState(() {});
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 240, 239, 250),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: const Text("Edit"),
                ),
              ),
            ),
            //email
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Email",
                    style: TextStyle(fontSize: 15.5),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    ref.watch(userProvider.notifier).state!.email,
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //phone
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Phone",
                    style: TextStyle(fontSize: 15.5),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    ref.watch(userProvider.notifier).state!.phone,
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //sticky header
            Container(
              margin: const EdgeInsets.only(top: 15.0, bottom: 10.0),
              padding: const EdgeInsets.only(left: 15.0, top: 5.0, bottom: 5.0),
              width: double.maxFinite,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 246, 246, 246),
              ),
              child: Text(
                "Budgeting",
                style: GoogleFonts.nunito(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.5,
                  ),
                ),
              ),
            ),
            //eom target
            ListTile(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) => const CFModifyTargets(),
                ))
                    .then((value) {
                  if (value == true) {
                    updateBudgetDetails = true;
                    setState(() {});
                  }
                });
              },
              leading: const Icon(FeatherIcons.heart),
              title: const Text(
                "EOM Target & Monthly Budget",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16.0),
              ),
              trailing: const Icon(FeatherIcons.chevronRight),
            ),
            //sticky header
            Container(
              margin: const EdgeInsets.only(top: 15.0, bottom: 10.0),
              padding: const EdgeInsets.only(left: 15.0, top: 5.0, bottom: 5.0),
              width: double.maxFinite,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 246, 246, 246),
              ),
              child: Text(
                "Preferences",
                style: GoogleFonts.nunito(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.5,
                  ),
                ),
              ),
            ),
            //consent status
            ListTile(
              title: const Text(
                "Consent Status",
                style: TextStyle(fontSize: 15.5),
              ),
              trailing: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ref.watch(userProvider.notifier).state!.hasConsented
                      ? const Color.fromARGB(244, 50, 224, 148)
                      : Colors.red,
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: ref.read(userProvider)!.hasConsented
                    ? const Text("Active")
                    : const Text(
                        "Inactive",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            //Revoke consent
            ref.watch(userProvider.notifier).state!.hasConsented
                ? Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => const CFRevokeConsent(),
                          ),
                        )
                            .then((value) {
                          setState(() {});
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.black,
                        ),
                        child: const Text(
                          "Revoke Consent",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(height: 25.0),
            //Delete Account
            Center(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color.fromARGB(255, 255, 160, 160),
                  ),
                  child: const Text(
                    "Delete Account",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
