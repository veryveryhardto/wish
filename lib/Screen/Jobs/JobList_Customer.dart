import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';
import 'package:provider/provider.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:wish/Screen/Widget/Indicator.dart';
import 'package:wish/Screen/Widget/appBar.dart';
import 'package:wish/Screen/Widget/customTextField.dart';

import '../../Model/Jobs/jobDetail.dart'as detail;
import '../../Model/Jobs/jobList_Customer.dart'as jobList;
import '../../Provider/JobProvider.dart';
import '../../Service.dart';
import '../SignLayout/loginPage.dart';
import 'jobDetail_customer.dart';

class JobList_Customer extends StatefulWidget {
  const JobList_Customer({super.key,});

  @override
  State<JobList_Customer> createState() => _JobList_CustomerState();
}

class _JobList_CustomerState extends State<JobList_Customer> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController _phone = TextEditingController();
  TextEditingController _text = TextEditingController();
  String _lastPhone = '';
  bool _phoneChanged = false;
  List<jobList.Items> _lastlist = [];
  bool _sortAscending = true;
  int? _sortColumnIndex;

  void _sort<T>(
      Comparable<T> Function(jobList.Items data) getField,
      int columnIndex,
      bool ascending,
      ) {
    _lastlist.sort((a, b) {
    if (!ascending) {
      final jobList.Items c = a;
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
    JobProvider job=Provider.of<JobProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(title: '시공 조회',
          action: LoginButton(context)
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
                            onChnaged: (val)=>setState(()=>_phoneChanged=true),
                            validator: (val){
                              if(val!.length == 0 ) return '전화번호를 작성해 주세요';
                              else if (!validator.phone(val!)) return '전화번호를 정확히 작성해 주세요';
                              else return null;
                            },
                            textInputFormatter: [MultiMaskedTextInputFormatter(masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxxx'], separator: '-')],
                            textInputType: TextInputType.phone,
                          ),
                          CustomTextField(textController: _text, title: '카테고리명'),
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
                          onPressed: () async{
                            if(_formKey.currentState!.validate()) {
                              if (_phoneChanged) {
                                _lastPhone = _phone.text;
                                Indicator().show(context);
                                var json = await Service().Fetch('', 'get', '/api/public/jobs/mine?phone=${_phone.text}',);
                                try {

                                  var data = jobList.JobList_Customer.fromJson(json);
                                  _phoneChanged = false;
                                  if (data.code == 'success')
                                    job.jobList_customer = data;
                                    if(data.data!.items != null &&
                                      data.data!.items!.length > 0) {
                                    _lastlist = jobList.JobList_Customer
                                        .fromJson(job.jobList_customer.toJson())
                                        .data!.items!;
                                    }
                                    else{
                                      _lastlist = [];
                                    }

                                    Indicator().dismiss();
                                } catch (e) {
                                  debugPrint(e.toString());
                                  Indicator().dismiss();
                                  }
                                setState(() {
                                  List<jobList.Items> list = job.jobList_customer.data?.items ?? [];
                                  _lastlist = list.where(
                                      _text.text != '' ? (e) =>
                                          e.jobCategoryName!.contains(_text.text) :
                                          (e) => true).toList();
                                  _sortColumnIndex = null;
                                  _sortAscending = true;
                                });

                                }
                              }
                            },
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
                    minWidth: 500,
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    sortArrowIconColor:Color(0xff50C7E1),
                    columns: [
                      DataColumn2(
                        label: Text('신청상태'),
                        onSort: (columnIndex, ascending) => _sort<String>((data) => data.jobStatus.toString(), columnIndex, ascending),
                      ),
                      DataColumn2(
                        label: Text('카테고리'),
                        onSort: (columnIndex, ascending) => _sort<String>((data) => data.jobCategoryName??'', columnIndex, ascending),
                      ),
                      DataColumn2(
                        label: Text('작업자명'),
                        onSort: (columnIndex, ascending) => _sort<String>((data) => data.managerName??'', columnIndex, ascending),
                      ),
                      DataColumn2(
                        label: Text('작업일'),
                        size: ColumnSize.L,
                        onSort: (columnIndex, ascending) => _sort<DateTime>((data) => data.jobScheduleTime??DateTime(2000), columnIndex, ascending),
                      ),
                    ],
                    rows: List<DataRow>.generate( _lastlist.length, (index) => DataRow(cells: [
                      DataCell(Text(_lastlist[index].jobStatusName)),
                      DataCell(Text(_lastlist[index].jobCategoryName??'')),
                      DataCell(Text(_lastlist[index].managerName??'미정')),
                      DataCell(Text(_lastlist[index].jobScheduledAt==null?'미정':_lastlist[index].jobScheduleTime.toString().substring(0,10))),
                        ],
                              onSelectChanged: (selected) async {
                      if(selected!){
                        var json = await Service().Fetch('', 'get',
                          '/api/public/jobs/${_lastlist[index].jobUuid}?phone=${_lastPhone}',);
                        if (json == false) return;
                        else {
                          try {
                            var data = detail.JobDetail.fromJson(json);
                            job.currentJobDetail=data;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => JobDetail_Customer()));
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        }
                        }},
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
    padding: const EdgeInsets.all(10),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(15),
        backgroundColor: Colors.white,
        minimumSize: Size.zero,
      ),
      onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
      child: Text('로그인',style: TextStyle(color: Color(0xff50C7E1),),
      ),),
  );
}
