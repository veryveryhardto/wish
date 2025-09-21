class SignUp {
  String? loginId;
  String? password;
  String? name;
  String? phone;
  String? affiliation;

  SignUp(
      {this.loginId, this.password, this.name, this.phone, this.affiliation});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loginId'] = this.loginId;
    data['password'] = this.password;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['affiliation'] = this.affiliation;
    return data;
  }
}