import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Model/User/signUp.dart';
import 'package:wish/Screen/SignLayout/signLayout.dart';

import '../../Model/message.dart';
import '../../Provider/UserProvider.dart';
import '../../Service.dart';
import '../Widget/customTextField.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  String id = '';
  String password = '';
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
    UIProvider ui=Provider.of<UIProvider>(context);
    SignUp user = SignUp();

    @override
    void dispose() {
      idController.dispose();
      passwordController.dispose();
      nameController.dispose();
      phoneController.dispose();
      affiliationController.dispose();
      super.dispose();
    }

    return SignLayout(
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
            onChnaged: (val){
              user.loginId=idController.text;
            },
          ),
          CustomTextField(title: '비밀번호', textController: passwordController,
            onChnaged: (val){
              user.password=passwordController.text;
            },
          ),
          CustomTextField(title: '성명', textController: nameController,
            onChnaged: (val){
              user.name=nameController.text;
            },
          ),
          CustomTextField(title: '전화번호', textController: phoneController,
            onChnaged: (val){
              user.phone=phoneController.text;
            },
          ),
          CustomTextField(title: '소속', textController: affiliationController,
            onChnaged: (val){
              user.affiliation=affiliationController.text;
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

                  var json = await Service().Fetch(user.toJson(), 'put', '/api/auth/sign-up');
                  try {
                    var data = Message.fromJson(json);
                    print(data.code);
                  } catch(e){
                    print(e);
                  }
                }, child: Text('회원가입')),
          ),
        ],
      ),
    );
  }

}