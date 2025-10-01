import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wish/Model/Note/NoteList.dart';
import 'package:wish/Screen/Widget/customTextField.dart';

import '../../Model/Token.dart';
import '../../Model/message.dart';
import '../../Provider/UserProvider.dart';
import '../../Service.dart';
import 'Indicator.dart';
import 'customToast.dart';

class NoteDialog {
  late BuildContext _context;

  show(BuildContext context, {bool modified = false,bool create=false, Data? note}) {
    bool _modify = modified;

    TextEditingController title = TextEditingController(text:modified?'':note!.noticeTitle);
    TextEditingController body = TextEditingController(text:modified?'':note!.noticeBody);
    UserProvider user = Provider.of<UserProvider>(context,listen: false);

    bool _isCreatedBy = (note!=null&&user.uuid==note.createdBy)||create?true:false;
    final _formKey = GlobalKey<FormState>();

    return showDialog<void>( context: context,
        builder: (BuildContext context) {
          _context = context;
          return AlertDialog(
            insetPadding: EdgeInsets.all(10),
            content: StatefulBuilder(builder: (context,setState)=>Container(
              constraints: BoxConstraints(
                  maxHeight: (MediaQuery.of(context).size.height)*0.9,
                  minWidth: _modify?(MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3 ? (MediaQuery.of(context).size.width)*0.9:(MediaQuery.of(context).size.width)*0.5:0,
                  maxWidth: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3 ? (MediaQuery.of(context).size.width)*0.9:(MediaQuery.of(context).size.width)*0.5,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _modify?CustomTextField(title: '제목',textController: title,
                      validator: (val){
                      if(val!.length==0) return '제목을 비워둘 수 없습니다.';
                      else return null;
                      },
                    ):Text(title.text,style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                    _modify?Container():Text(note!.createdAt.toString().substring(0,16)),
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
                            validator: (val){
                              if (val!.length==0) return '내용을 비워둘 수 없습니다';
                              else return null;
                            },
                            controller: body,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                        ),],
                    ):Text(body.text),
                    SizedBox(height: 30,),
                    _isCreatedBy?Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(fontSize: 20),
                            padding: EdgeInsets.all(20),
                            elevation: 0,
                            shadowColor: Color(0xffffff),
                          ),
                          onPressed: create?() async {
                            if(_formKey.currentState!.validate()){
                              Indicator().show(context);
                              var json = await Service().Fetch(<String,String>{
                                "title": title.text,
                                "body" : body.text,
                              }, 'post', '/api/notices',await Token().AccessRead());
                              try {
                                var data = Message.fromJson(json);
                                if(data.code=='success'){
                                  Indicator().dismiss();
                                  CustomToast('공지가 등록되었습니다.', context);
                                  Navigator.of(_context).pop();
                                }
                                else CustomToast('등록되지 않았습니다.', context);
                                Indicator().dismiss();
                              } catch(e){
                                CustomToast('잘못된 접근입니다.', context);
                                Indicator().dismiss();
                                print(e);
                              }
                            }
                          }:_modify?(){}:()=>setState(()=>_modify=true),
                          child: Text(create?'생성하기':'수정하기')),
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
                        onPressed: ()=>Navigator.of(_context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          );
        }
    );
  }

}