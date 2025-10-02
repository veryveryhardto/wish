
List<String> memberRole = ['고객','현장담당자','본사담당자','Master'];

class MemberList {
  String? code;
  Data? data;

  MemberList({this.code, this.data});

  MemberList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? total;
  int? limit;
  int? offset;
  List<Items>? items;

  Data({this.total, this.limit, this.offset, this.items});

  Data.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? userUuid;
  String? loginId;
  String? name;
  String? phone;
  String? affiliation;
  int? role;
  String? createdAt;

  get roleName {
    switch(role){
      case 0: return '고객';
      case 1: return '현장담당자';
      case 2: return '본사담당자';
      case 3: return 'Master';
      default: return 'error';
    }
  }

  Items(
      {this.userUuid,
        this.loginId,
        this.name,
        this.phone,
        this.affiliation,
        this.role,
        this.createdAt});

  Items.fromJson(Map<String, dynamic> json) {
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