import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Screen/SignLayout/loginPage.dart';
import 'package:wish/Screen/Widget/appBar.dart';
import 'package:wish/Screen/Widget/customTextField.dart';
import 'package:wish/Screen/listLayout.dart';
import 'package:wish/Screen/oneContainer.dart';


class AddPage_1 extends StatefulWidget {
  const AddPage_1({super.key,});

  @override
  State<AddPage_1> createState() => _AddPage_1State();
}

class _AddPage_1State extends State<AddPage_1> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '시공 신청하기',),
      body: OneContainer(
          Form(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('시공 신청자 정보',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              SizedBox(height: 30,),
              CustomTextField(textController: textController, title: '회원 성명'),
              CustomTextField(textController: textController, title: '회원 번호'),
              CustomTextField(textController: textController, title: '휴대폰 번호'),
              SizedBox(height: 30,),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 20),
                      padding: EdgeInsets.all(20),
                      elevation: 0,
                      shadowColor: Color(0xffffff),
                    ),
                    onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => ListLayout())),
                    child: Text('다음으로 넘어가기')),
              ),
              SizedBox(height: 10,),
              Container(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side:BorderSide(color: Color(0xff50C7E1)),
                        padding: EdgeInsets.symmetric(vertical: 20)
                    ),
                    onPressed: ()=>Navigator.of(context).pop(),
                    child: Text('뒤로가기',style: TextStyle(fontSize: 20,color: Color(0xff50C7E1))),
                  ))
            ],),
          )
      ),);
  }
}