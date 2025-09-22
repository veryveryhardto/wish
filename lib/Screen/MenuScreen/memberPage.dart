import 'package:flutter/material.dart';
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

      ),
    );
  }

}
