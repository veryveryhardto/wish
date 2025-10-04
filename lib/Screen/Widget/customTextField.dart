import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? textController;
  final String title;
  final String? data;
  final ValueChanged<String>? onChnaged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? textInputFormatter;
  final TextInputType? textInputType;
  final GestureTapCallback? onTap;
  bool? readOnly = false;
  CustomTextField({super.key, this.textController, required this.title, this.onChnaged, this.validator, this.readOnly, this.textInputFormatter, this.textInputType, this.data, this.onTap});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  late TextEditingController controller = widget.textController??TextEditingController();


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
          onTap: widget.onTap,
          autovalidateMode: widget.title.contains('비밀번호') ? AutovalidateMode.onUserInteraction:AutovalidateMode.disabled,
          inputFormatters: widget.textInputFormatter,
          obscureText: widget.title.contains('비밀번호') ? true : false,
          controller: widget.textController,
          onChanged: widget.onChnaged,
          validator: widget.validator,
          readOnly: widget.readOnly??false,
          keyboardType: widget.textInputType,
          initialValue: widget.data,
        ),
        SizedBox(height: 10,),
      ],
    );
  }
}