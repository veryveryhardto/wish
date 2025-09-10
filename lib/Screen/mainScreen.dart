import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Screen/SignLayout/loginPage.dart';
import 'package:wish/Screen/Widget/appBar.dart';

import '../Provider/UIProvider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key,});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    UIProvider ui=Provider.of<UIProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(title: '메인',
        action: ui.isLogined?null:LoginButton(context)),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          height: double.infinity,
          width: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3 ? (MediaQuery.of(context).size.width)*0.9 : (MediaQuery.of(context).size.height)*1.5,
          child:Expanded(
            child: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<1?
              Column(
                children: [
                  Container(
                    height: (MediaQuery.of(context).size.height)*0.5,
                    child: FirstColumn(context),
                  ),
                  Container(
                    height: (MediaQuery.of(context).size.height)*0.5,
                    child: SecondColumn(context),
                  ),
                ],
              ):Row(
              children: [
                Flexible(
                  flex: 1,
                  child: FirstColumn(context),),
                SizedBox(width: 20,),
                Flexible(
                  flex: 1,
                  child: SecondColumn(context),)
              ],
            )
          ),
        ),
      ),
    );
  }
  Widget LoginButton(BuildContext context)=>Padding(
    padding: const EdgeInsets.only(right: 15),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(15),
        backgroundColor: Colors.white,
        minimumSize: Size.zero,
      ),
      onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
      child: Text('업체용 로그인',style: TextStyle(color: Color(0xff50C7E1),),
    ),),
  );

  Widget FirstColumn(BuildContext context)=>Container(
    child: Column(
      children: [
        Expanded(child:
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
        ),
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
              }, child: Text('회원가입')),
        ),
      ],
    ),
  );
  Widget SecondColumn(BuildContext context)=>Container(
    child: Column(
      children: [
        Expanded(child:
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        ),
        Container(
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 20),
                padding: EdgeInsets.all(20),
                elevation: 0,
                shadowColor: Color(0xffffff),
              ),
              onPressed: (){
              }, child: Text('회원가입')),
        ),
      ],
    ),
  );
}