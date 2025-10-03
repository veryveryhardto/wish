import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Model/Jobs/jobList.dart' as jobList;
import 'package:wish/Model/Token.dart';
import 'package:wish/Screen/Widget/Indicator.dart';
import 'package:wish/Screen/Widget/appBar.dart';
import 'package:wish/Screen/Widget/customTextField.dart';

import '../../Model/Jobs/jobDetail.dart'as detail;
import '../../Provider/JobProvider.dart';
import '../../Service.dart';
import 'jobDetail.dart';

class JobList extends StatefulWidget {
  const JobList({super.key,});

  @override
  State<JobList> createState() => _JobListState();
}

class _JobListState extends State<JobList> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController _name = TextEditingController();
  TextEditingController _text = TextEditingController();
  List<jobList.Data> _lastlist = [];
  bool _sortAscending = true;
  int? _sortColumnIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    JobProvider job=Provider.of<JobProvider>(context);
    _lastlist = jobList.JobList.fromJson(job.jobList.toJson()).data??[];
  }

  void _sort<T>(
      Comparable<T> Function(jobList.Data data) getField,
      int columnIndex,
      bool ascending,
      ) {
    _lastlist.sort((a, b) {
      if (!ascending) {
        final jobList.Data c = a;
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
                          CustomTextField(textController: _name, title: '신청자명',),
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
                          onPressed: () {
                            setState(() {
                              List<jobList.Data> list = job.jobList.data??[];
                              _lastlist = list.where(
                                  _name.text!=''&&_text.text!=''?(e)=>e.customerName!.contains(_name.text)&&e.jobCategoryName!.contains(_text.text):
                                  _name.text!=''?(e)=>e.customerName!.contains(_name.text):
                                  _text.text!=''?(e)=>e.jobCategoryName!.contains(_text.text):
                                      (e)=>true).toList();
                              _sortColumnIndex = null;
                              _sortAscending = true;
                            });
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
                    minWidth:(MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3? (MediaQuery.of(context).size.width)*0.8 : (MediaQuery.of(context).size.width)*0.5,
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    sortArrowIconColor:Color(0xff50C7E1),
                    columns: [
                      DataColumn2(
                        label: Text('작업일'),
                        size: ColumnSize.L,
                        onSort: (columnIndex, ascending) => _sort<DateTime>((data) => data.jobScheduleTime!, columnIndex, ascending),
                      ),
                      DataColumn2(
                        label: Text('신청자명'),
                        onSort: (columnIndex, ascending) => _sort<String>((data) => data.jobStatus.toString(), columnIndex, ascending),
                      ),
                      DataColumn2(
                        label: Text('신청자 번호'),
                        onSort: (columnIndex, ascending) => _sort<String>((data) => data.customerPhone!, columnIndex, ascending),
                      ),
                      DataColumn2(
                        label: Text('카테고리'),
                        onSort: (columnIndex, ascending) => _sort<String>((data) => data.jobCategoryName!, columnIndex, ascending),
                      ),
                    ],
                    rows: List<DataRow>.generate( _lastlist.length, (index) => DataRow(cells: [
                      DataCell(Text(_lastlist[index].jobScheduledAt==null?'미정':_lastlist[index].jobScheduleTime.toString().substring(0,10))),
                      DataCell(Text(_lastlist[index].customerName??'')),
                      DataCell(Text(_lastlist[index].customerPhone??'미정')),
                      DataCell(Text(_lastlist[index].jobCategoryName??'')),
                    ],
                      onSelectChanged: (selected) async {
                        if(selected!){
                          var json = await Service().Fetch('', 'get',
                            '/api/staff/jobs/${_lastlist[index].jobUuid}',await Token().AccessRead());
                          if (json == false) return;
                          else {
                            try {
                              var data = detail.JobDetail.fromJson(json);
                              job.currentJobDetail=data;
                              Navigator.push(context, MaterialPageRoute(builder: (context) => JobDetail()));
                            } catch (e) {
                              print(e);
                            }
                          }
                        }

                        /*
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
}
