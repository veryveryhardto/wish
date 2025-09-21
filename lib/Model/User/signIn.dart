import 'package:wish/Model/message.dart';

class SignIn extends Message {
  String? code;
  Data? data;

  SignIn({this.code, this.data,});

  SignIn.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    detail = json['detail'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  String? accessToken;
  String? accessTokenExp;
  String? refreshToken;
  String? refreshTokenExp;
  User? user;

  Data(
      {this.accessToken,
        this.accessTokenExp,
        this.refreshToken,
        this.refreshTokenExp,
        this.user});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    accessTokenExp = json['accessTokenExp'];
    refreshToken = json['refreshToken'];
    refreshTokenExp = json['refreshTokenExp'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }
}

class User {
  String? userUuid;
  int? role;
  String? loginId;

  User({this.userUuid, this.role, this.loginId});

  User.fromJson(Map<String, dynamic> json) {
    userUuid = json['userUuid'];
    role = json['role'];
    loginId = json['loginId'];
  }
}