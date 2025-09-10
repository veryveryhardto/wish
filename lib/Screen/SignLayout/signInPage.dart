import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Screen/SignLayout/signLayout.dart';

import '../../Provider/UIProvider.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //textController.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    UIProvider ui=Provider.of<UIProvider>(context);

    @override
    void dispose() {
      idController.dispose();
      passwordController.dispose();
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
              id=idController.text;
            },
          ),
          CustomTextField(title: '비밀번호', textController: passwordController,
            onChnaged: (val){
              password=passwordController.text;
            },
          ),
          CustomTextField(title: '비밀번호 확인', textController: passwordController,
            onChnaged: (val){
              password=passwordController.text;
            },
          ),
          CustomTextField(title: '성명', textController: passwordController,
            onChnaged: (val){
              password=passwordController.text;
            },
          ),
          CustomTextField(title: '전화번호', textController: passwordController,
            onChnaged: (val){
              password=passwordController.text;
            },
          ),
          CustomTextField(title: '소속', textController: passwordController,
            onChnaged: (val){
              password=passwordController.text;
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
                onPressed: (){
                  print(id);
                  print(password);
                }, child: Text('회원가입')),
          ),
        ],
      ),
    );
  }

}