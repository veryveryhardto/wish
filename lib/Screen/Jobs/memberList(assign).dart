import 'dart:convert';
import 'dart:js_interop';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Model/Token.dart';
import 'package:wish/Model/User/memberlist.dart' as member;
import '../../Provider/UserProvider.dart';
import '../../Service.dart';
import '../Widget/appBar.dart';
import '../Widget/customTextField.dart';

class MemberList_Assign extends StatefulWidget {
  const MemberList_Assign({super.key,});

  @override
  State<MemberList_Assign> createState() => _MemberList_AssignState();
}

class _MemberList_AssignState extends State<MemberList_Assign> {

  TextEditingController _affilation = TextEditingController();
  TextEditingController _name = TextEditingController();

  List<member.Items> _lastlist = [];
  bool _init = false;

  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)=>Notice());
  }
  Future<void> Notice() async{
    UserProvider user=Provider.of<UserProvider>(context,listen: false);

    try {
      var json=await Service().Fetch('', 'get', '/api/auth/users',await Token().AccessRead());
      if(json==false) return;
      var data = member.MemberList.fromJson(json);
      if (data.code == 'success' && data.data != null &&
          data.data!.total! > 0) {
        user.memberList = data;
        setState(() {
          _lastlist = member.MemberList.fromJson(user.memberList.toJson()).data!.items!.where((e)=>e.role==1).toList();
        });
      }
      else
        return;
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(()=>_init=true);
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
    UserProvider user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: '회원 목록',),
      body: Center(
        child: !_init ? CircularProgressIndicator(color: Color(0xff50C7E1),): Container(
          margin: EdgeInsets.all(30),
          height: double.infinity,
          width: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3? (MediaQuery.of(context).size.width)*0.9 : (MediaQuery.of(context).size.width)*0.6,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                                CustomTextField(textController: _affilation, title: '소속'),
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
                                    List<member.Items> _list = user.memberList.data!.items??[];
                                    setState(() {
                                      _lastlist = _list.where(
                                          _affilation.text!=''&&_name.text!=''?(e)=>e.name!.contains(_name.text)&&e.affiliation!.contains(_affilation.text):
                                          _name.text!=''?(e)=>e.name!.contains(_name.text):
                                          _affilation.text!=''?(e)=>e.affiliation!.contains(_affilation.text):
                                              (e)=>true).where((e2)=>e2.role==1).toList();
                                    });
                                    _sortColumnIndex=null;
                                    _sortAscending=true;
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
                                  member.Items _selected = _lastlist[index];
                                  Navigator.pop(context,_selected);
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
}
