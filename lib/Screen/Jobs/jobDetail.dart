
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wish/Provider/JobProvider.dart';
import 'package:wish/Screen/Jobs/jobDetail_customer.dart';
import 'package:wish/Screen/SignLayout/loginPage.dart';
import 'package:wish/Screen/Widget/appBar.dart';
import 'package:wish/Screen/Widget/customDropdown.dart';
import 'package:wish/Screen/Widget/customTextField.dart';

import '../../Model/Jobs/jobDetail.dart';


class JobDetail extends StatefulWidget {
  const JobDetail({super.key,});

  @override
  State<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {

  bool _isDetail = true;

  @override
  Widget build(BuildContext context) {
    JobProvider job=Provider.of<JobProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(title: '시공 정보',),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          height: (MediaQuery.of(context).size.height)*0.85,
          width: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3 ? (MediaQuery.of(context).size.width)*0.9 : (MediaQuery.of(context).size.width)*0.6,
          child: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<1?
              Column(
                children: [
                  Row(mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        color: Color(0xff50C7E1),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))
                        ),
                        child: Text('신청자명'),
                      ),
                      Icon(Icons.phone,color: Color(0xff50C7E1),),
                      Text('010-1111-1111')
                    ],
                  ),
                  Switch(value: _isDetail, onChanged: (value)=>setState(()=>_isDetail=value)),
                  _isDetail?FirstDetail(context, job.currentJob):SecondDetail(context, job.currentJob),
                ],
              ):Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: FirstDetail(context,job.currentJob),
                    ),),
                  SizedBox(width: 20,),
                  Flexible(
                    flex: 1,
                    child: Container(
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: SecondDetail(context,job.currentJob),
                  ),)
                ],
              )
          ),
      ),
    );
  }
  Widget FirstDetail(BuildContext context, Data job)=>Column(
    children: [
      CustomTextField(data: job.jobAddress!.address, title: '시공주소', readOnly: true,),
      CustomTextField(data: job.jobAddress!.addressDetail, title: '상세주소', readOnly: true,),
      //CustomTextField(data: job.jobArea, title: '타입(평수)', readOnly: true,),
      //CustomTextField(data: job., title: '작업범위', readOnly: true,),
      Row(children: [
        Flexible(child: CustomTextField(data: job.jobCategoryName, title: '카테고리', readOnly: true,)),
        Flexible(child: CustomDropdown(textController: job.jobStatusName, title: '신청상태', list: ['반려','신청','배정전','배정됨','작업중','작업완료'],readOnly: false,)),
      ],),
      Row(children: [
        Flexible(child: CustomTextField(data: job.managerName, title: '담당자명', )),
        Flexible(child: CustomTextField(data: job.jobScheduledAt, title: '예약일', )),
      ],),
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
    ],
  );
  Widget SecondDetail(BuildContext context,Data job)=>Column(
    children: [
      ToggleSwitch(
        initialLabelIndex: 0,
        totalSwitches: 3,
        labels: ['공통', '시공', '일정'],
        onToggle: (index) {
          print('switched to: $index');
        },
      ),
    ],
  );
}