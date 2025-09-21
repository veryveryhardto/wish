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
                      else if(index == 0) {
                        if(page.val) Navigator.pushNamed(context, navigation[index][1]);
                        else Navigator.pushNamed(context, navigation[index][0]);
                      } else Navigator.pushNamed(context, navigation[index]);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(menu[index],style: TextStyle(fontSize: double.parse(font.small),),),
                    ),
                  ),
                  separatorBuilder: (context, index) => const Divider(thickness: 1), ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('현재 버전: farmsway_240118',style:TextStyle(fontSize: double.parse(font.ss),color: Colors.black54)),
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
              title: Text('로그아웃',style:TextStyle(fontSize: double.parse(font.medium))),
              content: Text('로그아웃하시겠습니까?',style:TextStyle(fontSize: double.parse(font.small))),
              actions: <Widget>[
                ElevatedButton(
                  child:Text("로그아웃",style:TextStyle(fontSize: double.parse(font.medium))),
                  onPressed: () async{
                    Indicator().show(context);
                    var accessToken=await MenuPage._token.Read('!!bioline_secure_Access!!');
                    var refreshToken=await MenuPage._token.Read('!!bioline_secure_Refresh!!');
                    var msg = Message.fromJson(await API('''{
                      "accessToken": "$accessToken",
                      "refreshToken": "$refreshToken"
                    }''', 'post', '/user/log-out', '',null,mainDevice));
                    if(msg.code==1) {
                      await MenuPage._token.Delete({
                        'accessTokenKey':'!!bioline_secure_Access!!',
                        'refreshTokenKey':'!!bioline_secure_Refresh!!',
                        'IDKey':'!!bioline_secure_ID!!',
                        'passwodrKey':'!!bioline_secure_Password!!'
                      });
                      Indicator().dismiss();
                      await Workmanager().cancelAll();
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                        fontSize: double.parse(font.small),
                        msg: '로그아웃 되었습니다.',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                      );
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
                    }
                    else if(msg.code!<1){
                      Indicator().dismiss();
                      await Workmanager().cancelAll();
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                        fontSize: double.parse(font.small),
                        msg: '로그아웃 되었습니다.',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                      );
                      //timer?.cancel();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
                    }
                  },
                ),
                ElevatedButton(
                  child:Text("취소",style:TextStyle(fontSize: double.parse(font.medium))),
                  onPressed: ()=> Navigator.pop(context),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
