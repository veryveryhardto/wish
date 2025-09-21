class NoteList {
  String? code;
  List<Data>? data;

  NoteList({this.code, this.data});

  NoteList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? noticeUuid;
  String? noticeTitle;
  String? noticeBody;
  bool? isPinned;
  String? createdBy;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.noticeUuid,
        this.noticeTitle,
        this.noticeBody,
        this.isPinned,
        this.createdBy,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    noticeUuid = json['notice_uuid'];
    noticeTitle = json['notice_title'];
    noticeBody = json['notice_body'];
    isPinned = json['is_pinned'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notice_uuid'] = this.noticeUuid;
    data['notice_title'] = this.noticeTitle;
    data['notice_body'] = this.noticeBody;
    data['is_pinned'] = this.isPinned;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}