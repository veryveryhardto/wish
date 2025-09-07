import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Screen/SignLayout/signLayout.dart';
import 'package:wish/Screen/Widget/customTextFormField.dart';

import '../../Provider/UIProvider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String id = '';
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //textController.addListener(listener);
  }
  
  @override
  Widget build(BuildContext context) {
    UIProvider ui=Provider.of<UIProvider>(context);
    return SignLayout(
      child: Column(
        children: [
          //Image(image: AssetImage('assets/images/farm.png'),width: 200,),
          CustomTextFormField(title: 'ID',data: id,textController: textController,),
          SizedBox(height: 10,),
          TextFormField(
            decoration: const InputDecoration(
              labelText: '비밀번호',
            ),
            obscureText: true,
          ),
          ElevatedButton(onPressed: (){
              print(id);
            }, child: Text('로그인하기'))
        ],
      ),
    );
  }
}