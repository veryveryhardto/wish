import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Screen/MenuScreen/memberPage.dart';
import 'package:wish/Screen/MenuScreen/validate.dart';
import 'package:wish/Screen/mainScreen(customer).dart';
import 'package:wish/Screen/oneContainer.dart';

import '../../Model/Token.dart';
import '../../Model/message.dart';
import '../../Provider/UserProvider.dart';
import '../../Service.dart';
import '../Widget/Indicator.dart';
import '../Widget/appBar.dart';
import '../Widget/customToast.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  static List<dynamic> menu = ['회원 정보 확인/수정','로그아웃','회원 탈퇴'];
  static List<dynamic> navigation = [MemberPage()];

  Token token = Token();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //textController.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: '마이페이지',),
      body: OneContainer(
        Column(
          children: [
            Container(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: menu.length,
                padding: const EdgeInsets.all(15),
                itemBuilder: (context,index)=>InkWell(
                  onTap: () async {
                    if (index == menu.length - 2) await Logout();
                    if (index == menu.length - 1) await Delete();
                    else if(index==0){
                      if(user.isValidtate) Navigator.push(context, MaterialPageRoute(builder: (context) => MemberPage()));
                      else Navigator.push(context, MaterialPageRoute(builder: (context) => ValidatePage()));
                    }

                    /*
                    else if(index == 0) {
                      if(page.val) Navigator.pushNamed(context, navigation[index][1]);
                      else Navigator.pushNamed(context, navigation[index][0]);
                    } else Navigator.pushNamed(context, navigation[index]);

                     */
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Text(menu[index],style:(TextStyle(color:index==menu.length-1?Colors.red:Colors.black))),
                  ),
                ),
                separatorBuilder: (context, index) => const Divider(thickness: 1), ),
            ),
          ],
        ),
      ),
    );
  }

  Logout() {
    return showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('로그아웃',style:TextStyle(color: Color(0xff50C7E1),)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('로그아웃하시겠습니까?'),
                  SizedBox(height: 30,),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15),),
                      child: Text("로그아웃",style: TextStyle(fontSize: 20),),
                      onPressed: () async{
                        Indicator().show(context);
                        Map<String,String> _logout = {
                          "refreshToken" : await token.RefreshRead(),
                        };
                        var json = await Service().Fetch(_logout, 'post', '/api/auth/logout',await token.AccessRead());
                        try {
                          var data = Message.fromJson(json);
                          if(data.code=='success'){
                            await Token().Delete();
                            Indicator().dismiss();
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen_Customer()), (route) => false);
                            CustomToast('로그아웃 되었습니다.', context);
                          }
                          else CustomToast('잘못된 접근입니다.', context);
                          Indicator().dismiss();
                        } catch(e){
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
                          side:BorderSide(color: const Color(0xff50C7E1),),
                          //textStyle: TextStyle(fontSize:double.parse(font.small))
                      ),
                      child: Text("취소",style: TextStyle(fontSize: 20,color: Color(0xff50C7E1),),),
                      onPressed: ()=>Navigator.pop(context),
                    ),
                  ),
                ],),
            );
          },
        );
      },
    );
  }
  Delete() {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('회원 탈퇴', style: TextStyle(color: Colors.red,)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('정말로 탈퇴하시겠습니까?'),
                  Text('이 작업은 되돌릴 수 없습니다.'),
                  SizedBox(height: 30,),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),),
                      child: Text("회원 탈퇴", style: TextStyle(fontSize: 20),),
                      onPressed: () async {
                        Indicator().show(context);
                        var json = await Service().Fetch(
                            '', 'delete', '/api/auth/me',
                            await token.AccessRead());
                        try {
                          var data = Message.fromJson(json);
                          if (data.code == 'success') {
                            await Token().Delete();
                            Indicator().dismiss();
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (
                                    context) => const MainScreen_Customer()), (
                                    route) => false);
                            CustomToast('탈퇴가 완료되었습니다.', context);
                          }
                          else
                            CustomToast('탈퇴하지 못했습니다.', context);
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
                      child: Text("취소", style: TextStyle(fontSize: 20,
                        color: Color(0xff50C7E1),),),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],),
            );
          },
        );
      },
    );
  }
}
