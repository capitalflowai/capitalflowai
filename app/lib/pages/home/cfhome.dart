import 'package:CapitalFlowAI/backend/cfserver.dart';
import 'package:CapitalFlowAI/backend/cfsetu.dart';
import 'package:CapitalFlowAI/components/cfavatar.dart';
import 'package:CapitalFlowAI/components/cfbalance.dart';
import 'package:CapitalFlowAI/components/cfconstants.dart';
import 'package:CapitalFlowAI/components/cfsettargets.dart';
import 'package:CapitalFlowAI/components/cfslider.dart';
import 'package:CapitalFlowAI/components/cfuser.dart';
import 'package:CapitalFlowAI/pages/home/cfinsights.dart';
import 'package:CapitalFlowAI/pages/welcome/cfsplash.dart';
import 'package:CapitalFlowAI/routes/cfroute_names.dart';
import 'package:blur/blur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CFHome extends ConsumerStatefulWidget {
  const CFHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CFHomeState();
}

class _CFHomeState extends ConsumerState<CFHome> {
  int bottomNavigationIndex = 0;
  String sessionID = "";
  String greetingMessage = "";
  bool showScreen = false;
  bool isFirst = true;
  bool isLoaded = false;
  bool selectCreate = false;
  bool hasConsented = false;
  Map<String, dynamic> piechart = {};
  Map<String, dynamic> linechart = {};
  int index = 0;

  List<PiechartData> pieData = [];
  List<Color> colors = const [
    Color.fromARGB(255, 0, 198, 178),
    Color.fromARGB(255, 0, 145, 255),
    Color.fromARGB(255, 88, 76, 177),
    Color.fromARGB(255, 249, 249, 113),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      hasConsented = ref.watch(userProvider)!.hasConsented;
      showScreen = true;

      setState(() {});
      if (ref.read(userProvider.notifier).state!.consentID.isNotEmpty) {
        if (ref.read(userProvider.notifier).state!.transactions.isEmpty) {
          getdata();
          getTargets();
        } else {
          isLoaded = true;
          isFirst = false;
          piechart = CFServer.modePieChart(
              ref.read(userProvider.notifier).state!.transactions);
          for (var value in piechart.entries) {
            pieData.add(PiechartData(value.key, value.value, colors[index]));
            index++;
          }
          linechart = CFServer.lineGraph(
              ref.read(userProvider.notifier).state!.transactions);
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

  void getGraphs() async {
    Map<String, dynamic> data =
        ref.read(userProvider.notifier).state!.transactions;
    data['budget'] = ref.read(userProvider.notifier).state!.monthlyBudget;
    ref.read(userProvider.notifier).state!.spentRatio =
        CFServer.monthlyBudgetSlider(data);
    isLoaded = true;
    piechart = CFServer.modePieChart(
        ref.read(userProvider.notifier).state!.transactions);
    for (var value in piechart.entries) {
      pieData.add(PiechartData(value.key, value.value, colors[index]));
      index++;
    }
    linechart =
        CFServer.lineGraph(ref.read(userProvider.notifier).state!.transactions);
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
    getGraphs();
  }

  @override
  Widget build(BuildContext context) {
    if (showScreen) {
      if (ref.watch(userProvider.notifier).state!.hasConsented) {
        if (!isFirst) {
          return Scaffold(
            body: SafeArea(
              child: bottomNavigationIndex == 0
                  ? AnimatedSwitcher(
                      switchOutCurve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 250),
                      child: isLoaded
                          //loaded values
                          ? Column(
                              key: const Key('Column1'),
                              children: [
                                Expanded(
                                  child: ListView(
                                    padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      bottom: 20.0,
                                    ),
                                    children: [
                                      //user status
                                      Container(
                                        margin:
                                            const EdgeInsets.only(top: 25.0),
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 241, 241, 243),
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Stack(
                                              children: [
                                                GestureDetector(
                                                  behavior: HitTestBehavior
                                                      .translucent,
                                                  onTap: () {},
                                                  onLongPress: () async {
                                                    FirebaseAuth instance =
                                                        FirebaseAuth.instance;
                                                    await instance.signOut();
                                                    if (mounted) {
                                                      GoRouter.of(context)
                                                          .goNamed(CFRouteNames
                                                              .welcomeRouteName);
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset:
                                                                const Offset(
                                                                    0, 0),
                                                            spreadRadius: .1,
                                                            blurRadius: 2.0,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.3)),
                                                      ],
                                                    ),
                                                    child: const Icon(
                                                      FeatherIcons.bell,
                                                      color: Color.fromARGB(
                                                          255, 21, 128, 222),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 2,
                                                  right: 1,
                                                  child: AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    width: 10,
                                                    height: 10,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100.0),
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
                                                      TextSpan(
                                                          text:
                                                              greetingMessage),
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
                                                        .pushNamed(CFRouteNames
                                                            .profileRouteName)
                                                        .then((value) {
                                                      if (value == true) {
                                                        getGraphs();
                                                      }
                                                      setState(() {});
                                                    });
                                                  },
                                                  child: CFAvatar(
                                                      name:
                                                          "assets/${ref.read(userProvider.notifier).state!.avatar}.png",
                                                      width: 40,
                                                      color: ref
                                                                  .read(userProvider
                                                                      .notifier)
                                                                  .state!
                                                                  .avatar ==
                                                              "maleAvatar"
                                                          ? CFConstants
                                                              .maleColor
                                                          : CFConstants
                                                              .femaleColor,
                                                      isSelected: -1,
                                                      isBorder: false),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      //balance card
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 40.0),
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
                                      const SizedBox(height: 25.0),
                                      //PieChart
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 15.0,
                                            top: 15.0,
                                            right: 15.0,
                                            bottom: 15.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: Colors.white,
                                          boxShadow: const [
                                            BoxShadow(
                                              offset: Offset(0, 0),
                                              spreadRadius: 3.0,
                                              blurRadius: 7.5,
                                              color: Colors.black12,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Expenses In ${DateFormat('MMMM').format(DateTime.now())}",
                                              style: GoogleFonts.nunito(
                                                textStyle: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 20.0),
                                            Center(
                                              child: SizedBox(
                                                height: 100,
                                                child: SfCircularChart(
                                                  legend: const Legend(
                                                    isVisible: true,
                                                  ),
                                                  margin: EdgeInsets.zero,
                                                  series: [
                                                    PieSeries(
                                                      xValueMapper: (data, _) =>
                                                          data.x,
                                                      yValueMapper: (data, _) =>
                                                          data.y,
                                                      dataLabelMapper:
                                                          (data, _) => data.x,
                                                      pointColorMapper:
                                                          (data, index) =>
                                                              data.color,
                                                      radius: '100%',
                                                      dataLabelSettings:
                                                          const DataLabelSettings(
                                                        showZeroValue: false,
                                                        margin: EdgeInsets.only(
                                                            top: 0),
                                                        isVisible: true,
                                                      ),
                                                      dataSource: pieData,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      //BarChart
                                      // Container(
                                      //   padding: const EdgeInsets.only(
                                      //       left: 15.0,
                                      //       top: 15.0,
                                      //       right: 15.0,
                                      //       bottom: 15.0),
                                      //   decoration: BoxDecoration(
                                      //     borderRadius: BorderRadius.circular(15.0),
                                      //     color: Colors.white,
                                      //     boxShadow: const [
                                      //       BoxShadow(
                                      //         offset: Offset(0, 0),
                                      //         spreadRadius: 3.0,
                                      //         blurRadius: 7.5,
                                      //         color: Colors.black12,
                                      //       ),
                                      //     ],
                                      //   ),
                                      //   child: Column(
                                      //     crossAxisAlignment:
                                      //         CrossAxisAlignment.start,
                                      //     children: [
                                      //       Text(
                                      //         "5 day frequency in ${DateFormat('MMMM').format(DateTime.now())}",
                                      //         style: GoogleFonts.nunito(
                                      //           textStyle: const TextStyle(
                                      //             fontSize: 20.0,
                                      //             fontWeight: FontWeight.w700,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       const SizedBox(height: 30.0),
                                      //       Center(
                                      //         child: SizedBox(
                                      //           height: 150,
                                      //           child: SfCartesianChart(
                                      //             series: [
                                      //               HistogramSeries<ChartData,
                                      //                       dynamic>(
                                      //                   dataSource: barGroups,
                                      //                   yValueMapper:
                                      //                       (ChartData sales, _) =>
                                      //                           sales.y,
                                      //                   binInterval: 5,
                                      //                   curveColor:
                                      //                       const Color.fromRGBO(
                                      //                           192, 108, 132, 1),
                                      //                   borderWidth: 3),
                                      //             ],
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),

                                      //Line Chart
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 15.0,
                                            top: 15.0,
                                            right: 15.0,
                                            bottom: 15.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: Colors.white,
                                          boxShadow: const [
                                            BoxShadow(
                                              offset: Offset(0, 0),
                                              spreadRadius: 3.0,
                                              blurRadius: 7.5,
                                              color: Colors.black12,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Expenses In ${DateFormat('MMMM').format(DateTime.now())}",
                                              style: GoogleFonts.nunito(
                                                textStyle: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 30.0),
                                            Center(
                                              child: SizedBox(
                                                height: 100,
                                                child: SfCartesianChart(
                                                  trackballBehavior:
                                                      TrackballBehavior(
                                                    lineWidth: 1.5,
                                                    activationMode:
                                                        ActivationMode
                                                            .singleTap,
                                                    enable: true,
                                                    tooltipSettings:
                                                        const InteractiveTooltip(
                                                      enable: true,
                                                      color: Color.fromARGB(
                                                          254, 146, 92, 216),
                                                    ),
                                                  ),
                                                  margin: EdgeInsets.zero,
                                                  plotAreaBorderWidth: 0,
                                                  primaryXAxis: NumericAxis(
                                                    maximum: 31,
                                                    minimum: 1,
                                                    interval: 4,
                                                    majorGridLines:
                                                        const MajorGridLines(
                                                            width: 0),
                                                  ),
                                                  primaryYAxis: NumericAxis(
                                                    numberFormat: NumberFormat
                                                        .compactCurrency(
                                                            locale: "en-IN",
                                                            name: "Rs. "),
                                                    majorGridLines:
                                                        const MajorGridLines(
                                                      width: 0,
                                                    ),
                                                  ),
                                                  series: <ChartSeries>[
                                                    LineSeries<LineChartData,
                                                            int>(
                                                        width: 3.5,
                                                        enableTooltip: true,
                                                        dataSource: linechart
                                                            .entries
                                                            .map(
                                                          (entry) {
                                                            return LineChartData(
                                                                int.parse(
                                                                    entry.key),
                                                                double.parse(entry
                                                                    .value
                                                                    .toString()));
                                                          },
                                                        ).toList(),
                                                        xValueMapper:
                                                            (LineChartData data,
                                                                    _) =>
                                                                data.x,
                                                        yValueMapper:
                                                            (LineChartData data,
                                                                    _) =>
                                                                data.y)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
                                Container(
                                  margin: const EdgeInsets.only(top: 25.0),
                                  width: double.maxFinite,
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 241, 241, 243),
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {},
                                            onLongPress: () async {
                                              FirebaseAuth instance =
                                                  FirebaseAuth.instance;
                                              await instance.signOut();
                                              if (mounted) {
                                                GoRouter.of(context).goNamed(
                                                    CFRouteNames
                                                        .welcomeRouteName);
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset:
                                                          const Offset(0, 0),
                                                      spreadRadius: .1,
                                                      blurRadius: 2.0,
                                                      color: Colors.black
                                                          .withOpacity(0.3)),
                                                ],
                                              ),
                                              child: const Icon(
                                                FeatherIcons.bell,
                                                color: Color.fromARGB(
                                                    255, 21, 128, 222),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 2,
                                            right: 1,
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
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
                                          CFAvatar(
                                              name:
                                                  "assets/${ref.read(userProvider.notifier).state!.avatar}.png",
                                              width: 40,
                                              color: ref
                                                          .read(userProvider
                                                              .notifier)
                                                          .state!
                                                          .avatar ==
                                                      "maleAvatar"
                                                  ? CFConstants.maleColor
                                                  : CFConstants.femaleColor,
                                              isSelected: -1,
                                              isBorder: false),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Transform.scale(
                                  scale: 0.5,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 7.5,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Text(
                                      "Hang on, while we fetch your data!"),
                                ),
                                const Spacer(
                                  flex: 2,
                                ),
                              ],
                            ),
                    )
                  : const CFInsights(),
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.blue.shade800,
              backgroundColor: Colors.white,
              currentIndex: bottomNavigationIndex,
              onTap: (value) {
                if (value == 0) {
                  setState(() {
                    bottomNavigationIndex = 0;
                  });
                }
                if (value == 1) {
                  setState(() {
                    bottomNavigationIndex = 1;
                  });
                }
                if (value == 2) {
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
                  icon: Icon(FeatherIcons.home),
                  label: "Home",
                ),
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
                      Container(
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
                                    FirebaseAuth instance =
                                        FirebaseAuth.instance;
                                    await instance.signOut();
                                    if (mounted) {
                                      GoRouter.of(context).goNamed(
                                          CFRouteNames.welcomeRouteName);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 0),
                                            spreadRadius: .1,
                                            blurRadius: 2.0,
                                            color:
                                                Colors.black.withOpacity(0.3)),
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
                                      borderRadius:
                                          BorderRadius.circular(100.0),
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
                                CFAvatar(
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
                                    isBorder: false),
                              ],
                            ),
                          ],
                        ),
                      ),
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
                  Container(
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
                                  GoRouter.of(context)
                                      .goNamed(CFRouteNames.welcomeRouteName);
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
                                    .pushNamed(CFRouteNames.profileRouteName)
                                    .then((value) {
                                  if (value == true) {
                                    getGraphs();
                                  }
                                  setState(() {});
                                });
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
                                  isBorder: false),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                              String sessionID = await SetuAPI.createDataSesion(
                                  response['id']);
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
    } else {
      return const Scaffold();
    }
  }
}

class PiechartData {
  PiechartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class LineChartData {
  LineChartData(this.x, this.y);
  final int x;
  final double y;
}
