import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Screen/Widget/customTextField.dart';
import 'package:wish/Screen/oneContainer.dart';
import 'package:flutter_secure_storage_web/flutter_secure_storage_web.dart';

import '../../Model/Token.dart';
import '../../Model/message.dart';
import '../../Provider/UserProvider.dart';
import '../../Service.dart';
import '../Widget/Indicator.dart';
import '../Widget/appBar.dart';
import '../Widget/customToast.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {

  FlutterSecureStorageWeb _tokenStorage = FlutterSecureStorageWeb();
  Token token = Token();
  bool _readOnly = true;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _password2Controller = TextEditingController();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _affiliationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserProvider user = Provider.of<UserProvider>(context,listen: false);

    _nameController = TextEditingController(text: user.userData.name);
    _phoneController = TextEditingController(text: user.userData.phone);
    _affiliationController = TextEditingController(text: user.userData.affiliation);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordController.dispose();
    _password2Controller.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _affiliationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: '유저 정보',),
      body: OneContainer(
        Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 30,),
              _readOnly?CustomTextField(data: user.userData.loginId, title: '유저ID', readOnly: _readOnly,):Container(),
              _readOnly?Container():Text('* 비밀번호를 바꾸지 않으시려면 비밀번호란을 공란으로 두세요.'),
              _readOnly?Container():CustomTextField(
                textController: _passwordController,
                title: '새 비밀번호',
                readOnly: _readOnly,
                validator: (val){
                  if(val!.length==0) return null;
                  else if(val!.length<8) return '비밀번호를 8자 이상으로 설정해 주세요.';
                  else return null;
                },
              ),
              _readOnly?Container():CustomTextField(
                textController: _password2Controller,
                title: '비밀번호 확인',
                readOnly: _readOnly,
                validator: (val){
                  if(val!.length==0) return null;
                  else if(_passwordController.text!=_password2Controller.text) return '비밀번호가 일치하지 않습니다.';
                  else return null;
                },),
              CustomTextField(
                textController: _nameController,
                title: '이름',
                readOnly: _readOnly,
                validator: (val){
                  if(val!.length==0) return '이름을 공란으로 둘 수 없습니다.';
                  else return null;
                },
              ),
              CustomTextField(
                textController: _phoneController,
                title: '전화번호',
                readOnly: _readOnly,
                validator: (val){
                  if(val!.length==0) return '전화번호를 공란으로 둘 수 없습니다.';
                  else return null;
                },
              ),
              _readOnly?CustomTextField(data: user.userData.roleName, title: '등급', readOnly: _readOnly,):Container(),
              CustomTextField(
                textController: _affiliationController,
                title: '소속',
                readOnly: _readOnly,
              ),
              SizedBox(height: 30,),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 20),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      elevation: 0,
                      shadowColor: Color(0xffffff),
                    ),
                    onPressed: _readOnly?()=>setState(()=>_readOnly=false):() async {
                      if(_formKey.currentState!.validate()){
                        Indicator().show(context);
                        Map<String,String> _update = {
                          "name" : _nameController.text,
                          "phone" : _phoneController.text,
                          "affiliation" : _affiliationController.text
                        };
                        var json = await Service().Fetch(_update, 'patch', '/api/auth/me', await token.AccessRead());
                        try {
                          var data = Message.fromJson(json);
                          if(data.code=='success'){
                            if(_phoneController.text.isNotEmpty){
                              Map<String,String> _password = {
                                "currentPassword" : await _tokenStorage.read(key: 'pass', options: {
                                  "wrapKey": "!!!!myWraKey!!!"
                                })??'',
                                "newPassword" : sha256.convert(utf8.encode(_passwordController.text)).toString(),
                              };
                              var passwordjson = await Service().Fetch(_password, 'patch', '/api/auth/me/password', await token.AccessRead());
                              var passworddata = Message.fromJson(passwordjson);
                              if(passworddata.code!='success') {
                                CustomToast('회원정보를 변경했으나 비밀번호가 변경되지 않았습니다.', context);
                                Indicator().dismiss();
                                return;
                              }
                            }
                            setState(()=>_readOnly=true);
                            _password2Controller.text='';
                            _passwordController.text='';
                            await _tokenStorage.delete(key: 'pass', options: {
                              "wrapKey": "!!!!myWraKey!!!"
                            });
                            CustomToast('회원정보를 변경했습니다.', context);
                            Indicator().dismiss();
                          }
                          else CustomToast('정보를 변경하지 못했습니다.', context);
                          Indicator().dismiss();
                        } catch(e){
                          CustomToast('잘못된 접근입니다.', context);
                          Indicator().dismiss();
                          debugPrint(e as String);
                        }
                      }
                    },
                  child: Text('수정하기')),
              ),
              SizedBox(height: 5,),
              _readOnly?Container():Container(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side:BorderSide(color: Color(0xff50C7E1)),
                        padding: EdgeInsets.symmetric(vertical: 20)
                    ),
                    onPressed: ()=>setState(()=>_readOnly=true),
                    child: Text('취소',style: TextStyle(fontSize: 20,color: Color(0xff50C7E1))),
                  )),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }

}
