import 'package:flutter/material.dart';
import 'package:wish/Screen/Note/memberListPage.dart';

import '../Widget/appBar.dart';
import '../Widget/customTextField.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key,});

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {

  TextEditingController _text1 = TextEditingController();
  TextEditingController _text2 = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '게시물 관리',),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(30),
          height: double.infinity,
          width: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3? (MediaQuery.of(context).size.width)*0.9 : (MediaQuery.of(context).size.height)*1.5,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                    child: Text('게시물 관리',style: TextStyle(fontSize: 20),),),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                        )
                    ),
                    onPressed: ()=>Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => MemberListPage(),),),
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
                              CustomTextField(textController: _text1, title: _text1.text),
                              CustomTextField(textController: _text1, title: _text1.text),
                            ],
                          ),
                        ),
                        SizedBox(width: 10,),
                        Flexible(
                          flex: 2,
                          fit:FlexFit.loose,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            child: ElevatedButton(
                              onPressed: (){},
                              child: Text('검색'),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          fit:FlexFit.loose,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            child: ElevatedButton(
                              onPressed: (){},
                              child: Text('글 작성'),
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
