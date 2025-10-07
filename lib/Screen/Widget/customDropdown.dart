import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomDropdown extends StatefulWidget {
  final TextEditingController textController;
  final String title;
  final List<String> list;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? textInputFormatter;
  final ValueChanged<String?>? onChanged;
  bool? readOnly = false;
  CustomDropdown ({super.key, required this.textController, required this.title, required this.list, this.validator, this.readOnly, this.textInputFormatter, this.onChanged});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {

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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 11),
          decoration: const BoxDecoration(
            color: Color(0xfff5f5f5),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: DropdownButton(

            value:controller.text,
            isExpanded: true,
            underline: SizedBox(),
            items: widget.list.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,),
              );
            }).toList(),
            icon: Icon(Icons.arrow_drop_down, color: Colors.black,),
            onChanged: widget.onChanged??(val) {
              setState(() {
                controller.text = val.toString();
              });
            },
          ),
        ),
        SizedBox(height: 10,),
      ],
    );
  }
}