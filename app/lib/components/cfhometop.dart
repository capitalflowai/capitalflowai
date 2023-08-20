import 'package:CapitalFlowAI/components/cfavatar.dart';
import 'package:CapitalFlowAI/components/cfconstants.dart';
import 'package:CapitalFlowAI/pages/welcome/cfsplash.dart';
import 'package:CapitalFlowAI/routes/cfroute_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CFHomeTop extends ConsumerStatefulWidget {
  final String greetingMessage;
  const CFHomeTop(this.greetingMessage, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CFHomeTopState();
}

class _CFHomeTopState extends ConsumerState<CFHomeTop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25.0),
      width: double.maxFinite,
      padding: const EdgeInsets.only(
          left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 241, 241, 243),
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {},
                onLongPress: () async {
                  FirebaseAuth instance = FirebaseAuth.instance;
                  await instance.signOut();
                  if (mounted) {
                    GoRouter.of(context).goNamed(CFRouteNames.welcomeRouteName);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100.0),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 0),
                          spreadRadius: .1,
                          blurRadius: 2.0,
                          color: Colors.black.withOpacity(0.3)),
                    ],
                  ),
                  child: const Icon(
                    FeatherIcons.bell,
                    color: Color.fromARGB(255, 21, 128, 222),
                  ),
                ),
              ),
              Positioned(
                top: 2,
                right: 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: widget.greetingMessage),
                    TextSpan(
                        text:
                            "${ref.watch(userProvider.notifier).state!.name.substring(0, 1).toUpperCase()}${ref.watch(userProvider.notifier).state!.name.substring(1)}!")
                  ],
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              GestureDetector(
                  onTap: () {
                    GoRouter.of(context)
                        .pushNamed(CFRouteNames.profileRouteName);
                  },
                  child: CFAvatar(
                      name:
                          "assets/${ref.read(userProvider.notifier).state!.avatar}.png",
                      width: 40,
                      color: ref.read(userProvider.notifier).state!.avatar ==
                              "maleAvatar"
                          ? CFConstants.maleColor
                          : CFConstants.femaleColor,
                      isSelected: -1,
                      isBorder: false)),
            ],
          ),
        ],
      ),
    );
  }
}
