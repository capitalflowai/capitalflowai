import 'package:firebase_auth/firebase_auth.dart';

class CFUser {
  String name = "";
  String email = "";
  String uid = "";
  String consentID = "";
  bool hasConsented = false;
  Map<String, dynamic> consentDetails = {};
  CFUser({
    required this.name,
    required this.email,
    required this.uid,
    required this.consentID,
    required this.hasConsented,
    required this.consentDetails,
  });

  CFUser.fromMap(Map<String, dynamic> initialMap, User? tempUser)
      : name = tempUser!.displayName ?? '',
        email = tempUser.email ?? '',
        uid = tempUser.uid,
        consentID = initialMap['consentID'] ?? '',
        hasConsented = initialMap['hasConsented'] ?? false,
        consentDetails = initialMap['consentDetails'] ?? {};

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
      'consentID': consentID,
      'hasConsented': hasConsented,
      'consentDetails': consentDetails,
    };
  }
}
