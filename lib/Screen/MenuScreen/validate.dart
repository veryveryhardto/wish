import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wish/Screen/MenuScreen/memberPage.dart';
import 'package:wish/Screen/Widget/customTextField.dart';
import 'package:wish/Screen/oneContainer.dart';

import '../../Model/Token.dart';
import '../../Model/User/retrieve.dart';
import '../../Provider/UserProvider.dart';
import '../../Service.dart';
import '../Widget/Indicator.dart';
import '../Widget/appBar.dart';
import '../Widget/customToast.dart';

class ValidatePage extends StatefulWidget {
  const ValidatePage({super.key});

  @override
  State<ValidatePage> createState() => _ValidatePageState();
}

class _ValidatePageState extends State<ValidatePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _passwordController = TextEditingController();
  final _tokenStorage = const FlutterSecureStorage();

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: '인증하기',),
      body: OneContainer(
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30,),
              Text('개인정보 보호를 위해' ,style: TextStyle(fontSize: 20),),
              Text('비밀번호를 입력해 주세요.' ,style: TextStyle(fontSize: 20),),
              SizedBox(height: 20,),
              CustomTextField(
                textController: _passwordController,
                title: '비밀번호',
                validator: (val){
                  if(val!.length<0) return '비밀번호를 입력해 주세요.';
                  else return null;
                },
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
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        try {
                          var _password = {
                            "currentPassword":sha256.convert(utf8.encode(_passwordController.text)).toString(),
                            "newPassword":sha256.convert(utf8.encode(_passwordController.text)).toString()
                          };
                          Indicator().show(context);
                          var json = await Service().Fetch(_password, 'patch', '/api/auth/me/password', await Token().AccessRead());
                          var data = Retrieve.fromJson(json);
                          Indicator().dismiss();
                          if(data.code=='success'){
                            await _tokenStorage.write(key: 'pass', value: sha256.convert(utf8.encode(_passwordController.text)).toString());
                            Indicator().show(context);
                            var json = await Service().Fetch('', 'get', '/api/auth/me', await Token().AccessRead());
                            var data = Retrieve.fromJson(json);
                            Indicator().dismiss();
                            if(data.code=='success'){
                              user.setUserData=data;
                              user.setValidate=true;
                              Navigator.pushReplacement(
                                context, MaterialPageRoute(
                                  builder: (context) => const MemberPage()),);
                            }
                            else CustomToast('정보를 불러오지 못했습니다.', context);
                          }
                          else CustomToast('비밀번호가 다릅니다.', context);
                        } catch(e){
                          CustomToast('잘못된 접근입니다.', context);
                          Indicator().dismiss();
                          debugPrint(e as String);
                        }
                      }
                    },
                    child: Text('인증하기')),
              ),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }

}
