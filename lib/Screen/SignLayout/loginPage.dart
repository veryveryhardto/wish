import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Model/Token.dart';
import 'package:wish/Model/User/signIn.dart';
import 'package:wish/Screen/SignLayout/signInPage.dart';
import 'package:wish/Screen/SignLayout/signLayout.dart';
import 'package:wish/Screen/Widget/customToast.dart';
import 'package:wish/Screen/mainScreen.dart';
import 'package:wish/Service.dart';

import '../../Provider/UserProvider.dart';
import '../Widget/Indicator.dart';
import '../Widget/customTextField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //textController.addListener(listener);
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    UserProvider user=Provider.of<UserProvider>(context);

    return SignLayout(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.chevron_left,color: Color(0xff50C7E1),size: 50,)),
            Center(child: Image(image: AssetImage('assets/image/logo-banner.png'),width: MediaQuery.of(context).size.width<400?MediaQuery.of(context).size.width*0.8:400,)),
            CustomTextField(title: 'ID', textController: idController,
              validator: (val){
                if(val!.length<0) return 'ID를 입력해 주세요';
                else return null;
              },
            ),
            CustomTextField(title: '비밀번호', textController: passwordController,
              validator: (val){
                if(val!.length<0) return '비밀번호를 입력해 주세요.';
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
                  onPressed: () async{

                  if(_formKey.currentState!.validate()){
                    Indicator().show(context);
                    Map<String,String> _signIn = {
                      "loginId" : idController.text,
                      "password" : sha256.convert(utf8.encode(passwordController.text)).toString(),
                    };
                    var json = await Service().Fetch(_signIn, 'post', '/api/auth/sign-in');
                    try {
                      var data = SignIn.fromJson(json);
                      if(data.code=='success'){
                        Indicator().dismiss();
                        /*
                        if(data.data!.user!.role==0) CustomToast('아직 접근권한이 없습니다. 권한 설정이 완료될 때 까지 기다려주세요.', context);
                        else{
                          user.setRoll = data.data!.user!.role!;
                        await Token().Write(data, sha256.convert(utf8.encode(passwordController.text)).toString());
                        CustomToast('로그인에 성공했습니다.', context);
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
                        }
                        */
                        user.setRoll = data.data?.user?.role??0;
                        user.setUUID = data.data?.user?.userUuid??'';
                        await Token().Write(data,user.uuid,user.role);
                        CustomToast('로그인에 성공했습니다.', context);
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
                      }
                      else CustomToast('아이디나 비밀번호가 다릅니다.', context);
                      Indicator().dismiss();
                    } catch(e){
                      CustomToast('잘못된 접근입니다.', context);
                      Indicator().dismiss();
                      print(e);
                    }
                  }

                }, child: Text('로그인하기')),
            ),
            SizedBox(height: 5,),
            Container(
              width: double.infinity,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side:BorderSide(color: Color(0xff50C7E1)),
                      padding: EdgeInsets.symmetric(vertical: 20)
                  ),
                  onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage())),
                child: Text('회원가입',style: TextStyle(fontSize: 20,color: Color(0xff50C7E1))),
            ))
          ],
        ),
      ),
    );
  }

}
