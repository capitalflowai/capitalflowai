import 'package:CapitalFlowAI/backend/cfserver.dart';
import 'package:CapitalFlowAI/backend/cfsetu.dart';
import 'package:CapitalFlowAI/components/cfbalance.dart';
import 'package:CapitalFlowAI/components/cfhometop.dart';
import 'package:CapitalFlowAI/components/cfsettargets.dart';
import 'package:CapitalFlowAI/components/cfslider.dart';
import 'package:CapitalFlowAI/components/cfuser.dart';
import 'package:CapitalFlowAI/pages/welcome/cfsplash.dart';
import 'package:CapitalFlowAI/routes/cfroute_names.dart';
import 'package:blur/blur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String sessionID = "";
  String greetingMessage = "";
  bool isFirst = true;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (ref.read(userProvider.notifier).state!.transactions.isEmpty) {
        getdata();
      } else {
        isLoaded = true;
        setState(() {});
      }
      if (mounted) {
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
        } else {
          setState(() {
            isFirst = false;
          });
        }
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

  void getdata() async {
    CFUser? temp = ref.read(userProvider.notifier).state;

    temp!.transactions = await SetuAPI.getData(temp.sessionID);

    if (temp.transactions.containsKey('error')) {
      temp.sessionID = await SetuAPI.createDataSesion(temp.consentID);

      while (!temp.transactions.containsKey('status')) {
        temp.transactions = await SetuAPI.getData(temp.sessionID);
      }
    }
    Map<String, dynamic> data = temp.transactions;
    data['budget'] = temp.monthlyBudget;

    FirebaseFirestore.instance
        .collection('users')
        .doc(temp.uid)
        .collection('data')
        .doc(data['id'])
        .set(data);
    FirebaseFirestore.instance
        .collection('users')
        .doc(temp.uid)
        .set(temp.toMap());
    ref.read(userProvider.notifier).state = temp;
    ref.read(userProvider.notifier).state!.spentRatio =
        await CFServer.sliderGraph(data);
    isLoaded = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!isFirst) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 0.0, left: 15.0, right: 15.0, bottom: 15.0),
            child: AnimatedSwitcher(
              switchOutCurve: Curves.easeInOut,
              duration: const Duration(milliseconds: 250),
              child: isLoaded
                  ? Column(
                      key: const Key('Column1'),
                      children: [
                        CFHomeTop(greetingMessage),
                        ListView(
                          shrinkWrap: true,
                          children: [
                            //balance card
                            Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: CFBalance(
                                spentPercentage: ref
                                    .read(userProvider.notifier)
                                    .state!
                                    .spentRatio,
                                key: Key(
                                    "$ref.read(userProvider.notifier).state!.spentRatio ok"),
                              ),
                            ),
                            //Padding
                            const SizedBox(height: 25.0),
                            CFBalanceSlider(
                              ref.read(userProvider.notifier).state!.spentRatio,
                              key: Key(ref
                                  .read(userProvider.notifier)
                                  .state!
                                  .spentRatio
                                  .toString()),
                            ),
                            const SizedBox(height: 45.0),
                            //EOM & expenses
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 20.0,
                                      bottom: 20.0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("EOM Balance"),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 20.0,
                                      bottom: 20.0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Monthly Budget"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      key: const Key('Column2'),
                      children: [
                        CFHomeTop(greetingMessage),
                        const Spacer(),
                        Transform.scale(
                          scale: 0.5,
                          child: const CircularProgressIndicator(
                            strokeWidth: 7.5,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text("Hang on, while we fetch your data!"),
                        ),
                        const Spacer(
                          flex: 2,
                        ),
                      ],
                    ),
            ),
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
      return Scaffold(
        body: SafeArea(
          child: Blur(
            blur: 2.5,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 0.0, left: 15.0, right: 15.0, bottom: 15.0),
              child: Column(
                children: [
                  CFHomeTop(greetingMessage),
                  const Spacer(),
                  Transform.scale(
                    scale: 0.5,
                    child: const CircularProgressIndicator(
                      strokeWidth: 7.5,
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
