import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Indicator {
  static final Indicator _singleton = Indicator._internal();
  late BuildContext _context;
  bool isDisplayed = false;

  factory Indicator() => _singleton;
  Indicator._internal();

  show(BuildContext context, {String text = '로딩중입니다.'}) {

    if(isDisplayed) return;
    showDialog<void>( context: context, barrierDismissible: false,
        builder: (BuildContext context) {
          _context = context;
          isDisplayed = true;
          return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              backgroundColor: Colors.white,
              children: [ Center(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                        child: CircularProgressIndicator(),),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(text),)
                    ]),
              )] ,
            ),);
        }
    );
  }

  dismiss() {
    if(isDisplayed) {
      Navigator.of(_context).pop();
      isDisplayed = false;
    }
  }
}