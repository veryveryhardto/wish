import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';
import 'package:provider/provider.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:wish/Screen/Widget/appBar.dart';
import 'package:wish/Screen/Widget/customTextField.dart';

import '../../Provider/UserProvider.dart';
import '../SignLayout/loginPage.dart';

class JobList_Customer extends StatefulWidget {
  const JobList_Customer({super.key,});

  @override
  State<JobList_Customer> createState() => _JobList_CustomerState();
}

class _JobList_CustomerState extends State<JobList_Customer> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController _phone = TextEditingController();
  String _lastPhone = '';
  TextEditingController _text = TextEditingController();
  bool _sortAscending = true;
  int? _sortColumnIndex;

  List<User> _users = [
    User('John Doe', 25, 'Developer'),
    User('Jane Smith', 30, 'Designer'),
    User('Alex Johnson', 28, 'Manager'),
  ];

  void _sort<T>(
      Comparable<T> Function(User user) getField,
      int columnIndex,
      bool ascending,
      ) {
    _users.sort((a, b) {
    if (!ascending) {
      final User c = a;
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
    UserProvider ui=Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(title: '시공 조회',
          //action: ui.isLogined?null:LoginButton(context)
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(30),
          padding: EdgeInsets.all(20),
          height: double.infinity,
          width: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3? (MediaQuery.of(context).size.width)*0.9 : (MediaQuery.of(context).size.width)*0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Form(
            key:_formKey,
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
                          CustomTextField(textController: _phone, title: '전화번호',
                            validator: (val){
                              if(val!.length < 0) return '전화번호를 작성해 주세요';
                              else if (validator.phone(val!)) return '전화번호를 정확히 작성해 주세요';
                              else return null;
                            },
                            textInputFormatter: [MultiMaskedTextInputFormatter(masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxxx'], separator: '-')],
                            textInputType: TextInputType.phone,
                          ),
                          CustomTextField(textController: _text, title: '검색어'),
                        ],
                      ),
                    ),
                    SizedBox(width: 10,),
                    Flexible(
                      flex: 3,
                      fit:FlexFit.loose,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        child: ElevatedButton(
                          onPressed: (){if(_formKey.currentState!.validate()){
                            print('ok');
                          }},
                          child: Text('검색'),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 13,),
                Divider(),
                Expanded(child:
                DataTable2(
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
                    minWidth:(MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3? (MediaQuery.of(context).size.width)*0.8 : (MediaQuery.of(context).size.width)*0.5,
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    sortArrowIconColor:Color(0xff50C7E1),
                    columns: [
                      DataColumn2(
                        label: Text('날짜'),
                        onSort: (columnIndex, ascending) => _sort<String>((user) => user.name, columnIndex, ascending),
                      ),
                      DataColumn2(
                        label: Text('신청자명'),
                      ),
                      DataColumn2(
                        label: Text('타입'),
                      ),
                      DataColumn2(
                        label: Text('작업범위'),
                      ),
                      DataColumn2(
                        label: Text('주소'),
                        size: ColumnSize.L,
                      ),
                    ],
                    rows: List<DataRow>.generate( 0, (index) => DataRow(cells: [
                      DataCell(Text(_users[index].name)),
                      DataCell(Text(_users[index].age.toString())),
                      DataCell(Text(_users[index].role)),
                      DataCell(Text(_users[index].role)),
                      DataCell(Text(_users[index].role)),
                        ],
                              onSelectChanged: (selected){/*
                              role 1 이상 - /api/staff/jobs/:id
                                role - /api/public/jobs/d2da8136-d5e1-4484-8ac9-5ef670760461?phone=010-3333-2244
                                if(selected!) Navigator.push(context, MaterialPageRoute(builder: (context) => JobDetail()));
                                role 없으면 Navigator.push(context, MaterialPageRoute(builder: (context) => JobDetail_Customer()));
                                */
                              },
                            ))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget LoginButton(BuildContext context)=>Padding(
    padding: const EdgeInsets.only(right: 15),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(15),
        backgroundColor: Colors.white,
        minimumSize: Size.zero,
      ),
      onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
      child: Text('업체용 로그인',style: TextStyle(color: Color(0xff50C7E1),),
      ),),
  );
}

class User {
  final String name;
  final int age;
  final String role;

  User(this.name, this.age, this.role);
}