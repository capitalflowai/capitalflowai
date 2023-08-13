import 'package:CapitalFlowAI/backend/cfsetu.dart';
import 'package:CapitalFlowAI/components/cfbalancecard.dart';
import 'package:CapitalFlowAI/pages/cfsplash.dart';
import 'package:CapitalFlowAI/routes/cfroute_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CFHome extends ConsumerStatefulWidget {
  const CFHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CFHomeState();
}

class _CFHomeState extends ConsumerState<CFHome> {
  int bottomNavigationIndex = 0;
  bool isNotification = false;
  double moneySpent = 1000.0;
  double totalBudget = 5000.0;
  double remainingRatio = 0.0;
  double value = 0.0;

  @override
  void initState() {
    super.initState();
    calcRemainingRatio();
  }

  void calcRemainingRatio() {
    remainingRatio = 1 - (moneySpent / totalBudget);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(ref.watch(userProvider.notifier).state!.name);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
          shrinkWrap: true,
          children: [
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(
                  left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
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
                        onTap: () {
                          setState(() {
                            isNotification = !isNotification;
                          });
                        },
                        onLongPress: () {
                          FirebaseAuth.instance.signOut();
                          GoRouter.of(context)
                              .goNamed(CFRouteNames.welcomeRouteName);
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
                            color: isNotification
                                ? Colors.red
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Good Evening,\n${(ref.watch(userProvider.notifier).state!.name).substring(0, 1).toUpperCase()}${(ref.watch(userProvider.notifier).state!.name).substring(1)}!",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: CFBalance(
                remainingPercentage: remainingRatio,
                spentPercentage: 1 - remainingRatio,
              ),
            ),
            Slider(
              value: value,
              onChanged: (val) {
                setState(() {
                  value = val;
                  moneySpent = val * totalBudget;

                  calcRemainingRatio();
                });
              },
            ),
            IconButton(
              onPressed: () {
                SetuAPI.createDataSesion(
                    ref.watch(userProvider.notifier).state!.consentID);
              },
              icon: Icon(Icons.ac_unit),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue.shade800,
        backgroundColor: Colors.white,
        currentIndex: bottomNavigationIndex,
        onTap: (value) {
          if (value == 1) {
            GoRouter.of(context)
                .pushNamed(CFRouteNames.midasRouteName)
                .then((value) {
              SystemChrome.setSystemUIOverlayStyle(
                const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                ),
              );
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.barChart2),
            label: "Insights",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: "Midas Ai",
          ),
        ],
      ),
    );
  }
}
