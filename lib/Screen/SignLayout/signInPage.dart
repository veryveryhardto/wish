import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';
import 'package:provider/provider.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:wish/Model/User/signUp.dart';
import 'package:wish/Screen/SignLayout/signLayout.dart';

import '../../Model/message.dart';
import '../../Provider/UserProvider.dart';
import '../../Service.dart';
import '../Widget/Indicator.dart';
import '../Widget/customTextField.dart';
import '../Widget/customToast.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController affiliationController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //textController.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider ui=Provider.of<UserProvider>(context);

    @override
    void dispose() {
      idController.dispose();
      passwordController.dispose();
      password2Controller.dispose();
      nameController.dispose();
      phoneController.dispose();
      affiliationController.dispose();
      super.dispose();
    }

    return SignLayout(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.chevron_left,color: Color(0xff50C7E1),size: 50,)),
            Center(child: Text('회원가입',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Color(0xff50C7E1)
              ),)),
            CustomTextField(title: 'ID', textController: idController,
              validator: (val){
                if(val!.length<4) return '아이디를 5자 이상으로 설정해 주세요.';
                else return null;
              },
            ),
            CustomTextField(title: '비밀번호', textController: passwordController,
              validator: (val){
                if(val!.length<8) return '비밀번호를 8자 이상으로 설정해 주세요.';
                else if(val!.length==0) return null;
                else return null;
              },
            ),
            CustomTextField(title: '비밀번호 확인', textController: password2Controller,
              validator: (val){
                if(passwordController.text!=password2Controller.text) return '비밀번호가 일치하지 않습니다.';
                else if(val!.length==0) return null;
                else return null;
              },
            ),
            CustomTextField(title: '성명', textController: nameController,
              validator: (val){
                if(val!.length<0) return '이름을 공란으로 둘 수 없습니다.';
                else return null;
              },
            ),
            CustomTextField(title: '전화번호', textController: phoneController,
              validator: (val){
                if(val!.length==0) return '전화번호를 공란으로 둘 수 없습니다.';
                else if (!validator.phone(val!)) return '전화번호를 정확히 작성해 주세요';
                else return null;
              },
              textInputFormatter: [MultiMaskedTextInputFormatter(masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxxx'], separator: '-')],
              textInputType: TextInputType.phone,
            ),
            CustomTextField(title: '소속', textController: affiliationController,
              validator: (val){
                if(val!.length==0) return '소속을 공란으로 둘 수 없습니다.';
                else return null;
              },
            ),
            SizedBox(height:20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 20),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    elevation: 0,
                    shadowColor: Color(0xffffff),
                  ),
                  onPressed: ()async{
                    if(_formKey.currentState!.validate()){
                      Indicator().show(context);
                      var json = await Service().Fetch(SignUp(
                        loginId:idController.text,
                        password: sha256.convert(utf8.encode(passwordController.text)).toString(),
                        name: nameController.text,
                        phone: phoneController.text,
                        affiliation: affiliationController.text
                      ).toJson(), 'put', '/api/auth/sign-up');
                      try {
                        var data = Message.fromJson(json);
                        if(data.code=='success'){
                          Navigator.of(context).pop();
                          CustomToast('회원가입을 축하합니다! 가입한 아이디로 로그인 해 주세요..', context);
                        }
                        else CustomToast('.', context);
                        Indicator().dismiss();
                      } catch(e){
                        CustomToast('잘못된 접근입니다.', context);
                        Indicator().dismiss();
                        print(e);
                      }
                    }
                  }, child: Text('회원가입')),
            ),
          ],
        ),
      ),
    );
  }

}