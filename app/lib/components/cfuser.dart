import 'package:firebase_auth/firebase_auth.dart';

class CFUser {
  String name = "";
  String email = "";
  String uid = "";
  String consentID = "";
  String sessionID = "";
  double eomBalance = 0.0;
  double monthlyBudget = 0.0;
  bool hasConsented = false;
  String avatar = "";
  Map<String, dynamic> consentDetails = {};
  CFUser({
    required this.name,
    required this.email,
    required this.uid,
    required this.consentID,
    required this.hasConsented,
    required this.consentDetails,
    required this.sessionID,
    required this.eomBalance,
    required this.monthlyBudget,
    required this.avatar,
  });

  CFUser.fromMap(Map<String, dynamic> initialMap, User? tempUser)
      : name = tempUser!.displayName ?? '',
        email = tempUser.email ?? '',
        uid = tempUser.uid,
        consentID = initialMap['consentID'] ?? '',
        sessionID = initialMap['sessionID'] ?? '',
        eomBalance = initialMap['eomBalance'] ?? 0.0,
        monthlyBudget = initialMap['monthlyBudget'] ?? 0.0,
        hasConsented = initialMap['hasConsented'] ?? false,
        avatar = initialMap['avatar'] ?? "",
        consentDetails = initialMap['consentDetails'] ?? {};

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
      'consentID': consentID,
      'sessionID': sessionID,
      'eomBalance': eomBalance,
      'monthlyBudget': monthlyBudget,
      'avatar': avatar,
      'hasConsented': hasConsented,
      'consentDetails': consentDetails,
    };
  }
}
