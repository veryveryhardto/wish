import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Model/Jobs/jobDetail.dart';
import 'package:wish/Model/Note/NoteList.dart' as note;
import 'package:wish/Provider/JobProvider.dart';
import 'package:wish/Screen/Jobs/addPage_1.dart';
import 'package:wish/Screen/Jobs/jobDetail_customer.dart';
import 'package:wish/Screen/SignLayout/loginPage.dart';
import 'package:wish/Screen/Widget/NoteDialog.dart';
import 'package:wish/Screen/Widget/appBar.dart';
import 'dart:js' as js;

import 'package:wish/Screen/Jobs/listLayout.dart';

import '../Provider/UserProvider.dart';
import '../Service.dart';
import 'Widget/Indicator.dart';
import 'Widget/customToast.dart';

class MainScreen_Customer extends StatefulWidget {
  const MainScreen_Customer({super.key,});

  @override
  State<MainScreen_Customer> createState() => _MainScreen_CustomerState();
}

class _MainScreen_CustomerState extends State<MainScreen_Customer> {

  @override
  Widget build(BuildContext context) {
    UserProvider ui=Provider.of<UserProvider>(context);
    JobProvider job=Provider.of<JobProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(title: '메인',
          action: LoginButton(context),
          pop: false
      ),
      body:  Center(
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
                      child: FirstColumn(context)
                  ),
                  SizedBox(height: 20,),
                  Container(
                    child: SecondColumn(context,job),
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
                    child: SecondColumn(context,job),)
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
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 10,bottom: 5),
        child: Text('공지사항',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 10,
          padding: const EdgeInsets.all(15),
          itemBuilder: (context,index)=>InkWell(
            onTap: ()=>NoteDialog().show(context,created: true,note:note.Data(
              noticeBody: '내용', noticeTitle: '제목', createdBy: '사람', createdAt: '날짜')
            ),
            child: ListTile(
              title: Text('제목',),
              trailing: Text('날짜'),
            ),
          ),
        ),
      )
    ],
  );
  Widget SecondColumn(BuildContext context,JobProvider job)=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero, // 버튼 내부 패딩 제거
            backgroundColor: Colors.transparent, // 배경색 제거
            shadowColor: Colors.transparent, // 그림자 제거
          ),
          onPressed: ()=>js.context.callMethod('open', ['https://linktr.ee/wish.clean']),
          child: Image.asset('assets/image/ImageButton.png',),
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
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => AddPage_1())),
            child: Text('시공 신청')),
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
            onPressed: () async{
              Indicator().show(context);
              var json = await Service().Fetch('', 'get', '/api/public/jobs/4a79102e-f6c3-481a-9a33-8892c82e6f99?phone=010-3333-2244');
              try {
                var data = JobDetail.fromJson(json);
                if(data.code=='success'){
                  job.currentJobDetail=data;
                  Indicator().dismiss();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => JobDetail_Customer()));
                }
              } catch(e){
                CustomToast('잘못된 접근입니다.', context);
                Indicator().dismiss();
                print(e);
              }
            },
            child: Text('신청 목록')),
      ),
    ],
  );
}