import 'package:CapitalFlowAI/backend/cfserver.dart';
import 'package:CapitalFlowAI/pages/welcome/cfsplash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CFInsights extends ConsumerStatefulWidget {
  const CFInsights({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CFInsightsState();
}

class _CFInsightsState extends ConsumerState<CFInsights> {
  List<BarChartData> threeCreditsData = [];
  List<BarChartData> threeDebitsData = [];
  List<ColumnChartData> inflowData = [];
  List<ColumnChartData> outflowData = [];
  List<dynamic> transactions = [];
  Map<String, double> inFlow = {};
  Map<String, double> outFlow = {};
  double threecreditsMax = 0.0;
  int topThreeIndicator = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      List<Map<String, dynamic>> threeDebits = CFServer.findTop3Debits(
          ref.read(userProvider.notifier).state!.transactions);
      List<Map<String, dynamic>> threeCredits = CFServer.findTop3Credits(
          ref.read(userProvider.notifier).state!.transactions);
      Map<String, Map<String, double>> inflowoutflow =
          CFServer.inflowOutflowMonths(
              ref.read(userProvider.notifier).state!.transactions);

      inFlow = inflowoutflow['inflow']!;
      outFlow = inflowoutflow['outflow']!;

      for (var value in threeDebits) {
        threeDebitsData.add(BarChartData(
            DateTime.parse(value['date']), value['amount'], value['mode']));
      }
      for (var value in threeCredits) {
        if (value['amount'] > threecreditsMax) {
          threecreditsMax = value['amount'];
        }
        threeCreditsData.add(BarChartData(
            DateTime.parse(value['date']), value['amount'], value['mode']));
      }

      for (var value in inFlow.entries) {
        inflowData.add(ColumnChartData(value.key, value.value));
      }

      for (var value in outFlow.entries) {
        outflowData.add(ColumnChartData(value.key, value.value));
      }
      transactions = ref
              .read(userProvider.notifier)
              .state!
              .transactions['Payload'][0]['data'][0]['decryptedFI']['account']
          ['transactions']['transaction'];
      transactions.sort((a, b) {
        final timestampA = a['transactionTimestamp'];
        final timestampB = b['transactionTimestamp'];
        return timestampB.compareTo(timestampA);
      });

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 20.0),
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 40.0, left: 20.0),
          child: Text(
            "Insights",
            style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          height: 270,
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 30.0,
            top: 20.0,
          ),
          margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 50.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
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
          child: Row(
            children: [
              Expanded(
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      topThreeIndicator = value;
                    });
                  },
                  itemCount: 2,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, snapshot) {
                    if (topThreeIndicator == 0) {
                      return Column(
                        children: [
                          const Text(
                            "Top 3 Debits in August",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 200,
                            child: SfCartesianChart(
                              trackballBehavior: TrackballBehavior(
                                lineWidth: 0,
                                activationMode: ActivationMode.singleTap,
                                enable: true,
                                lineType: TrackballLineType.none,
                                tooltipSettings: const InteractiveTooltip(
                                  enable: true,
                                  arrowLength: 0.0,
                                  color: Color.fromARGB(254, 146, 92, 216),
                                ),
                              ),
                              margin: EdgeInsets.zero,
                              plotAreaBorderWidth: 0,
                              primaryYAxis: NumericAxis(
                                majorGridLines: const MajorGridLines(width: 0),
                                rangePadding: ChartRangePadding.round,
                              ),
                              primaryXAxis: DateTimeCategoryAxis(
                                isVisible: true,
                                isInversed: true,
                                majorGridLines: const MajorGridLines(width: 0),
                                labelPlacement: LabelPlacement.onTicks,
                                rangePadding: ChartRangePadding.additional,
                              ),
                              series: [
                                StackedBarSeries<BarChartData, DateTime>(
                                  enableTooltip: true,
                                  color:
                                      const Color.fromARGB(255, 180, 231, 232),
                                  spacing: 0.5,
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  dataSource: threeDebitsData,
                                  xValueMapper: (BarChartData datum, index) =>
                                      datum.x,
                                  yValueMapper: (datum, index) => datum.y,
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    labelAlignment:
                                        ChartDataLabelAlignment.outer,
                                    labelPosition:
                                        ChartDataLabelPosition.outside,
                                  ),
                                  dataLabelMapper: (datum, index) => datum.mode,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          const Text(
                            "Top 3 Credits in August",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 200,
                            child: SfCartesianChart(
                              trackballBehavior: TrackballBehavior(
                                lineWidth: 0,
                                activationMode: ActivationMode.singleTap,
                                enable: true,
                                lineType: TrackballLineType.none,
                                tooltipSettings: const InteractiveTooltip(
                                  enable: true,
                                  arrowLength: 0.0,
                                  color: Color.fromARGB(254, 146, 92, 216),
                                ),
                              ),
                              margin: EdgeInsets.zero,
                              plotAreaBorderWidth: 0,
                              primaryYAxis: NumericAxis(
                                majorGridLines: const MajorGridLines(width: 0),
                                rangePadding: ChartRangePadding.round,
                              ),
                              primaryXAxis: DateTimeCategoryAxis(
                                isVisible: true,
                                isInversed: true,
                                majorGridLines: const MajorGridLines(width: 0),
                                labelPlacement: LabelPlacement.onTicks,
                                rangePadding: ChartRangePadding.additional,
                              ),
                              series: [
                                StackedBarSeries<BarChartData, DateTime>(
                                  enableTooltip: true,
                                  color:
                                      const Color.fromARGB(255, 176, 181, 242),
                                  spacing: 0.5,
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  dataSource: threeCreditsData,
                                  xValueMapper: (BarChartData datum, index) =>
                                      datum.x,
                                  yValueMapper: (datum, index) => datum.y,
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    labelAlignment:
                                        ChartDataLabelAlignment.outer,
                                    textStyle: TextStyle(color: Colors.white),
                                    labelPosition:
                                        ChartDataLabelPosition.outside,
                                  ),
                                  dataLabelMapper: (datum, index) => datum.mode,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: topThreeIndicator == 0
                          ? const Color.fromARGB(255, 81, 121, 230)
                          : const Color.fromARGB(255, 51, 105, 255)
                              .withOpacity(0.6),
                      borderRadius: BorderRadius.circular(
                          topThreeIndicator == 0 ? 100.0 : 12.0),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: topThreeIndicator == 1
                          ? const Color.fromARGB(255, 81, 121, 230)
                          : const Color.fromARGB(255, 51, 105, 255)
                              .withOpacity(0.6),
                      borderRadius: BorderRadius.circular(
                          topThreeIndicator == 1 ? 100.0 : 12.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 300,
          padding: const EdgeInsets.only(
              left: 10.0, right: 30.0, top: 20.0, bottom: 20.0),
          margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
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
            children: [
              const Text(
                "Inflow - Outflow",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: SfCartesianChart(
                  legend: const Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    alignment: ChartAlignment.center,
                  ),
                  trackballBehavior: TrackballBehavior(
                    lineWidth: 0,
                    activationMode: ActivationMode.singleTap,
                    enable: true,
                    lineType: TrackballLineType.none,
                    tooltipSettings: const InteractiveTooltip(
                      enable: true,
                      arrowLength: 0.0,
                      color: Color.fromARGB(254, 146, 92, 216),
                    ),
                  ),
                  margin: EdgeInsets.zero,
                  plotAreaBorderWidth: 0,
                  primaryYAxis: NumericAxis(
                    minimum: 0,
                    majorGridLines: const MajorGridLines(width: 0),
                    rangePadding: ChartRangePadding.round,
                  ),
                  primaryXAxis: CategoryAxis(
                    isVisible: true,
                    isInversed: true,
                    labelPlacement: LabelPlacement.onTicks,
                    majorGridLines: const MajorGridLines(width: 0),
                    rangePadding: ChartRangePadding.normal,
                  ),
                  series: <ChartSeries<ColumnChartData, String>>[
                    StackedColumnSeries<ColumnChartData, String>(
                      name: "Inflow",
                      dataSource: inflowData,
                      width: 0.5,
                      groupName: 'group a',
                      xValueMapper: (ColumnChartData datum, index) => datum.x,
                      yValueMapper: (ColumnChartData datum, index) => datum.y,
                    ),
                    StackedColumnSeries<ColumnChartData, String>(
                      name: "Outflow",
                      width: 0.5,
                      groupName: 'group b',
                      dataSource: outflowData,
                      xValueMapper: (ColumnChartData datum, index) => datum.x,
                      yValueMapper: (ColumnChartData datum, index) => datum.y,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 300,
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
          margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
              border: Border.all(color: Colors.black38)
              // boxShadow: const [
              //   BoxShadow(
              //     offset: Offset(0, 0),
              //     spreadRadius: 3.0,
              //     blurRadius: 7.5,
              //     color: Colors.black12,
              //   ),
              // ],
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Transactions",
                style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 25.0),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          tileColor: Colors.white,
                          leading: Container(
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(DateFormat("dd MMM").format(
                                DateTime.parse(transactions[index]
                                    ['transactionTimestamp']))),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transactions[index]['narration']
                                    .toString()
                                    .split('/')[3],
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                transactions[index]['mode'],
                                style: const TextStyle(fontSize: 15.0),
                              ),
                            ],
                          ),
                          trailing: Text(
                            "Rs. ${transactions[index]['amount']}",
                            style: const TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BarChartData {
  BarChartData(this.x, this.y, this.mode);
  final DateTime x;
  final double y;
  final String mode;
}

class ColumnChartData {
  ColumnChartData(this.x, this.y);
  final String x;
  final double y;
}
