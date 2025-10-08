class Jobs {
  String? applicantName;
  String? phone;
  Address address = Address();
  String? categoryUuid;
  String? requestNote;

  Jobs(
      {this.applicantName,
        this.phone,
        required this.address,
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

  toJson() {
    final data = Map<String,dynamic>.identity();
    data['applicantName'] = this.applicantName ?? '';
    data['phone'] = this.phone??'';
    if (this.address != null) {
      data['address'] = this.address!.toJson().toString();
    }
    data['categoryUuid'] = this.categoryUuid??'';
    data['requestNote'] = this.requestNote??'';
    print(data.runtimeType);
    return data;
  }
}

class Address {
  String? address = '';
  String? addressDetail = '';
  int? post = 0;

  Address({this.address, this.addressDetail, this.post});

  Address.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    addressDetail = json['addressDetail'];
    post = json['post'];
  }

  toJson() {
    final data = Map<String,dynamic>.identity();
    data['address'] = this.address ?? '';
    data['addressDetail'] = this.addressDetail ?? '';
    data['post'] = this.post??0;
    return data;
  }
}

