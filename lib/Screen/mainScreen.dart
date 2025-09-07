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
          margin: EdgeInsets.all(30),
          padding: EdgeInsets.all(20),
          height: double.infinity,
          width: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3 ? (MediaQuery.of(context).size.width)*0.9 : (MediaQuery.of(context).size.height)*1.5,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child:Expanded(
            child: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<1?
              Column(

              ):Row(

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

    ),
  );
  Widget SecondColumn(BuildContext context)=>Container(
    child: Column(

    ),
  );
}