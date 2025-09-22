import 'package:flutter/material.dart';
import 'package:windows_toast/windows_toast.dart';

CustomToast(String text, BuildContext context, {String? position}){

  return WindowsToast.show(
      text,
      context,
      position=='bottom'?MediaQuery.of(context).size.height*0.15:MediaQuery.of(context).size.height*0.5,
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 19,
      ),
      toastColor: Colors.green
  );
}