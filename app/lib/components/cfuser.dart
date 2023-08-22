import 'package:firebase_auth/firebase_auth.dart';

class CFUser {
  String name = "";
  String email = "";
  String uid = "";
  String phone = "";
  String consentID = "";
  String sessionID = "";
  double eomBalance = 0.0;
  double monthlyBudget = 0.0;
  double spentRatio = 0.0;
  bool hasConsented = false;
  String avatar = "";
  Map<String, dynamic> consentDetails = {};
  Map<String, dynamic> transactions = {};

  CFUser({
    required this.name,
    required this.email,
    required this.uid,
    required this.phone,
    required this.consentID,
    required this.hasConsented,
    required this.consentDetails,
    required this.sessionID,
    required this.eomBalance,
    required this.monthlyBudget,
    required this.spentRatio,
    required this.avatar,
    required this.transactions,
  });

  CFUser.fromMap(Map<String, dynamic> initialMap, User? tempUser)
      : name = tempUser!.displayName ?? '',
        email = tempUser.email ?? '',
        uid = tempUser.uid,
        consentID = initialMap['consentID'] ?? '',
        sessionID = initialMap['sessionID'] ?? '',
        phone = initialMap['phone'] ?? '',
        eomBalance = initialMap['eomBalance'] ?? 0.0,
        monthlyBudget = initialMap['monthlyBudget'] ?? 0.0,
        spentRatio = initialMap['spentRatio'] ?? 0.0,
        hasConsented = initialMap['hasConsented'] ?? false,
        avatar = initialMap['avatar'] ?? "",
        consentDetails = initialMap['consentDetails'] ?? {},
        transactions = initialMap['transactions'] ?? {};

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
      'phone': phone,
      'consentID': consentID,
      'sessionID': sessionID,
      'eomBalance': eomBalance,
      'monthlyBudget': monthlyBudget,
      'avatar': avatar,
      'hasConsented': hasConsented,
      'consentDetails': consentDetails,
      'spentRatio': spentRatio,
    };
  }
}
