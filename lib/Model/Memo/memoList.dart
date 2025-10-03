import 'package:intl/intl.dart';

class MemoList {
  String? code;
  String? message;
  List<Data>? data = [];

  MemoList({this.code, this.message, this.data});

  MemoList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? memoUuid;
  String? content;
  DateTime? createdAt;
  String? writerUuid;
  String? writerName;

  Data(
      {this.memoUuid,
        this.content,
        this.createdAt,
        this.writerUuid,
        this.writerName});

  Data.fromJson(Map<String, dynamic> json) {
    memoUuid = json['memoUuid'];
    content = json['content'];
    createdAt = DateTime.parse(json['createdAt']);
    writerUuid = json['writerUuid'];
    writerName = json['writerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memoUuid'] = this.memoUuid;
    data['content'] = this.content;
    data['createdAt'] = this.createdAt.toString();
    data['writerUuid'] = this.writerUuid;
    data['writerName'] = this.writerName;
    return data;
  }
}