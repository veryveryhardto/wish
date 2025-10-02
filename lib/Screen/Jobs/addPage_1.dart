import 'package:flutter/material.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';
import 'package:regexed_validator/regexed_validator.dart';

import 'package:provider/provider.dart';
import 'package:wish/Screen/Widget/appBar.dart';
import 'package:wish/Screen/Widget/customTextField.dart';
import 'package:wish/Screen/oneContainer.dart';

import '../../Provider/JobProvider.dart';

import 'addPage_2.dart';


class AddPage_1 extends StatefulWidget {
  const AddPage_1({super.key,});

  @override
  State<AddPage_1> createState() => _AddPage_1State();
}

class _AddPage_1State extends State<AddPage_1> {

  TextEditingController _applicantName = TextEditingController();
  TextEditingController _phone = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    JobProvider job=Provider.of<JobProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: '시공 신청하기',),
      body: OneContainer(
          Form(
            key: _formKey,
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('시공 신청자 정보',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              SizedBox(height: 30,),
              CustomTextField(
                textController: _applicantName,
                title: '신청자명',
                validator: (val){
                  if(val!.length < 0) return '신청자명을 작성해주세요';
                  else return null;
                },
              ),
              CustomTextField(
                textController: _phone,
                title: '휴대폰 번호',
                validator: (val){
                  if(val!.length < 0) return '전화번호를 작성해 주세요';
                  else if (validator.phone(val!)) return '전화번호를 정확히 작성해 주세요';
                  else return null;
                },
                textInputFormatter: [MultiMaskedTextInputFormatter(masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxxx'], separator: '-')],
                textInputType: TextInputType.phone,
              ),
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
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        job.addJob.applicantName=_applicantName.text;
                        job.addJob.phone=_phone.text;
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddPage_2()));
                      }
                    },
                    child: Text('다음으로 넘어가기')),
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
          )
      ),);
  }
}