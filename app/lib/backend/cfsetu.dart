import 'dart:convert';

import 'package:CapitalFlowAI/routes/cfroute_names.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SetuAPI {
  static Future<Map> createConsent(String phoneNumber) async {
    final dateTime = DateTime.now();

    final finalDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(dateTime.toUtc());

    final oneYearLaterTemp = dateTime.add(Duration(days: 365));

    final oneYearLater = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        .format(oneYearLaterTemp.toUtc());
    http.Response response = await http.post(
      Uri.https('fiu-uat.setu.co', '/consents'),
      headers: {
        'x-client-id': '95074533-43ae-4f7a-855c-ff1245d76936',
        'x-client-secret': 'ba62d6f5-e9ba-4f18-8b0b-d60d959b9eb1',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        "Detail": {
          "consentStart": finalDate,
          "consentExpiry": oneYearLater,
          "Customer": {"id": "$phoneNumber@onemoney"},
          "FIDataRange": {
            "from": "2021-06-30T00:00:00Z",
            "to": "2023-06-30T00:00:00Z"
          },
          "consentMode": "STORE",
          "consentTypes": ["TRANSACTIONS", "PROFILE", "SUMMARY"],
          "fetchType": "PERIODIC",
          "Frequency": {"value": 30, "unit": "MONTH"},
          "DataLife": {"value": 1, "unit": "MONTH"},
          "DataConsumer": {"id": "setu-fiu-id"},
          "Purpose": {
            "Category": {"type": "string"},
            "code": "101",
            "text": "Loan underwriting",
            "refUri": "https://api.rebit.org.in/aa/purpose/101.xml"
          },
          "fiTypes": ["DEPOSIT"]
        },
        "context": [
          {"key": "accounttype", "value": "CURRENT"}
        ],
        // "redirectUrl": "capitalflowai://consent"
        "redirectUrl": "https://setu.co"
      }),
    );
    Map returnData = {};
    Map decoded = json.decode(response.body);
    returnData = {'id': decoded['id'], 'url': decoded['url']};
    return returnData;
  }
}
