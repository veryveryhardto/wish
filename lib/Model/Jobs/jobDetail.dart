class JobDetail {
  String? code;
  String? message;
  Data? data = Data();

  JobDetail({this.code, this.message, this.data});

  JobDetail.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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
  String? jobUuid;
  int? jobStatus;
  String? jobScheduledAt;
  String? jobArea;
  String? jobRequestDesc;
  String? jobCategoryUuid;
  String? jobCategoryName;
  String? jobRequestedBy;
  String? customerName;
  String? customerPhone;
  String? jobManagerUuid;
  String? managerName;
  JobAddress? jobAddress = JobAddress();
  String? jobCreatedAt;

  get jobStatusName {
    switch(jobStatus){
      case -1: return '반려';
      case 0: return '신청';
      case 1: return '배정전';
      case 2: return '배정됨';
      case 3: return '작업중';
      case 4: return '작업완료';
      default: return '오류';
    }
  }

  Data(
      {this.jobUuid,
        this.jobStatus,
        this.jobScheduledAt,
        this.jobArea,
        this.jobRequestDesc,
        this.jobCategoryUuid,
        this.jobCategoryName,
        this.jobRequestedBy,
        this.customerName,
        this.customerPhone,
        this.jobManagerUuid,
        this.managerName,
        this.jobAddress,
        this.jobCreatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    jobUuid = json['job_uuid'];
    jobStatus = json['job_status'];
    jobScheduledAt = json['job_scheduled_at'];
    jobArea = json['job_area'];
    jobRequestDesc = json['job_request_desc'];
    jobCategoryUuid = json['job_category_uuid'];
    jobCategoryName = json['job_category_name'];
    jobRequestedBy = json['job_requested_by'];
    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    jobManagerUuid = json['job_manager_uuid'];
    managerName = json['manager_name'];
    jobAddress = json['job_address'] != null
        ? new JobAddress.fromJson(json['job_address'])
        : null;
    jobCreatedAt = json['job_created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['job_uuid'] = this.jobUuid;
    data['job_status'] = this.jobStatus;
    data['job_scheduled_at'] = this.jobScheduledAt;
    data['job_area'] = this.jobArea;
    data['job_request_desc'] = this.jobRequestDesc;
    data['job_category_uuid'] = this.jobCategoryUuid;
    data['job_category_name'] = this.jobCategoryName;
    data['job_requested_by'] = this.jobRequestedBy;
    data['customer_name'] = this.customerName;
    data['customer_phone'] = this.customerPhone;
    data['job_manager_uuid'] = this.jobManagerUuid;
    data['manager_name'] = this.managerName;
    if (this.jobAddress != null) {
      data['job_address'] = this.jobAddress!.toJson();
    }
    data['job_created_at'] = this.jobCreatedAt;
    return data;
  }
}

class JobAddress {
  int? post;
  String? address;
  String? addressDetail;

  JobAddress({this.post, this.address, this.addressDetail});

  JobAddress.fromJson(Map<String, dynamic> json) {
    post = json['post'];
    address = json['address'];
    addressDetail = json['addressDetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post'] = this.post;
    data['address'] = this.address;
    data['addressDetail'] = this.addressDetail;
    return data;
  }
}