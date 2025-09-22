import 'package:flutter/material.dart';
import 'package:wish/Screen/oneContainer.dart';

import '../../Model/Token.dart';
import '../Widget/appBar.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  static List<String> menu = ['회원 정보 확인/수정','로그아웃'];
  static List<dynamic> navigation = [["/validation","/userDetail"],"/fontSizeSetting","/logout"];

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
      appBar: CustomAppBar(title: '마이페이지',),
      body: OneContainer(
        Column(
          children: [
            Container(
              child: Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: menu.length,
                  padding: const EdgeInsets.all(15),
                  itemBuilder: (context,index)=>InkWell(
                    onTap: () async {
                      if (index == menu.length - 1) await Logout();
                      /*
                      else if(index == 0) {
                        if(page.val) Navigator.pushNamed(context, navigation[index][1]);
                        else Navigator.pushNamed(context, navigation[index][0]);
                      } else Navigator.pushNamed(context, navigation[index]);

                       */
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(menu[index]),
                    ),
                  ),
                  separatorBuilder: (context, index) => const Divider(thickness: 1), ),
              ),
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
              title: Text('로그아웃',style:TextStyle(color: Colors.green)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('로그아웃하시겠습니까?'),
                  SizedBox(height: 30,),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15),),
                      child: Text("로그아웃"),
                      onPressed: () async{
                        /*
                        Indicator().show(context);
                        ///로그아웃 시 토큰 및 ID/Password 삭제
                        var msg = Message.fromJson(await API('', 'post', '/user/log-out', await MenuPage._token.Read('!!bioline_secure_Access!!'),context,mainDevice,code:await MenuPage._token.Read('!!bioline_secure_Refresh!!')));
                        Indicator().dismiss();
                        if(msg.code==1) {
                          await MenuPage._token.Delete({
                            'accessTokenKey':'!!bioline_secure_Access!!',
                            'refreshTokenKey':'!!bioline_secure_Refresh!!',
                            'IDKey':'!!bioline_secure_ID!!',
                            'passwordKey':'!!bioline_secure_Password!!'
                          });
                          await Workmanager().cancelAll();
                          Navigator.pop(context);
                          CustomToast('로그아웃 되었습니다.', context);
                        }
                        ///코드 안되면 어떡하지...................
                        else if(msg.code!<1||msg.error!=null){
                          await Workmanager().cancelAll();
                          Navigator.pop(context);
                          CustomToast('로그아웃 되었습니다.', context);
                          //timer?.cancel();
                        }


                         */
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          side:BorderSide(color: const Color(0xff20AE4D),),
                          //textStyle: TextStyle(fontSize:double.parse(font.small))
                      ),
                      child: Text("취소"),
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
}
