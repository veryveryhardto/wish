
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wish/Model/Memo/memoList.dart' as memoList;
import 'package:wish/Provider/JobProvider.dart';
import 'package:wish/Screen/Jobs/jobDetail_customer.dart';
import 'package:wish/Screen/SignLayout/loginPage.dart';
import 'package:wish/Screen/Widget/appBar.dart';
import 'package:wish/Screen/Widget/customDropdown.dart';
import 'package:wish/Screen/Widget/customTextField.dart';

import '../../Model/Jobs/jobDetail.dart';
import '../../Model/message.dart';
import '../../Model/token.dart';
import '../../Service.dart';


class JobDetail extends StatefulWidget {
  const JobDetail({super.key,});

  @override
  State<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {


  TextEditingController _memo = TextEditingController();
  bool _isDetail = true;
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)=>Notice());
  }

  Future<void> Notice() async{
    JobProvider job=Provider.of<JobProvider>(context,listen: false);

    var json=await Service().Fetch('', 'get', '/api/jobs/${job.currentJob.jobUuid}/memos',);
    if(json==false) return;
    else {
      try {
        var data = memoList.MemoList.fromJson(json);
        if(data.code=='success'&&data.data!=null&&data.data!.length>0){
          job.memoList = data;
        }
        else return;
      } catch(e){
        print(e);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _memo.dispose();
    super.dispose();
  }

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
                        child: Text(job.currentJob.data.customerName),
                      ),
                      Icon(Icons.phone,color: Color(0xff50C7E1),),
                      Text(job.currentJob.data.customerPhone)
                    ],
                  ),
                  Switch(value: _isDetail, onChanged: (value)=>setState(()=>_isDetail=value)),
                  _isDetail?FirstDetail(context, job):SecondDetail(context, job),
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
                      child: FirstDetail(context,job),
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
                    child: SecondDetail(context,job),
                  ),)
                ],
              )
          ),
      ),
    );
  }
  Widget FirstDetail(BuildContext context, JobProvider job)=>Column(
    children: [
      CustomTextField(data: job.currentJob.jobAddress!.address, title: '시공주소', readOnly: true,),
      CustomTextField(data: job.currentJob.jobAddress!.addressDetail, title: '상세주소', readOnly: true,),
      //CustomTextField(data: job.jobArea, title: '타입(평수)', readOnly: true,),
      //CustomTextField(data: job., title: '작업범위', readOnly: true,),
      Row(children: [
        Flexible(child: CustomTextField(data: job.currentJob.jobCategoryName, title: '카테고리', readOnly: true,)),
        Flexible(child: CustomDropdown(textController: job.currentJob.jobStatusName, title: '신청상태', list: ['반려','신청','배정전','배정됨','작업중','작업완료'],readOnly: false,)),
      ],),
      Row(children: [
        Flexible(child: CustomTextField(data: job.currentJob.managerName, title: '담당자명', )),
        Flexible(child: CustomTextField(data: job.currentJob.jobScheduledAt, title: '예약일', )),
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
          initialValue: job.currentJob.jobRequestDesc,
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
      ),
    ],
  );
  Widget SecondDetail(BuildContext context,JobProvider job)=>Column(
    children: [
      ToggleSwitch(
        initialLabelIndex: 0,
        totalSwitches: 3,
        labels: ['공통', '시공', '일정'],
        onToggle: (index) {
          print('switched to: $index');
        },
      ),
      Flexible(
        child: Container(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: job.memoList.data!.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Color(0xff50C7E1),
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  title: Text('${job.memoList.data![index].content}'),
                  subtitle: Text('${job.memoList.data![index].createdAt}'),
                  trailing: Text('${job.memoList.data![index].writerName}'),
                ),
              );
            },
          ),
        ),
      ),
      Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('메모 작성', style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xff50C7E1)),),),
              SizedBox(height: 5,),
              TextFormField(
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
                initialValue: job.currentJob.jobRequestDesc,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              SizedBox(height: 5,)
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(5),
              minimumSize: Size.zero,
            ),
            onPressed: ()async {
              var json=await Service().Fetch('''{
                  "content" : ${_memo.text}
              }''', 'post', '/api/jobs/${job.currentJob.jobUuid}/memos',await Token().AccessRead());
              if(json==false) return;
              else {
                try {
                  var data = Message.fromJson(json);
                  if(data.code=='success'){
                    var json2=await Service().Fetch('', 'get', '/api/jobs/${job.currentJob.jobUuid}/memos',await Token().AccessRead());
                    var data2 = memoList.MemoList.fromJson(json2);
                    if(data.code=='success'&&data2.data!=null&&data2.data!.length>0){
                      job.memoList = data2;
                    }
                  }
                  else return;
                } catch(e){
                  print(e);
                }
              }
          }, child: Text('작성'),)
        ],
      ),

    ],
  );
}