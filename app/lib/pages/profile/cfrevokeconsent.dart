import 'package:CapitalFlowAI/pages/welcome/cfsplash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CFRevokeConsent extends ConsumerStatefulWidget {
  const CFRevokeConsent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CFProfileState();
}

class _CFProfileState extends ConsumerState<CFRevokeConsent> {
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
                      "Revoke Consent",
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
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "By initiating this request, you are indicating your intention to revoke all previously granted consents for accessing your bank account data, specifically for the purpose of personal finance and insight generation.",
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w500, fontSize: 15.0),
                    ),
                    const TextSpan(text: "\n"),
                    const TextSpan(text: "\n"),
                    TextSpan(
                      text:
                          "It's important to understand that once this consent is revoked, all associated data will be ",
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w500, fontSize: 15.0),
                    ),
                    TextSpan(
                      text: "permanently deleted ",
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold, fontSize: 15.0),
                    ),
                    TextSpan(
                      text:
                          "from this device as well as any other storage locations. Please note that this action is irreversible and cannot be undone.",
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w500, fontSize: 15.0),
                    ),
                  ],
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 40.0),
            Center(
              child: GestureDetector(
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(ref.read(userProvider.notifier).state!.uid)
                      .collection('data')
                      .get()
                      .then((snapshot) {
                    for (DocumentSnapshot ds in snapshot.docs) {
                      ds.reference.delete();
                    }
                  });
                  ref.read(userProvider.notifier).state!.consentDetails = {};
                  ref.read(userProvider.notifier).state!.consentID = "";
                  ref.read(userProvider.notifier).state!.hasConsented = false;
                  ref.read(userProvider.notifier).state!.sessionID = "";
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(ref.read(userProvider.notifier).state!.uid)
                      .set(ref.read(userProvider.notifier).state!.toMap());
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black),
                  child: const Text(
                    "Revoke Consent",
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
