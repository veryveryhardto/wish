import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NoteDialog {
  late BuildContext _context;

  show(BuildContext context, {bool modified = false}) {

    return showDialog<void>( context: context, barrierDismissible: false,
        builder: (BuildContext context) {
          _context = context;
          return AlertDialog(
            constraints: BoxConstraints(maxHeight: (MediaQuery.of(context).size.height)*0.9),
            insetPadding: EdgeInsets.all(10),
            content: StatefulBuilder(builder: (context,setState)=>Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    ),
                    child: Text("취소",),
                    onPressed: ()=>Navigator.pop(context),
                  ),
                ),
              ],
            )),
          );
        }
    );
  }

}