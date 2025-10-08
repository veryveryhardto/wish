class JobList_Customer {
  String? code;
  String? message;
  Data? data = Data();

  JobList_Customer({this.code, this.message, this.data});

  JobList_Customer.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : Data();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Items>? items = [];

  Data({this.items});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? jobUuid;
  int? jobStatus;
  String? jobScheduledAt;
  DateTime? jobScheduleTime;
  Null? jobArea;
  String? jobRequestDesc;
  String? jobCategoryUuid;
  String? jobCategoryName;
  String? customerName;
  String? customerPhone;
  Null? managerName;
  Null? jobManagerUuid;

  get jobStatusName {
    switch(jobStatus){
      case 0: return '신청';
      case 1: return '배정전';
      case 2: return '배정됨';
      case 3: return '작업중';
      case 4: return '작업완료';
      default: return '반려';
    }
  }
  Items(
      {this.jobUuid,
        this.jobStatus,
        this.jobScheduledAt,
        this.jobScheduleTime,
        this.jobArea,
        this.jobRequestDesc,
        this.jobCategoryUuid,
        this.jobCategoryName,
        this.customerName,
        this.customerPhone,
        this.managerName,
        this.jobManagerUuid});

  Items.fromJson(Map<String, dynamic> json) {
    jobUuid = json['job_uuid'];
    jobStatus = json['job_status'];
    jobScheduledAt = json['job_scheduled_at'];
    jobScheduleTime = json['job_scheduled_at']==null||json['job_scheduled_at']=='null'?null:DateTime.parse(json['job_scheduled_at']);
    jobArea = json['job_area'];
    jobRequestDesc = json['job_request_desc'];
    jobCategoryUuid = json['job_category_uuid'];
    jobCategoryName = json['job_category_name'];
    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    managerName = json['manager_name'];
    jobManagerUuid = json['job_manager_uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['job_uuid'] = this.jobUuid;
    data['job_status'] = this.jobStatus;
    data['job_scheduled_at'] = this.jobScheduleTime==null?this.jobScheduleTime.toString():null;
    data['job_area'] = this.jobArea;
    data['job_request_desc'] = this.jobRequestDesc;
    data['job_category_uuid'] = this.jobCategoryUuid;
    data['job_category_name'] = this.jobCategoryName;
    data['customer_name'] = this.customerName;
    data['customer_phone'] = this.customerPhone;
    data['manager_name'] = this.managerName;
    data['job_manager_uuid'] = this.jobManagerUuid;
    return data;
  }
}