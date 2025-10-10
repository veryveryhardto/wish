
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wish/Model/Memo/memoList.dart' as memoList;
import 'package:wish/Model/Jobs/jobList.dart' as jobList;
import 'package:wish/Model/User/memberlist.dart' as memberList;
import 'package:wish/Provider/JobProvider.dart';
import 'package:wish/Provider/UserProvider.dart';
import 'package:wish/Screen/Jobs/memberList(assign).dart';
import 'package:wish/Screen/Widget/appBar.dart';
import 'package:wish/Screen/Widget/customDropdown.dart';
import 'package:wish/Screen/Widget/customTextField.dart';
import 'package:wish/Screen/Widget/customToast.dart';

import '../../Model/message.dart';
import '../../Model/token.dart';
import '../../Service.dart';
import '../Widget/Indicator.dart';


class JobDetail extends StatefulWidget {
  const JobDetail({super.key,});

  @override
  State<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {


  bool _init = false;

  TextEditingController _memo = TextEditingController();
  TextEditingController _status = TextEditingController();
  int _toggle = 0;
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)=>Notice());
  }

  Future<void> Notice() async{
    JobProvider job=Provider.of<JobProvider>(context,listen: false);
    _status.text=job.currentJob.jobStatusName;

    var json=await Service().Fetch('', 'get', '/api/jobs/${job.currentJob.jobUuid}/memos',await Token().AccessRead());
    if(json==false) return;
    else {
      try {
        var data2 = memoList.MemoList.fromJson(json);
        if(data2.code=='success'&&data2.data!=null&&data2.data!.length>0){
          job.setMemoList = data2;
        }
        else return;
      } catch(e){
        debugPrint(e.toString());
      }
    }
    setState(()=>_init=true);
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
    UserProvider user = Provider.of<UserProvider>(context);


    return Scaffold(
      appBar: CustomAppBar(title: '시공 정보',),
      body: !_init ? Center(child: CircularProgressIndicator(color: Color(0xff50C7E1),)): (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<1?
      ListView(
        padding: EdgeInsets.all(20),
        children: [
          DetailRow(job, user),
          Container(
            height: 650,
            padding: EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: FirstDetail(context,job,true,user),),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: SecondDetail(context,job,true,user),),
        ],
      ): Center(
        child: Container(
            padding: EdgeInsets.all(20),
            height: double.infinity,
            width: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3 ? (MediaQuery.of(context).size.width)*0.9 : (MediaQuery.of(context).size.width)*0.6,
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      DetailRow(job, user),
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                          ),
                          child: FirstDetail(context,job,false,user),
                        ),
                      ),
                    ],
                  ),),
                SizedBox(width: 20,),
                Flexible(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: SecondDetail(context,job,false,user),
                  ),)
              ],
            )
        ),
      ),
    );
  }
  Widget MemoTile(JobProvider job, UserProvider user)=>ListView.builder(
    shrinkWrap: true,
    itemCount: job.memoList.data==null?0:job.memoList.data!.length,
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
            title: Text('${job.memoList.data?[index].content}'),
            subtitle: Text('${job.memoList.data?[index].createdAt.toString().substring(0,19)}'),
            trailing: Text('${job.memoList.data?[index].writerName}',style: TextStyle(color: user.uuid==job.memoList.data?[index].writerUuid?Color(0xff50C7E1):Colors.black),),
            onTap: user.uuid==job.memoList.data?[index].writerUuid?() async {
              var _isTrue = await MemoModify(user, job, index);
              if(_isTrue=='delete') job.memoList.data?.removeAt(index);
              if(_isTrue=='modify'||_isTrue=='delete') setState(() {});
            }:null
        ),
      );
    },
  );
  Widget DetailRow(JobProvider job,UserProvider user)=>Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Color(0xff50C7E1),
          borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        ),
        child: Text(job.currentJob.customerName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
      ),
      SizedBox(width: 10,),
      Icon(Icons.phone),
      Text(job.currentJob.customerPhone),
    ],
  );
  Widget FirstDetail(BuildContext context, JobProvider job,bool isVertical,UserProvider user)=>Column(
    mainAxisSize: isVertical? MainAxisSize.min:MainAxisSize.max,
    mainAxisAlignment: isVertical? MainAxisAlignment.start:MainAxisAlignment.spaceAround,
    children: [
      CustomTextField(data: job.currentJob.jobAddress?.address, title: '시공주소', readOnly: true,),
      CustomTextField(data: job.currentJob.jobAddress?.addressDetail, title: '상세주소', readOnly: true,),
      //CustomTextField(data: job.jobArea, title: '타입(평수)', readOnly: true,),
      //CustomTextField(data: job., title: '작업범위', readOnly: true,),
      Row(children: [
        Flexible(child: CustomTextField(data: job.currentJob.jobCategoryName, title: '카테고리', readOnly: true,)),
        SizedBox(width: 10,),
        Flexible(child: CustomDropdown(textController: _status, title: '신청상태', list:jobList.jobStatusList,
          readOnly: user.role>1?false:true,
          onChanged: (val) async{
            if(val.toString()=='반려'){
              if(_status.text == val.toString()) return;
              else {
                var _reject = await Reject(context,job.currentJob.jobUuid);
                print(_reject);
                if(_reject) {
                  setState(() {
                   _status.text = val.toString();
                  });
               }}
            }
            else {
              Indicator().show(context);
              Map<String,String> _jobStatus = {
                "toStatus" : jobList.jobStatusList.indexOf(val.toString()).toString(),
              };
              var json = await Service().Fetch(_jobStatus, 'post', '/api/staff/jobs/${job.currentJob.jobUuid}/status',await Token().AccessRead());
              try {
                var data = Message.fromJson(json);
                if (data.code == 'success'){
                  Indicator().dismiss();
                  CustomToast('수정되었습니다.', context);
                }
              } catch (e) {
                debugPrint(e.toString());
                Indicator().dismiss();
                CustomToast('수정되지 않았습니다.', context);
              }

              setState(() {
                _status.text = val.toString();
              });
            }
          }

        ),),
      ],),
      CustomTextField(data: job.currentJob.managerName, title: '담당자명', readOnly: true,
        onTap: () async {
          var _member = await Navigator.push(context, MaterialPageRoute(builder: (context) => MemberList_Assign()));
          if(_member.runtimeType==memberList.Items){
            Indicator().show(context);
            Map<String,String> _assign = {
              "managerUuid" : _member.userUuid,
            };
            var json = await Service().Fetch(_assign, 'post', '/api/staff/jobs/${job.currentJob.jobUuid}/assign',await Token().AccessRead());
            try {
              var data = Message.fromJson(json);
              if (data.code == 'success'){
                Indicator().dismiss();
                CustomToast('담당되었습니다.', context);
              }
            } catch (e) {
              debugPrint(e.toString());
              Indicator().dismiss();
              CustomToast('담당되지 않았습니다.', context);
            }

            setState(() {});
          }
        },
      ),
      CustomTextField(data: job.currentJob.jobScheduledAt, title: '예약일', readOnly: true,
        onTap: () async {
          DateTime initialDay = DateTime.now();
          final DateTime? dateTime = await showDatePicker(
              context: context,
              initialDate: initialDay,
              firstDate: DateTime.now(),
              lastDate: DateTime(DateTime.now().year+1));
          if (dateTime != null) {
            setState(() {
              initialDay = dateTime;
              job.currentJob.jobScheduledAt = dateTime;
            });
          }
        },
      ),
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
  Widget SecondDetail(BuildContext context,JobProvider job,bool isVertical,UserProvider user) {
    return Column(
      mainAxisSize: isVertical ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment: isVertical
          ? MainAxisAlignment.start
          : MainAxisAlignment.spaceEvenly,
      children: [
        ToggleSwitch(
          initialLabelIndex: _toggle,
          totalSwitches: 3,
          inactiveBgColor:Color(0xfff5f5f5),
          labels: ['공통', '시공', '일정'],
          onToggle: (index) {
            debugPrint('switched to: $index');
          },
        ),
        isVertical?Container(height: MediaQuery.of(context).size.height*0.6,child: MemoTile(job, user),
        ):Expanded(child: MemoTile(job, user)),
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('메모 작성', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff50C7E1)),),),
                  SizedBox(height: 5,),
                  Container(
                    height: 50,
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
                      controller: _memo,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10,),
            Container(
              height: 70,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(5),
                  minimumSize: Size.zero,
                ),
                onPressed: () async {
                  Map<String,String> _addMemo = {
                    "content" : _memo.text,
                  };
                  var json = await Service().Fetch(_addMemo, 'post', '/api/jobs/${job.currentJob.jobUuid}/memos',
                      await Token().AccessRead());
                  if (json == false)
                    return;
                  else {
                    try {
                      var data = Message.fromJson(json);
                      if (data.code == 'success') {
                        var json2 = await Service().Fetch('', 'get',
                            '/api/jobs/${job.currentJob.jobUuid}/memos',
                            await Token().AccessRead());
                        var data2 = memoList.MemoList.fromJson(json2);
                        if (data.code == 'success' && data2.data != null &&
                            data2.data!.length > 0) {
                          job.setMemoList = data2;
                        }
                        _memo.text='';
                        setState(() {});
                      }
                      else
                        return;
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  }
                }, child: Text('작성'),),
            )
          ],
        ),
      ],
    );
  }

  MemoModify(UserProvider user,JobProvider job,int index) {
    String _mod = 'nope';
    TextEditingController _content = TextEditingController()..text=job.memoList.data?[index].content??'';
    return showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('메모 수정',style:TextStyle(color: Color(0xff50C7E1),)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('내용', style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xff50C7E1)),),),
                  SizedBox(height: 5,),
                  Container(
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.top,
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
                      validator: (val){
                        if (val!.length==0) return '내용을 비워둘 수 없습니다';
                        else return null;
                      },
                      controller: _content,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15),),
                      child: Text("메모 수정",style: TextStyle(fontSize: 20),),
                      onPressed: () async {
                        Map<String,String> _modMemo = {
                          "content" : _content.text,
                        };
                        var json = await Service().Fetch(_modMemo, 'patch', '/api/jobs/${job.memoList.data?[index].memoUuid}/memos',
                            await Token().AccessRead());
                        if (json == false)
                          return;
                        else {
                          try {
                            var data = Message.fromJson(json);
                            if (data.code == 'success') {
                              job.memoList.data?[index].content=_content.text;
                              job.memoList.data?[index].createdAt=DateTime.now();
                              _mod = 'modify';
                              Navigator.pop(context,_mod);
                            }
                            else
                              return;
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15),backgroundColor: Colors.red),
                      child: Text("메모 삭제",style: TextStyle(fontSize: 20),),
                      onPressed: () async {
                        var _delete = await Delete(context, job.memoList.data?[index].memoUuid??'');
                        if(_delete=='delete') {
                          _mod = _delete;
                          Navigator.pop(context,_mod);
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        side:BorderSide(color: const Color(0xff50C7E1),),
                        //textStyle: TextStyle(fontSize:double.parse(font.small))
                      ),
                      child: Text("취소",style: TextStyle(fontSize: 20,color: Color(0xff50C7E1),),),
                      onPressed: ()=>Navigator.pop(context,_mod),
                    ),
                  ),
                ],),
            );
          },
        );
      },
    ).then((value)=>_mod);
  }

Delete(BuildContext context,String memoID) async{
  String success = "not delete";

  return showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
          title: Text('메모 삭제', style: TextStyle(color: Color(0xff50C7E1),)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('정말로 삭제하시겠습니까?'),
              SizedBox(height: 30,),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),),
                  child: Text("삭제", style: TextStyle(fontSize: 20),),
                  onPressed: () async {
                    Indicator().show(context);
                    var json = await Service().Fetch('', 'delete', '/api/jobs/$memoID/memos',
                        await Token().AccessRead());
                    try {
                      var data = Message.fromJson(json);
                      if (data.code == 'success') {
                        Indicator().dismiss();
                        success="delete";
                        Navigator.pop(context,success);
                      }
                      else
                        CustomToast('삭제하지 못했습니다.', context);
                      Indicator().dismiss();
                    } catch (e) {
                      CustomToast('잘못된 접근입니다.', context);
                      Indicator().dismiss();
                      debugPrint(e.toString());
                    }
                  },
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    side: BorderSide(color: const Color(0xff50C7E1),),
                    //textStyle: TextStyle(fontSize:double.parse(font.small))
                  ),
                  child: Text("취소", style: TextStyle(
                    fontSize: 20, color: Color(0xff50C7E1),),),
                  onPressed: () => Navigator.pop(context,success),
                ),
              ),
            ],),
        ),
  ).then((value)=>success);
}
  Reject(BuildContext context,String jobUUID) async{
    bool success = false;
    TextEditingController _reason = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('작업 반려', style: TextStyle(color: Color(0xff50C7E1),)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('반려사유', style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xff50C7E1)),),),
                SizedBox(height: 5,),
                Container(
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.top,
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
                    controller: _reason,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15),),
                    child: Text("확인",style: TextStyle(fontSize: 20),),
                    onPressed: () async {
                      Indicator().show(context);
                      Map<String,String> _reject = {
                        "content" : _reason.text,
                      };
                      var json = await Service().Fetch(_reject, 'post', '/api/staff/jobs/$jobUUID/reject',
                          await Token().AccessRead());
                      if (json == false)
                        return;
                      else {
                        try {
                          var data = Message.fromJson(json);
                          if (data.code == 'success') {
                            success = true;
                            Navigator.pop(context,success);
                            Indicator().dismiss();
                            CustomToast('작업이 반려되었습니다.', context);
                          }
                          else {
                            Indicator().dismiss();
                            CustomToast('작업이 반려되지 않았습니다.', context);
                          }
                        } catch (e) {
                          debugPrint(e.toString());
                          Indicator().dismiss();
                          CustomToast('잘못된 접근입니다.', context);
                        }
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      side: BorderSide(color: const Color(0xff50C7E1),),
                      //textStyle: TextStyle(fontSize:double.parse(font.small))
                    ),
                    child: Text("취소", style: TextStyle(
                      fontSize: 20, color: Color(0xff50C7E1),),),
                    onPressed: () => Navigator.pop(context,success),
                  ),
                ),
              ],),
          ),
    ).then((value)=>success);
  }
}