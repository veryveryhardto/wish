import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Screen/SignLayout/loginPage.dart';
import 'package:wish/Screen/Widget/appBar.dart';
import 'package:wish/Screen/listLayout.dart';

import '../Provider/UserProvider.dart';
import '../Service.dart';

class MainScreen_Customer extends StatefulWidget {
  const MainScreen_Customer({super.key,});

  @override
  State<MainScreen_Customer> createState() => _MainScreen_CustomerState();
}

class _MainScreen_CustomerState extends State<MainScreen_Customer> {

  @override
  Widget build(BuildContext context) {
    UIProvider ui=Provider.of<UIProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(title: '메인',
          action: LoginButton(context),
          pop: false
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          height: double.infinity,
          width: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3 ? (MediaQuery.of(context).size.width)*0.9 : (MediaQuery.of(context).size.height)*1.5,
          child:Expanded(
              child: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<1?
              ListView(
                shrinkWrap: true,
                children: [
                  Container(
                      height: (MediaQuery.of(context).size.height)*0.43,
                      child: FirstColumn(context)
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: (MediaQuery.of(context).size.height)*0.43,
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
    padding: const EdgeInsets.all(10),
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

  Widget FirstColumn(BuildContext context)=>Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 10,bottom: 5),
        child: Text('공지사항',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
      ),
      Expanded(child:///가로형일시 expanded 세로형일시 container로 길이지정
      Container(
        margin: EdgeInsets.only(bottom: 10),
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
              Service().Fetch('', 'get','/api/auth/me');
            }, child: Text('회원가입')),
      ),
    ],
  );
  Widget SecondColumn(BuildContext context)=>Column(
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
        margin: EdgeInsets.only(bottom: 5),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(fontSize: 20),
              padding: EdgeInsets.all(20),
              elevation: 0,
              shadowColor: Color(0xffffff),
            ),
            onPressed: (){
            }, child: Text('시공 신청')),
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
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => ListLayout())),
            child: Text('신청 목록')),
      ),
    ],
  );
}