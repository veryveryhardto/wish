import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NoteDialog {
  late BuildContext _context;

  show(BuildContext context, {bool modified = false}) {

    showDialog<void>( context: context, barrierDismissible: false,
        builder: (BuildContext context) {
          _context = context;
          return AlertDialog(
            insetPadding: EdgeInsets.all(10),

            content: StatefulBuilder(builder: (context,setState)=>Container(
              width: double.infinity,
              height: double.infinity,
            )),
          );
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