class Message {
  String? code;
  String? message;
  String? detail;

  Message({this.code, this.message, this.detail});

  Message.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    detail = json['detail'];
  }
}
