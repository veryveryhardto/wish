
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Screen/SignLayout/loginPage.dart';
import 'package:wish/Screen/Widget/appBar.dart';
import 'package:wish/Screen/Widget/customTextField.dart';
import 'package:wish/Screen/listLayout.dart';


class JobDetail extends StatefulWidget {
  const JobDetail({super.key,});

  @override
  State<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {

  @override
  Widget build(BuildContext context) {
    UIProvider ui=Provider.of<UIProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(title: '시공 정보',),
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: FirstDetail(context,true),),
                  SizedBox(height: 20,),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: SecondDetail(context,true),),
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
                      child: FirstDetail(context,false),
                    ),),
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

  Widget FirstDetail(BuildContext context,bool isVertical)=>Column(
    mainAxisSize: isVertical? MainAxisSize.min:MainAxisSize.max,
    mainAxisAlignment: isVertical? MainAxisAlignment.start:MainAxisAlignment.spaceAround,
    children: [
      CustomTextField(textController: textController, title: '신청자명', readOnly: true,),
      CustomTextField(textController: textController, title: '휴대폰번호', readOnly: true,),
      CustomTextField(textController: textController, title: '시공주소', readOnly: true,),
      CustomTextField(textController: textController, title: '타입(평수)', readOnly: true,),
      CustomTextField(textController: textController, title: '작업범위', readOnly: true,),
      CustomTextField(textController: textController, title: '카테고리', readOnly: true,),
    ],
  );
  Widget SecondDetail(BuildContext context,bool isVertical)=>Column(
    mainAxisSize: isVertical? MainAxisSize.min:MainAxisSize.max,
    mainAxisAlignment: isVertical? MainAxisAlignment.start:MainAxisAlignment.spaceEvenly,
    children: [
      Flexible(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomTextField(textController: textController, title: '담당자명', readOnly: true,),
              CustomTextField(textController: textController, title: '예약일', readOnly: true,),
              CustomTextField(textController: textController, title: '진행상태', readOnly: true,),
              Flexible(
                child: TextFormField(
                  decoration: InputDecoration(
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
                  initialValue: '',
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
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