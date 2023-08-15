import 'dart:async';
import 'package:CapitalFlowAI/components/cfuser.dart';
import 'package:CapitalFlowAI/routes/cfroute_names.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userProvider = StateProvider<CFUser?>((ref) {
  return null;
});

final consentAcceptCheck = StateProvider<bool>((ref) {
  bool temp = false;
  return temp;
});

class CFSplash extends ConsumerStatefulWidget {
  const CFSplash({super.key});

  @override
  ConsumerState<CFSplash> createState() => _CFSplashState();
}

class _CFSplashState extends ConsumerState<CFSplash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), checkLogin);
  }

  void checkLogin() async {
    User? tempUser = FirebaseAuth.instance.currentUser;
    if (tempUser != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(tempUser.uid)
          .get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      ref.read(userProvider.notifier).state =
          CFUser.fromMap(data, FirebaseAuth.instance.currentUser);
      if (mounted) {
        GoRouter.of(context).pushReplacementNamed(CFRouteNames.homeRouteName);
      }
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      bool? isFirst = preferences.getBool("isFirst");
      if (isFirst == null) {
        if (mounted) {
          preferences.setBool('isFirst', true);
          GoRouter.of(context)
              .pushReplacementNamed(CFRouteNames.onboardingRouteName);
        }
      } else {
        if (mounted) {
          GoRouter.of(context)
              .pushReplacementNamed(CFRouteNames.welcomeRouteName);
        }
      }
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
