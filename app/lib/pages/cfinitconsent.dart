import 'dart:async';
import 'package:CapitalFlowAI/pages/cfsignup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CFInitConsent extends ConsumerStatefulWidget {
  const CFInitConsent({super.key});

  @override
  ConsumerState<CFInitConsent> createState() => _CFInitConsentState();
}

class _CFInitConsentState extends ConsumerState<CFInitConsent> {
  Map response = {};
  bool isStartConsent = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: SystemUiOverlay.values);
    if (isStartConsent) {
      Timer.periodic(const Duration(seconds: 2), (timer) {
        print("We are checkinggggggggg!");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Text(!ref.read(consentAcceptCheck.notifier).state
            ? "Not accepted?"
            : "Accepted"),
      ),
    );
  }
}
