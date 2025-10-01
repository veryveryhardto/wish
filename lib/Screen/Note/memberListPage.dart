import 'package:flutter/material.dart';

import '../Widget/appBar.dart';
import '../Widget/customTextField.dart';
import 'noteListPage.dart';

class MemberListPage extends StatefulWidget {
  const MemberListPage({super.key,});

  @override
  State<MemberListPage> createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {

  TextEditingController _text1 = TextEditingController();
  TextEditingController _text2 = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '회원 관리',),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(30),
          height: double.infinity,
          width: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3? (MediaQuery.of(context).size.width)*0.9 : (MediaQuery.of(context).size.width)*0.6,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                        )
                    ),
                    onPressed: ()=>Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => NoteListPage(),),),
                    child: Text('게시물 관리',style: TextStyle(fontSize: 20),),),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        disabledBackgroundColor: Color(0xff50C7E1),
                        disabledForegroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                        )
                    ),
                    onPressed: null,
                    child: Text('회원 관리',style: TextStyle(fontSize: 20),),),
                ],
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 7,
                          fit:FlexFit.loose,
                          child: Column(
                            children: [
                              CustomTextField(textController: _text1, title: '등급'),
                              CustomTextField(textController: _text1, title: '성명'),
                            ],
                          ),
                        ),
                        SizedBox(width: 10,),
                        Flexible(
                          flex: 3,
                          fit:FlexFit.loose,
                          child: Container(
                            width: double.infinity,
                            height: 161,
                            child: ElevatedButton(
                              onPressed: (){},
                              child: Text('검색'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 13,),
                    Divider(),
                    Row(
                      children: [

                      ],
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
