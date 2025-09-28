
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Model/Jobs/jobDetail.dart';
import 'package:wish/Screen/SignLayout/loginPage.dart';
import 'package:wish/Screen/Widget/appBar.dart';
import 'package:wish/Screen/Widget/customTextField.dart';
import 'package:wish/Screen/Jobs/listLayout.dart';

import '../../Provider/JobProvider.dart';


class JobDetail_Customer extends StatefulWidget {
  const JobDetail_Customer({super.key,});

  @override
  State<JobDetail_Customer> createState() => _JobDetail_CustomerState();
}

class _JobDetail_CustomerState extends State<JobDetail_Customer> {

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    JobProvider job=Provider.of<JobProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: '시공 정보',action: LoginButton(context),),
      body: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<1?
      ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: FirstDetail(context,true,job.currentJob),),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: SecondDetail(context,true,job.currentJob),),
        ],
      ): Center(
        child: Container(
          padding: EdgeInsets.all(20),
          height: double.infinity,
          width: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3 ? (MediaQuery.of(context).size.width)*0.9 : (MediaQuery.of(context).size.height)*1.5,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  height: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: FirstDetail(context,false,job.currentJob),
                ),),
              SizedBox(width: 20,),
              Flexible(
                flex: 1,
                child: Container(
                  height: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: SecondDetail(context,false,job.currentJob),
                ),)
            ],
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

  Widget FirstDetail(BuildContext context,bool isVertical, Data job)=>Column(
    mainAxisSize: isVertical? MainAxisSize.min:MainAxisSize.max,
    mainAxisAlignment: isVertical? MainAxisAlignment.start:MainAxisAlignment.spaceAround,
    children: [
      CustomTextField(data: job.customerName, title: '신청자명', readOnly: true,),
      CustomTextField(data: job.customerPhone, title: '휴대폰번호', readOnly: true,),
      CustomTextField(data: job.jobAddress!.address, title: '시공주소', readOnly: true,),
      CustomTextField(data: job.jobAddress!.addressDetail, title: '상세주소', readOnly: true,),
      //CustomTextField(data: job.jobArea, title: '타입(평수)', readOnly: true,),
      //CustomTextField(data: job., title: '작업범위', readOnly: true,),
      CustomTextField(data: job.jobCategoryName, title: '카테고리', readOnly: true,),
    ],
  );
  Widget SecondDetail(BuildContext context,bool isVertical, Data job)=>Column(
    mainAxisSize: isVertical? MainAxisSize.min:MainAxisSize.max,
    mainAxisAlignment: isVertical? MainAxisAlignment.start:MainAxisAlignment.spaceEvenly,
    children: [
      Flexible(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomTextField(data: job.managerName, title: '담당자명', readOnly: true,),
              CustomTextField(data: job.jobScheduledAt, title: '예약일', readOnly: true,),
              CustomTextField(data: job.jobStatus.toString(), title: '진행상태', readOnly: true,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('요청사항', style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xff50C7E1)),),),
              SizedBox(height: 5,),
              Flexible(
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.top,
                  expands: true,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Color(0xfff5f5f5),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xff50C7E1),
                        )
                    ),
                  ),
                  initialValue: job.jobRequestDesc,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
              SizedBox(height: 5,)
            ],
          )),
      Container(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side:BorderSide(color: Color(0xff50C7E1)),
                padding: EdgeInsets.symmetric(vertical: 20)
            ),
            onPressed: ()=>Navigator.of(context).pop(),
            child: Text('닫기',style: TextStyle(fontSize: 20,color: Color(0xff50C7E1))),
          ))
    ],
  );
}