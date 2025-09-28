class Jobs {
  String? applicantName;
  String? phone;
  Address? address = Address();
  String? categoryUuid;
  String? requestNote;

  Jobs(
      {this.applicantName,
        this.phone,
        this.address,
        this.categoryUuid,
        this.requestNote});

  Jobs.fromJson(Map<String, dynamic> json) {
    applicantName = json['applicantName'];
    phone = json['phone'];
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : Address();
    categoryUuid = json['categoryUuid'];
    requestNote = json['requestNote'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['applicantName'] = this.applicantName;
    data['phone'] = this.phone;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['categoryUuid'] = this.categoryUuid;
    data['requestNote'] = this.requestNote;
    return data;
  }
}

class Address {
  String? address;
  String? addressDetail;
  int? post;

  Address({this.address, this.addressDetail, this.post});

  Address.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    addressDetail = json['addressDetail'];
    post = json['post'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['addressDetail'] = this.addressDetail;
    data['post'] = this.post;
    return data;
  }
}

