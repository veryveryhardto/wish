class JobResponse {
  String? code;
  Data? data;

  JobResponse({this.code, this.data});

  JobResponse.fromJson(Map<String, dynamic> json) {
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
  String? jobUuid;
  String? usedUserUuid;
  bool? userCreated;

  Data({this.jobUuid, this.usedUserUuid, this.userCreated});

  Data.fromJson(Map<String, dynamic> json) {
    jobUuid = json['job_uuid'];
    usedUserUuid = json['used_user_uuid'];
    userCreated = json['user_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['job_uuid'] = this.jobUuid;
    data['used_user_uuid'] = this.usedUserUuid;
    data['user_created'] = this.userCreated;
    return data;
  }
}