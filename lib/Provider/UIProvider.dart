import 'package:flutter/material.dart';

class UIProvider with ChangeNotifier{
  int _isSignPage=0;
  var _isLogined=false;


  get isSignPage => _isSignPage;
  set setSignPage(int val) {
    _isSignPage=val;
    notifyListeners();
  }

  get isLogined => _isLogined;
  set setLogined(bool val) {
    _isLogined=val;
    notifyListeners();
  }
}