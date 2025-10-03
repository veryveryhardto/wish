import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Model/Token.dart';
import 'package:wish/Model/User/memberlist.dart' as member;
import 'package:wish/Provider/NoteProvider.dart';
import 'package:wish/Screen/Widget/customDropdown.dart';

import '../../Model/Note/NoteList.dart';
import '../../Model/message.dart';
import '../../Provider/UserProvider.dart';
import '../../Service.dart';
import '../Widget/Indicator.dart';
import '../Widget/appBar.dart';
import '../Widget/customTextField.dart';
import '../Widget/customToast.dart';
import 'noteListPage.dart';

class MemberListPage extends StatefulWidget {
  const MemberListPage({super.key,});

  @override
  State<MemberListPage> createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {

  TextEditingController _role = TextEditingController();
  TextEditingController _name = TextEditingController();

  List<member.Items> _lastlist = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    UserProvider user =Provider.of<UserProvider>(context,listen: false);
    _lastlist = member.MemberList.fromJson(user.memberList.toJson()).data!.items!;
  }

  bool _sortAscending = true;
  int? _sortColumnIndex;

  void _sort<T>(
      Comparable<T> Function(member.Items list) getField,
      int columnIndex,
      bool ascending,
      ) {
    _lastlist.sort((a, b) {
      if (!ascending) {
        final member.Items c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }


  @override
  Widget build(BuildContext context) {
    UserProvider user =Provider.of<UserProvider>(context);
    NoteProvider note = Provider.of<NoteProvider>(context);

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
                    onPressed: () async {
                      var json=await Service().Fetch('', 'get', '/api/notices',);
                      if(json==false) return;
                      else {
                        try {
                          var data = NoteList.fromJson(json);
                          if(data.code=='success'&&data.data!=null&&data.data!.length>0){
                            note.setNoteList=data;
                            note.setNoteData(data,context);
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => NoteListPage()));
                          }
                          else return;
                        } catch(e){
                          print(e);
                        }
                      }
                      },
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
              Expanded(
                child: Container(
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
                                CustomDropdown(textController: _role, title: '등급', list: member.memberRole,),
                                CustomTextField(textController: _name, title: '이름'),
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
                                onPressed: (){
                                  setState(() {
                                    List<member.Items> _list = user.memberList
                                        .data!.items ?? [];
                                    setState(() {
                                      _lastlist = _list.where(
                                          _name.text != '' && _role.text != ''
                                              ? (e) =>
                                          e.name!.contains(_name.text) &&
                                              member.memberRole.indexOf(
                                                  _role.text) == e.role
                                              :
                                          _name.text != '' ? (e) =>
                                              e.name!.contains(_name.text) :
                                          _role.text != '' ? (e) =>
                                          member.memberRole.indexOf(
                                              _role.text) == e.role :
                                              (e) => true).toList();

                                    });
                                    _sortColumnIndex = null;
                                    _sortAscending = true;
                                  });
                                },
                                child: Text('검색'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 13,),
                      Divider(),
                      Expanded(
                        child: DataTable2(
                            empty: Center(
                                child: Container(
                                    padding: const EdgeInsets.all(20),
                                    color: Colors.grey[200],
                                    child: const Text('일치하는 데이터가 없습니다.')
                                )
                            ),
                            headingTextStyle: const TextStyle(color: Color(0xff50C7E1)),
                            showCheckboxColumn: false,
                            isHorizontalScrollBarVisible: true,
                            isVerticalScrollBarVisible: true,
                            columnSpacing: 12,
                            horizontalMargin: 12,
                            dividerThickness: 0,
                            sortColumnIndex: _sortColumnIndex,
                            sortAscending: _sortAscending,
                            sortArrowIconColor:Color(0xff50C7E1),
                            columns: [
                              DataColumn2(
                                label: Text('ID'),
                                onSort: (columnIndex, ascending) => _sort<String>((data) => data.loginId!, columnIndex, ascending),
                              ),
                              DataColumn2(
                                label: Text('이름'),
                                size: ColumnSize.S,
                                onSort: (columnIndex, ascending) => _sort<String>((data) => data.name!, columnIndex, ascending),
                              ),
                              DataColumn2(
                                label: Text('등급'),
                                size: ColumnSize.S,
                                onSort: (columnIndex, ascending) => _sort<String>((data) => data.role.toString(), columnIndex, ascending),
                              ),
                              DataColumn2(
                                label: Text('소속'),
                                onSort: (columnIndex, ascending) => _sort<String>((data) => data.affiliation??'', columnIndex, ascending),
                              ),
                              DataColumn2(
                                label: Text('전화번호'),
                                size: ColumnSize.L,
                                onSort: (columnIndex, ascending) => _sort<String>((data) => data.phone!, columnIndex, ascending),
                              ),
                            ],
                            rows: List<DataRow>.generate( _lastlist.length, (index) => DataRow(cells: [
                              DataCell(Text(_lastlist[index].loginId??'null')),
                              DataCell(Text(_lastlist[index].name??'null')),
                              DataCell(Text(_lastlist[index].roleName)),
                              DataCell(Text(_lastlist[index].affiliation??'')),
                              DataCell(Text(_lastlist[index].phone??'null')),
                            ],
                              onSelectChanged: (selected) async{
                              if(selected!) {
                                RoleModify(_lastlist[index].role!,_lastlist[index].userUuid!,index,user);
                              }
                              },
                            ))),
                      )

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  RoleModify(int role,String uuid,int index,UserProvider user) {
    TextEditingController roleName = TextEditingController();
    return showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('권한 변경',style:TextStyle(color: Color(0xff50C7E1),)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(title: '현재 권한',data: member.memberRole[role]),
                  SizedBox(height: 10,),
                  CustomDropdown(textController: roleName, title: '변경할 권한', list: member.memberRole),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15),),
                      child: Text("변경하기",style: TextStyle(fontSize: 20),),
                      onPressed: () async{
                        Indicator().show(context);
                        var _json = await Service().Fetch('''
                        {
                          "newRoleClass" : ${member.memberRole.indexOf(roleName.text)},
                        }''', 'patch', '/api/admin/users/${uuid}/role',await Token().AccessRead());
                        try {
                          var data = Message.fromJson(_json);
                          if(data.code=='success'){
                            Indicator().dismiss();
                            user.memberList.data!.items![index].role=member.memberRole.indexOf(roleName.text);
                            setState((){
                              _lastlist[index].role=member.memberRole.indexOf(roleName.text);
                            });
                            CustomToast('변경되었습니다.', context);
                            Navigator.pop(context);
                          }
                          else CustomToast('변경되지 못했습니다.', context);
                          Indicator().dismiss();
                        } catch(e){
                          CustomToast('잘못된 접근입니다.', context);
                          Indicator().dismiss();
                          print(e);
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
}
