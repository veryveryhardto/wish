import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Provider/UIProvider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  String title;
  Widget? leading;
  Widget? action;

  CustomAppBar({super.key, required this.title, this.leading, this.action});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: //leading,
      IconButton(
        onPressed: ()=>Navigator.pop(context),
        icon: Icon(Icons.chevron_left,color: Colors.white, size: kToolbarHeight,),
        padding: EdgeInsets.zero,
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(image: ResizeImage(AssetImage('assets/image/logo-banner.png',),height:kToolbarHeight.toInt(),policy:ResizeImagePolicy.fit),),
          SizedBox(width: 5,),
          Text(title,style: TextStyle(color: Colors.white),),
        ],
      ),
      actions: [?action],

      backgroundColor: Color(0xff50C7E1),
    );
  }
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}