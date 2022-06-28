import 'dart:collection';

class IAMCrediental {
  String? sercetKey;
  String? sercetId;
  String? identity;


  IAMCrediental({this.sercetKey, this.sercetId,this.identity});

  IAMCrediental.fromMap(LinkedHashMap<Object?, Object?> map) {

    if (map["sercetKey"] != null) {
      sercetKey = map["sercetKey"].toString();
    }
    if (map["sercetId"] != null) {
      sercetId =map["sercetId"].toString();
    }
    if (map["identity"] != null) {
      identity = map["identity"].toString();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'sercetKey': sercetKey,
      'sercetId': sercetId,
      'identity': identity
    };
  }


}