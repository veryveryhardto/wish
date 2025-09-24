import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Screen/SignLayout/loginPage.dart';
import 'package:wish/Screen/Widget/appBar.dart';
import 'package:wish/Screen/Widget/customTextField.dart';
import 'package:wish/Screen/listLayout.dart';
import 'package:wish/Screen/mainScreen(customer).dart';
import 'package:wish/Screen/oneContainer.dart';
import 'package:kpostal/kpostal.dart';


class AddPage_2 extends StatefulWidget {
  const AddPage_2({super.key,});

  @override
  State<AddPage_2> createState() => _AddPage_2State();
}

class _AddPage_2State extends State<AddPage_2> {

  TextEditingController formController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '시공 신청하기',),
      body: OneContainer(
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('시공 정보',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Flexible(
                        flex: 7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('시공 위치', style: TextStyle(
                                  fontWeight: FontWeight.bold, color: Color(0xff50C7E1)),),),
                            SizedBox(height: 5,),
                            TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xfff5f5f5),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide.none
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Color(0xff50C7E1),
                                    )
                                ),
                              ),
                              controller: addressController,
                              onChanged: widget.onChnaged,
                              validator: widget.validator,
                            ),
                          ],
                        )
                      ),
                      Flexible(
                        flex:3,
                        child: ElevatedButton(
                          onPressed: () async => await Navigator.push(context, MaterialPageRoute(
                            builder: (_) => KpostalView(
                              callback: (Kpostal result) {
                                setState(() {
                                  addressController.text=result.address;
                                  .farmAddress.addressName = result.address;
                                  .farmAddress.y = result.latitude.toString();
                                  .farmAddress.x = result.longitude.toString();
                                });
                              },
                            ),),),
                          child: Text('주소 찾기',style: TextStyle(fontSize: 17,),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 10,),
                CustomTextField(textController: textController, title: '평수'),
                CustomTextField(textController: textController, title: '카테고리'),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('요청사항', style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xff50C7E1)),),),
                SizedBox(height: 5,),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xfff5f5f5),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xff50C7E1),
                          )
                      ),
                    ),
                    controller: formController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
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
                      onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen_Customer())),
                      child: Text('시공 신청하기')),
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