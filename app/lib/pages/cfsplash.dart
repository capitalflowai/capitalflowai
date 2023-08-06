import 'package:CapitalFlowAI/routes/cfroute_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final userProvider = StateProvider<User?>((ref) {
  User? temp;
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
    if (FirebaseAuth.instance.currentUser != null) {
      ref.read(userProvider.notifier).state = FirebaseAuth.instance.currentUser;
      GoRouter.of(context).pushReplacementNamed(CFRouteNames.homeRouteName);
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
