import 'package:app/routes/cfroute_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CFSplash extends StatefulWidget {
  const CFSplash({super.key});

  @override
  State<CFSplash> createState() => _CFSplashState();
}

class _CFSplashState extends State<CFSplash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), checkLogin);
  }

  void checkLogin() async {
    if (FirebaseAuth.instance.currentUser != null) {
    } else {
      GoRouter.of(context)
          .pushReplacementNamed(CFRouteNames.onboardingRouteName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Om Shivaya Namaha"),
      ),
    );
  }
}
