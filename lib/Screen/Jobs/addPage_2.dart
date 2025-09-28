import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Model/Token.dart';
import 'package:wish/Screen/Widget/appBar.dart';
import 'package:wish/Screen/Widget/customDropdown.dart';
import 'package:wish/Screen/Widget/customTextField.dart';
import 'package:wish/Screen/mainScreen(customer).dart';
import 'package:wish/Screen/oneContainer.dart';
import 'package:kpostal/kpostal.dart';

import '../../Model/message.dart';
import '../../Provider/JobProvider.dart';
import '../../Service.dart';
import '../Widget/Indicator.dart';
import '../Widget/customToast.dart';


class AddPage_2 extends StatefulWidget {
  const AddPage_2({super.key,});

  @override
  State<AddPage_2> createState() => _AddPage_2State();
}

class _AddPage_2State extends State<AddPage_2> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _address = TextEditingController();
  TextEditingController _addressDetail = TextEditingController();
  TextEditingController _category = TextEditingController();
  TextEditingController _requestNote = TextEditingController();

  @override
  Widget build(BuildContext context) {
    JobProvider job=Provider.of<JobProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: '시공 신청하기',),
      body: OneContainer(
          Container(/*
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('시공 정보',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                  SizedBox(height: 30,),
                  Text('시공 위치', style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xff50C7E1)),),
                  SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        Flexible(
                          flex: 7,
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
                            controller: _address,
                            validator: (val){
                              if(val!.length<0) return '주소를 입력해 주세요.';
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 10,),
                        Flexible(
                          flex:3,
                          fit:FlexFit.tight,
                          child: Container(
                            child: ElevatedButton(
                              onPressed: () async => await Navigator.push(context, MaterialPageRoute(
                                builder: (_) => KpostalView(
                                  callback: (Kpostal result) {
                                    setState(() {
                                      _address.text=result.address;
                                      job.addJob.address!.address=result.address;
                                      job.addJob.address!.post=int.parse(result.postCode);
                                    });
                                  },
                                ),),),
                              child: Text('주소 찾기',style: TextStyle(fontSize: 17,)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  CustomTextField(textController: _addressDetail, title: '상세주소',),
                  CustomDropdown(textController: _category, title: '카테고리', list: ['카테고리1','카테고리2'],),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('요청사항', style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xff50C7E1)),),),
                  SizedBox(height: 5,),
                  /*
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
                      controller: _requestNote,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ),

                   */
                  SizedBox(height: 30,),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(fontSize: 20),
                          padding: EdgeInsets.all(20),
                          elevation: 0,
                          shadowColor: Color(0xffffff),
                        ),
                        onPressed: () async {
                          if(_formKey.currentState!.validate()){
                            Indicator().show(context);
                            var json = await Service().Fetch(job.addJob.toJson(), 'post', '/api/public/jobs',Token().AccessRead());
                            try {
                              var data = Message.fromJson(json);
                              if(data.code=='success'){
                                CustomToast('시공 신청이 완료되었습니다.', context);
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen_Customer()), (route) => false);
                              }
                              else CustomToast('시공 신청이 완료되지 않았습니다.', context);
                              Indicator().dismiss();
                            } catch(e){
                              CustomToast('잘못된 접근입니다.', context);
                              Indicator().dismiss();
                              print(e);
                            }
                          }
                        },
                        child: Text('시공 신청하기')),
                  ),
                  SizedBox(height: 10,),
                  Container(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side:BorderSide(color: Color(0xff50C7E1)),
                            padding: EdgeInsets.symmetric(vertical: 20)
                        ),
                        onPressed: ()=>Navigator.of(context).pop(),
                        child: Text('뒤로가기',style: TextStyle(fontSize: 20,color: Color(0xff50C7E1))),
                      ))
                ],),
            ),*/
          )
      ),);
  }
}