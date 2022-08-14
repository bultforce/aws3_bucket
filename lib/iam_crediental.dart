import 'dart:collection';

class IAMCrediental {
  String? secretKey;
  String? secretId;
  String? identity;


  IAMCrediental({this.secretKey, this.secretId,this.identity});

  IAMCrediental.fromMap(LinkedHashMap<Object?, Object?> map) {

    if (map["secretKey"] != null) {
      secretKey = map["secretKey"].toString();
    }
    if (map["secretId"] != null) {
      secretId =map["secretId"].toString();
    }
    if (map["identity"] != null) {
      identity = map["identity"].toString();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'secretKey': secretKey,
      'secretId': secretId,
      'identity': identity
    };
  }


}