import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textController;
  final String title;
  final ValueChanged<String>? onChnaged;
  final FormFieldValidator<String>? validator;
  bool? readOnly = false;
  CustomTextField({super.key, required this.textController, required this.title, this.onChnaged, this.validator, this.readOnly});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  late TextEditingController controller = widget.textController;


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(widget.title, style: TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xff50C7E1)),),),
        SizedBox(height: 5,),
        TextFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xfff5f5f5),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide.none
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  width: 2,
                  color: Color(0xff50C7E1),
                )
            ),
          ),
          obscureText: widget.title == '비밀번호' ? true : false,
          controller: widget.textController,
          onChanged: widget.onChnaged,
          validator: widget.validator,
          readOnly: widget.readOnly! ? true:false,
        ),
        SizedBox(height: 10,),
      ],
    );
  }
}