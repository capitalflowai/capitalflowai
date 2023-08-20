import 'package:CapitalFlowAI/pages/welcome/cfsplash.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              margin: const EdgeInsets.only(bottom: 25.0),
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 185, 214, 250),
              ),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pop();
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
                          fontSize: 17.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 15.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  ref.read(userProvider.notifier).state!.name,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30.0),
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
            GestureDetector(
              onTap: () {},
              child: ListTile(
                title: const Text(
                  "Name",
                  style: TextStyle(fontSize: 14.5),
                ),
                trailing: GestureDetector(
                  child: const Icon(FeatherIcons.chevronRight),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
