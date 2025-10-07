import 'package:wish/Model/message.dart';

class Retrieve extends Message{
  String? code;
  String? message;
  String? detail;
  Data? data = Data();

  Retrieve({this.code, this.message, this.detail, this.data});

  Retrieve.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    detail = json['detail'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  String? userUuid;
  String? loginId;
  String? name;
  String? phone;
  String? affiliation;
  int? role;
  String? createdAt;

  get roleName {
    switch(role){
      case 1: return '현장담당자';
      case 2: return '본사담당자';
      case 3: return 'Master';
      default: return 'error';
    }
  }

  Data(
      {this.userUuid,
        this.loginId,
        this.name,
        this.phone,
        this.affiliation,
        this.role,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    userUuid = json['userUuid'];
    loginId = json['loginId'];
    name = json['name'];
    phone = json['phone'];
    affiliation = json['affiliation'];
    role = json['role'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userUuid'] = this.userUuid;
    data['loginId'] = this.loginId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['affiliation'] = this.affiliation;
    data['role'] = this.role;
    data['createdAt'] = this.createdAt;
    return data;
  }
}