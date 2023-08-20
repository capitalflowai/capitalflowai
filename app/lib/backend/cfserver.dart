import 'dart:convert';
import 'package:CapitalFlowAI/components/cfconstants.dart';
import 'package:http/http.dart';

class CFServer {
  static Future<double> sliderGraph(Map<String, dynamic> data) async {
    Response response = await post(
      Uri.https(CFConstants.cfServerURL, "/MonthlyBudgetslider"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return json.decode(response.body)['percentage'];
  }
}
