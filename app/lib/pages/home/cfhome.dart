import 'package:CapitalFlowAI/backend/cfsetu.dart';
import 'package:CapitalFlowAI/components/cfavatar.dart';
import 'package:CapitalFlowAI/components/cfbalancecard.dart';
import 'package:CapitalFlowAI/components/cfconstants.dart';
import 'package:CapitalFlowAI/components/cfsettargets.dart';
import 'package:CapitalFlowAI/pages/welcome/cfsplash.dart';
import 'package:CapitalFlowAI/routes/cfroute_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final transactions = StateProvider<Map>(
  (ref) {
    return {};
  },
);

class CFHome extends ConsumerStatefulWidget {
  const CFHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CFHomeState();
}

class _CFHomeState extends ConsumerState<CFHome> {
  int bottomNavigationIndex = 0;
  bool isNotification = false;
  double moneySpent = 0.0;
  double spentRatio = 0.0;
  String sessionID = "";
  String greetingMessage = "";
  bool isFirst = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getdata();
      if (ref.watch(userProvider.notifier).state!.eomBalance == 0.0) {
        showModalBottomSheet(
          isDismissible: false,
          enableDrag: false,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: const CFSetTargets()),
            );
          },
        ).then((value) {
          setState(() {
            isFirst = false;
          });
        });
      }
    });
    getGreeting();
  }

  void getGreeting() {
    DateTime timeNow = DateTime.now();
    int hour = timeNow.hour;
    if (0 < hour && hour < 12) {
      greetingMessage = "Good Morning\n";
    } else if (12 < hour && hour < 16) {
      greetingMessage = "Good Afternoon\n";
    } else {
      greetingMessage = "Good Evening\n";
    }
    setState(() {});
  }

  void createsession() async {
    ref.watch(userProvider.notifier).state!.sessionID =
        await SetuAPI.createDataSesion(
            ref.watch(userProvider.notifier).state!.consentID);
  }

  void getdata() async {
    ref.watch(transactions.notifier).state =
        await SetuAPI.getData(ref.read(userProvider.notifier).state!.sessionID);
    if (ref.watch(transactions.notifier).state.containsKey('error')) {
      ref.watch(userProvider.notifier).state!.sessionID =
          await SetuAPI.createDataSesion(
              ref.read(userProvider.notifier).state!.consentID);

      while (!ref.watch(transactions.notifier).state.containsKey('status')) {
        ref.watch(transactions.notifier).state = await SetuAPI.getData(
            ref.read(userProvider.notifier).state!.sessionID);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isFirst) {
      return Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
            shrinkWrap: true,
            children: [
              //top bar
              Container(
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
                          onTap: () {
                            getdata();
                            // setState(() {
                            //   isNotification = !isNotification;
                            // });
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
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: greetingMessage),
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
                                color: ref
                                            .read(userProvider.notifier)
                                            .state!
                                            .avatar ==
                                        "maleAvatar"
                                    ? CFConstants.maleColor
                                    : CFConstants.femaleColor,
                                isSelected: -1,
                                isBorder: false)),
                      ],
                    ),
                  ],
                ),
              ),
              //balance card
              const Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: CFBalance(),
              ),
              const SizedBox(height: 45.0),
              //EOM & expenses
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          spreadRadius: 1.0,
                          blurRadius: 15.0,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("EOM Balance"),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          spreadRadius: 1.0,
                          blurRadius: 15.0,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Monthly Budget"),
                      ],
                    ),
                  ),
                ],
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
    } else {
      return const Scaffold(
        body: Text("nothing to show"),
      );
    }
  }
}
