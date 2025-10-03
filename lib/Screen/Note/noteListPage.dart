import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Screen/Note/memberListPage.dart';
import 'package:wish/Screen/Widget/NoteDialog.dart';

import '../../Model/Note/NoteList.dart';
import '../../Model/Token.dart';
import '../../Model/User/memberlist.dart' as member;
import '../../Provider/NoteProvider.dart';
import '../../Provider/UserProvider.dart';
import '../../Service.dart';
import '../Widget/appBar.dart';
import '../Widget/customTextField.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key,});

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {

  TextEditingController _name = TextEditingController();
  TextEditingController _title = TextEditingController();

  late NoteList _lastList = NoteList();
  void initState() {
    // TODO: implement initState
    super.initState();
    NoteProvider note=Provider.of<NoteProvider>(context,listen: false);
    _lastList = NoteList.fromJson(note.noteList.toJson());
  }

  bool _sortAscending = true;
  int? _sortColumnIndex;

  void _sort<T>(
      Comparable<T> Function(Data list) getField,
      int columnIndex,
      bool ascending,
      ) {
    _lastList.data!.sort((a, b) {
      if (!ascending) {
        final Data c = a;
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
    NoteProvider note=Provider.of<NoteProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(title: '게시물 관리',),
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
                    onPressed: () async {
                      UserProvider user=Provider.of<UserProvider>(context,listen: false);

                      var json=await Service().Fetch('', 'get', '/api/auth/users',await Token().AccessRead());
                      if(json==false) return;
                      else {
                        try {
                          var data = member.MemberList.fromJson(json);
                          if(data.code=='success'&&data.data!=null&&data.data!.total!>0){
                            user.memberList=data;
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MemberListPage(),),);
                          }
                          else return;
                        } catch(e){
                          print(e);
                        }
                      }
                      },
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
                                CustomTextField(textController: _name, title: '작성자'),
                                CustomTextField(textController: _title, title: '제목'),
                              ],
                            ),
                          ),
                          SizedBox(width: 10,),
                          Flexible(
                            flex: 2,
                            fit:FlexFit.loose,
                            child: Container(
                              width: double.infinity,
                              height: 161,
                              child: ElevatedButton(
                                onPressed: (){
                                  List<Data> _list = note.noteList.data??[];
                                  setState(() {
                                    _lastList.data = _list.where(
                                        _name.text!=''&&_title.text!=''?(e)=>e.createdBy!.contains(_name.text)&&e.noticeTitle!.contains(_title.text):
                                        _name.text!=''?(e)=>e.createdBy!.contains(_name.text):
                                        _title.text!=''?(e)=>e.noticeTitle!.contains(_title.text):
                                            (e)=>true).toList();
                                  });
                                  _sortColumnIndex=null;
                                  _sortAscending=true;
                                },
                                child: Text('검색'),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Flexible(
                            flex: 2,
                            fit:FlexFit.loose,
                            child: Container(
                              width: double.infinity,
                              height: 161,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                                onPressed: ()=>NoteDialog().show(context,modified: true,create: true),
                                child: Text('글 작성',overflow: TextOverflow.fade,),
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
                            //minWidth:900,
                            columnSpacing: 12,
                            horizontalMargin: 12,
                            dividerThickness: 0,
                            //minWidth:(MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3? (MediaQuery.of(context).size.width)*0.8 : (MediaQuery.of(context).size.width)*0.5,
                            sortColumnIndex: _sortColumnIndex,
                            sortAscending: _sortAscending,
                            sortArrowIconColor:Color(0xff50C7E1),
                            columns: [
                              DataColumn2(
                                label: Text('작성자'),
                                onSort: (columnIndex, ascending) => _sort<String>((data) => data.createdBy!, columnIndex, ascending),
                              ),
                              DataColumn2(
                                label: Text('핀'),
                                size: ColumnSize.S,
                                onSort: (columnIndex, ascending) => _sort<String>((data) => data.isPinned!?'1':'0', columnIndex, ascending),
                              ),
                              DataColumn2(
                                label: Text('제목'),
                                size: ColumnSize.L,
                                onSort: (columnIndex, ascending) => _sort<String>((data) => data.noticeTitle!, columnIndex, ascending),
                              ),
                              DataColumn2(
                                label: Text('작성시간'),
                                size: ColumnSize.L,
                                onSort: (columnIndex, ascending) => _sort<DateTime>((data) => data.createdAt!, columnIndex, ascending),
                              ),
                            ],
                            rows: List<DataRow>.generate( _lastList.data!.length, (index) => DataRow(cells: [
                              DataCell(Text(_lastList.data![index].createdBy??'null')),
                              DataCell(Icon(Icons.check,color: _lastList.data![index].isPinned! ? Colors.black:Colors.white,)),
                              DataCell(Text(_lastList.data![index].noticeTitle??'null')),
                              DataCell(Text(_lastList.data![index].createdAt.toString().substring(0,19))),
                            ],
                              onSelectChanged: (selected){
                                if(selected!) NoteDialog().show(context, note:Data(
                                    noticeBody: _lastList.data![index].noticeBody??'내용',
                                    noticeTitle: _lastList.data![index].noticeTitle??'null',
                                    createdBy: _lastList.data![index].createdBy??'null',
                                    createdAt: _lastList.data![index].createdAt));
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
