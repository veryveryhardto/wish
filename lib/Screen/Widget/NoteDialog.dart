import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wish/Model/Note/NoteList.dart';
import 'package:wish/Screen/Widget/customTextField.dart';

import '../../Provider/UserProvider.dart';

class NoteDialog {
  late BuildContext _context;

  show(BuildContext context, {bool modified = false, Data? note}) {
    bool _modify = modified;
    TextEditingController title = TextEditingController(text:modified?'':note!.noticeTitle);
    TextEditingController body = TextEditingController(text:modified?'':note!.noticeBody);
    UserProvider user =Provider.of<UserProvider>(context,listen: false);
    ///현재 로그인한 유저 아이디와 작성자 아이디 같을경우 created

    return showDialog<void>( context: context, barrierDismissible: false,
        builder: (BuildContext context) {
          _context = context;
          return Form(
            child: AlertDialog(
              insetPadding: EdgeInsets.all(10),
              content: StatefulBuilder(builder: (context,setState)=>Container(
                constraints: BoxConstraints(
                    maxHeight: (MediaQuery.of(context).size.height)*0.9,
                    minWidth: _modify?(MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3 ? (MediaQuery.of(context).size.width)*0.9:(MediaQuery.of(context).size.width)*0.5:0,
                    maxWidth: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3 ? (MediaQuery.of(context).size.width)*0.9:(MediaQuery.of(context).size.width)*0.5,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _modify?CustomTextField(title: '제목',textController: title,
                      validator: (val){
                      },
                    ):Text(title.text),
                    _modify?Container():Text(note!.createdAt??'날짜'),
                    _modify?Container():Text(note!.createdBy??'작성자'),
                    SizedBox(height: 30,),
                    _modify?Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [Align(
                        alignment: Alignment.centerLeft,
                        child: Text('내용', style: TextStyle(
                            fontWeight: FontWeight.bold, color: Color(0xff50C7E1)),),),
                        SizedBox(height: 5,),
                        Container(
                          height: (MediaQuery.of(context).size.height)*0.5,
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.top,
                            expands: true,
                            decoration: InputDecoration(
                              isDense: true,
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
                            controller: body,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                        ),],
                    ):Text(body.text),
                    SizedBox(height: 30,),
                    user.role==3?Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(fontSize: 20),
                            padding: EdgeInsets.all(20),
                            elevation: 0,
                            shadowColor: Color(0xffffff),
                          ),
                          onPressed: _modify?(){}:()=>setState(()=>_modify=true),
                          child: Text('수정하기')),
                    ):Container(),
                    SizedBox(height: 5,),
                    Container(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          textStyle: TextStyle(fontSize: 20),
                          padding: EdgeInsets.all(20),
                          side:BorderSide(color: Color(0xff50C7E1)),
                        ),
                        child: Text("닫기",style: TextStyle(color: Color(0xff50C7E1)),),
                        onPressed: ()=>Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              )),
            ),
          );
        }
    );
  }

}