import 'package:CapitalFlowAI/routes/cfroute_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CFHome extends StatefulWidget {
  const CFHome({super.key});

  @override
  State<CFHome> createState() => _CFHomeState();
}

class _CFHomeState extends State<CFHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: TextButton(
            child: const Text("out"),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              GoRouter.of(context).goNamed(CFRouteNames.splashRouteName);
            },
          ),
        ),
      ),
    );
  }
}
