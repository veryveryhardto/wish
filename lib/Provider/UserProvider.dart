import 'package:flutter/material.dart';
import 'package:wish/Model/User/retrieve.dart';

class UserProvider with ChangeNotifier{
  int _role=0;
  var _isValidate=false;
  Retrieve _userData = Retrieve();

  get isValidtate => _isValidate;
  set setValidate(bool val) {
    _isValidate=val;
    notifyListeners();
  }

  get role => _role;
  set setRoll(int val) {
    _role=val;
    notifyListeners();
  }

  get userData => _userData.data;
  set setUserData(Retrieve data){
    _userData = data;
    notifyListeners();
  }

}