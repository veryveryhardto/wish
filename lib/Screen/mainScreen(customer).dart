import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Provider/JobProvider.dart';
import 'package:wish/Provider/NoteProvider.dart';
import 'package:wish/Screen/Jobs/addPage_1.dart';
import 'package:wish/Screen/SignLayout/loginPage.dart';
import 'package:wish/Screen/Widget/appBar.dart';
import 'dart:js' as js;

import 'package:wish/Screen/Jobs/JobList_Customer.dart';

import '../Model/Note/NoteList.dart';
import '../Provider/UserProvider.dart';
import '../Service.dart';

class MainScreen_Customer extends StatefulWidget {
  const MainScreen_Customer({super.key,});

  @override
  State<MainScreen_Customer> createState() => _MainScreen_CustomerState();
}

class _MainScreen_CustomerState extends State<MainScreen_Customer> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)=>Notice());
  }

  Future<void> Notice() async{
    NoteProvider note=Provider.of<NoteProvider>(context,listen: false);

    var json=await Service().Fetch('', 'get', '/api/notices',);
    if(json==false) return;
    else {
      try {
        var data = NoteList.fromJson(json);
        if(data.code=='success'&&data.data!=null&&data.data!.length>0){
          note.setNoteList=data;
          note.setNoteData(data,context);
        }
        else return;
      } catch(e){
        print(e);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    UserProvider ui=Provider.of<UserProvider>(context);
    JobProvider job=Provider.of<JobProvider>(context);
    NoteProvider note=Provider.of<NoteProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(title: '메인',
          action: LoginButton(context),
          pop: false
      ),
      body:  Center(
        child: Container(
          padding: EdgeInsets.all(20),
          height: double.infinity,
          width: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3 ? (MediaQuery.of(context).size.width)*0.9 :(MediaQuery.of(context).size.width)*0.6,
          child: Expanded(
              child: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<1?
          ListView(
            shrinkWrap: true,
            children: [
              Container(
                  child: FirstColumn(context,note)
              ),
              SizedBox(height: 10,),
              Container(
                child: SecondColumn(context,job),
              ),
              ImageButton(context)
            ],
          ):Row(
            children: [
              Flexible(
                flex: 1,
                child: FirstColumn(context,note),),
              SizedBox(width: 20,),
              Flexible(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageButton(context),
                    SecondColumn(context,job),
                  ],
                ),)
            ],
          ),
        )
        ),
      ),
    );
  }
  Widget ImageButton(BuildContext context)=>Container(
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
  );
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

  Widget FirstColumn(BuildContext context,NoteProvider note)=>Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 10,bottom: 5),
        child: Text('공지사항',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          //  color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: note.noteList.code=='success'&&note.noteList.data!=null&&note.noteList.data!.length>0?
        PaginatedDataTable(
          source: note.noteData!,
          columns: const [
            DataColumn(label: Text('')),
            DataColumn(label: Text(''),numeric: true)
          ],
          headingRowHeight : 20,
          rowsPerPage: 10,
          dataRowMinHeight: 30,
          dataRowMaxHeight: 30,
          dividerThickness: 0.0001,
          showCheckboxColumn: false,
        ):Center(child: Padding(
          padding: EdgeInsets.all(20),
            child: Text('공지가 없습니다.')))
      )
    ],
  );
  Widget SecondColumn(BuildContext context,JobProvider job)=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
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
              /*
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

               */
              Navigator.push(context, MaterialPageRoute(builder: (context) => JobList_Customer()));
            },
            child: Text('신청 목록')),
      ),
    ],
  );
}