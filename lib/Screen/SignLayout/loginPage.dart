import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Screen/SignLayout/signInPage.dart';
import 'package:wish/Screen/SignLayout/signLayout.dart';

import '../../Provider/UIProvider.dart';
import '../Widget/customTextField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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
          Center(child: Image(image: AssetImage('assets/image/logo-banner.png'),width: MediaQuery.of(context).size.width<400?MediaQuery.of(context).size.width*0.8:400,)),
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
    );
  }

}
