import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/UIProvider.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController textController;
  final String title;
  String data = '';
  CustomTextFormField({super.key, required this.textController, required this.title, this.data=''});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.title),
        TextField(
          controller: widget.textController,
          onChanged: (val)=>setState(()=>widget.data = widget.textController.text),
        )
      ],
    );
  }
}