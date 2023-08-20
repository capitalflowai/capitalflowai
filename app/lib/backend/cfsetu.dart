import 'dart:convert';
import 'package:CapitalFlowAI/components/cfconstants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SetuAPI {
  static Future<Map> createConsent(String phoneNumber) async {
    final dateTime = DateTime.now();

    final finalDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(dateTime.toUtc());

    final oneYearLaterTemp = dateTime.add(const Duration(days: 365));

    final oneYearLater = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        .format(oneYearLaterTemp.toUtc());
    http.Response response = await http.post(
      Uri.https('fiu-uat.setu.co', '/consents'),
      headers: {
        'x-client-id': CFConstants.clientID,
        'x-client-secret': CFConstants.clientSecret,
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
        "redirectUrl": "https://setu.co"
      }),
    );
    Map returnData = {};
    Map decoded = json.decode(response.body);
    returnData = {'id': decoded['id'], 'url': decoded['url']};
    return returnData;
  }

  static Future<Map> getConsent(String consentID) async {
    http.Response response = await http.get(
      Uri.parse(
        'https://fiu-uat.setu.co/consents/$consentID',
      ),
      headers: {
        'x-client-id': CFConstants.clientID,
        'x-client-secret': CFConstants.clientSecret,
      },
    );
    Map<String, dynamic> finalResp = {};
    Map decodedResp = json.decode(response.body);
    finalResp['dataLife'] = decodedResp['Detail']['DataLife'];
    finalResp['expiry'] = decodedResp['Detail']['consentExpiry'];
    finalResp['FIDataRange'] = decodedResp['Detail']['FIDataRange'];

    return finalResp;
  }

  static Future<String> createDataSesion(String consentID) async {
    http.Response response = await http.post(
      Uri.https('fiu-uat.setu.co', '/sessions'),
      headers: {
        'x-client-id': CFConstants.clientID,
        'x-client-secret': CFConstants.clientSecret,
        'Content-Type': 'application/json'
      },
      body: json.encode({
        "consentId": consentID,
        "DataRange": {
          "from": "2021-06-30T00:00:00.000Z",
          "to": "2023-06-30T00:00:00.000Z"
        },
        "format": "json"
      }),
    );
    return json.decode(response.body)['id'];
  }

  static Future<Map<String, dynamic>> getData(String id) async {
    http.Response response = await http.get(
      Uri.parse("https://fiu-uat.setu.co/sessions/$id"),
      headers: {
        'x-client-id': CFConstants.clientID,
        'x-client-secret': CFConstants.clientSecret,
      },
    );

    if (response.reasonPhrase == "OK") {
      return json.decode(response.body);
    } else if (response.reasonPhrase == "NOT FOUND") {
      return {"error": 404};
    }
    return {"error": 500};
  }
}
