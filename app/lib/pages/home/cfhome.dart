import 'dart:convert';

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
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
  bool selectCreate = false;
  bool hasConsented = false;
  Map<String, dynamic> piechart = {};
  List<PieChartSectionData> sections = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      piechart =
          (await CFServer.pieChart(ref.read(userProvider)!.transactions));
      piechart.forEach((key, value) {
        sections.add(PieChartSectionData(
          value: value,
          title: '$value', // You can customize this as needed
          radius: 50,
          titleStyle: TextStyle(fontSize: 12, color: Colors.white),
          color: Colors.red,
        ));
      });
      setState(() {});
      hasConsented = ref.watch(userProvider)!.hasConsented;
      if (ref.read(userProvider.notifier).state!.consentID.isNotEmpty) {
        if (ref.read(userProvider.notifier).state!.transactions.isEmpty) {
          getdata();
          getTargets();
        } else {
          isLoaded = true;
          isFirst = false;
          setState(() {});
        }
      }
    });
    getGreeting();
  }

  void getTargets() {
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
    if (hasConsented) {
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
                    //loaded values
                    ? Column(
                        key: const Key('Column1'),
                        children: [
                          CFHomeTop(greetingMessage),
                          Expanded(
                            child: ListView(
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
                                  ref
                                      .read(userProvider.notifier)
                                      .state!
                                      .spentRatio,
                                  key: Key(ref
                                      .read(userProvider.notifier)
                                      .state!
                                      .spentRatio
                                      .toString()),
                                ),
                                const SizedBox(height: 45.0),
                                //EOM & expenses
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: PieChart(
                                        PieChartData(
                                          sections: sections,
                                        ),
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                          ),
                        ],
                      )
                    //Fetching data first time
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
    } else {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 0.0, left: 15.0, right: 15.0, bottom: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CFHomeTop(greetingMessage),
                const Spacer(),
                SvgPicture.asset("assets/vault.svg"),
                const SizedBox(height: 25.0),
                const Text(
                  "Oh no, we could not find active consents!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17.0),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Click below to get started!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17.0),
                ),
                const SizedBox(height: 15.0),
                GestureDetector(
                  onTapDown: (details) {
                    setState(() {
                      selectCreate = true;
                    });
                  },
                  onTapUp: (details) async {
                    setState(() {
                      selectCreate = false;
                    });
                    Map response = await SetuAPI.createConsent(
                        ref.read(userProvider.notifier).state!.phone);
                    if (response.isNotEmpty) {
                      if (mounted) {
                        GoRouter.of(context).pushNamed("webview",
                            pathParameters: {
                              'url': response['id']
                            }).then((value) async {
                          if (value.toString().contains("approved")) {
                            Map consentDetails =
                                await SetuAPI.getConsent(response['id']);
                            String sessionID =
                                await SetuAPI.createDataSesion(response['id']);
                            ref
                                    .read(userProvider.notifier)
                                    .state!
                                    .consentDetails =
                                Map<String, dynamic>.from(consentDetails);
                            ref.read(userProvider.notifier).state!.consentID =
                                response['id'];
                            ref.read(userProvider.notifier).state!.sessionID =
                                sessionID;
                            ref
                                .read(userProvider.notifier)
                                .state!
                                .hasConsented = true;
                            hasConsented = true;
                            setState(() {});
                            getdata();
                            getTargets();
                          }
                        });
                      }
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    margin: const EdgeInsets.only(top: 40.0),
                    padding: const EdgeInsets.only(
                        top: 20.0, bottom: 20.0, left: 30.0, right: 30.0),
                    decoration: ShapeDecoration(
                      color: const Color.fromARGB(255, 51, 105, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      shadows: [
                        !selectCreate
                            ? const BoxShadow(
                                offset: Offset(0, 4),
                                color: Colors.black26,
                                blurRadius: 10,
                                spreadRadius: 1.0,
                              )
                            : const BoxShadow(
                                offset: Offset(0, 0),
                                spreadRadius: 2.0,
                                blurRadius: 1.0,
                                color: Colors.black12,
                              ),
                      ],
                    ),
                    child: const Text(
                      "Create Consent",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      );
    }
  }
}
