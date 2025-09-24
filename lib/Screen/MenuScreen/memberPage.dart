import 'package:flutter/material.dart';
import 'package:wish/Screen/Widget/customTextField.dart';
import 'package:wish/Screen/oneContainer.dart';

import '../../Model/Token.dart';
import '../Widget/appBar.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {

  Token token = Token();
  bool _readOnly = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //textController.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: '유저 정보',),
      body: OneContainer(
        Column(
          children: [
            _readOnly?CustomTextField(textController: textController, title: '유저ID', readOnly: _readOnly,):Container(),
            _readOnly?Container():CustomTextField(textController: textController, title: '새 비밀번호', readOnly: _readOnly,),
            _readOnly?Container():CustomTextField(textController: textController, title: '비밀번호 확인', readOnly: _readOnly,),
            CustomTextField(textController: textController, title: '이름', readOnly: _readOnly,),
            CustomTextField(textController: textController, title: '전화번호', readOnly: _readOnly,),
            CustomTextField(textController: textController, title: '소속', readOnly: _readOnly,),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 20),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    elevation: 0,
                    shadowColor: Color(0xffffff),
                  ),
                  onPressed: _readOnly?(){}:()=>setState(()=>_readOnly=true),
                child: Text('수정하기')),
            ),
            SizedBox(height: 5,),
            _readOnly?Container(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side:BorderSide(color: Color(0xff50C7E1)),
                      padding: EdgeInsets.symmetric(vertical: 20)
                  ),
                  onPressed: ()=>setState(()=>_readOnly=false),
                  child: Text('취소',style: TextStyle(fontSize: 20,color: Color(0xff50C7E1))),
                )):Container()
          ],
        ),
      ),
    );
  }

}
