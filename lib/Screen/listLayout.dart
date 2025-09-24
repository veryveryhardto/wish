import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Screen/Widget/appBar.dart';
import 'package:wish/Screen/Widget/customTextField.dart';

import '../Provider/UserProvider.dart';
import '../test2.dart';
import 'SignLayout/loginPage.dart';

class ListLayout extends StatefulWidget {
  const ListLayout({super.key,});

  @override
  State<ListLayout> createState() => _ListLayoutState();
}

class _ListLayoutState extends State<ListLayout> {

  TextEditingController _text1 = TextEditingController();
  TextEditingController _text2 = TextEditingController();
  bool _sortAscending = true;
  int? _sortColumnIndex;
  late DessertDataSource _dessertsDataSource;
  bool _initialized = false;
  bool showCustomArrow = false;
  bool sortArrowsAlwaysVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _dessertsDataSource = DessertDataSource(
        context,
        false,);
      _initialized = true;
      _dessertsDataSource.addListener(() {
        setState(() {});
      });
    }
  }

  void _sort<T>(
      Comparable<T> Function(Dessert d) getField,
      int columnIndex,
      bool ascending,
      ) {
    _dessertsDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    UIProvider ui=Provider.of<UIProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(title: '메인',
          action: ui.isLogined?null:LoginButton(context)),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(30),
          padding: EdgeInsets.all(20),
          height: double.infinity,
          width: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3? (MediaQuery.of(context).size.width)*0.9 : (MediaQuery.of(context).size.height)*1.5,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                        CustomTextField(textController: _text1, title: _text1.text),
                        CustomTextField(textController: _text1, title: _text1.text),
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
                        onPressed: (){},
                        child: Text('검색'),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 13,),
              Divider(),
              Row(
                children: [

                ],
              ),
              Expanded(child:
              DataTable2(
                  empty: Center(
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.grey[200],
                          child: const Text('데이터가 없습니다.')
                      )
                  ),
                  headingTextStyle: const TextStyle(color: Color(0xff50C7E1)),
                  showCheckboxColumn: false,
                  isHorizontalScrollBarVisible: true,
                  isVerticalScrollBarVisible: true,
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  dividerThickness: 0,
                  minWidth: 900,
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  sortArrowIconColor:Color(0xff50C7E1),
                  columns: [
                    DataColumn2(
                      label: Text('Column A'),
                      size: ColumnSize.L,
                      onSort: (columnIndex, ascending) =>
                          _sort<String>((d) => d.name, columnIndex, ascending),
                    ),
                    DataColumn(
                      label: Text('Column B'),
                    ),
                    DataColumn(
                      label: Text('Column C'),
                    ),
                    DataColumn(
                      label: Text('Column D'),
                    ),
                    DataColumn(
                      label: Text('Column NUMBERS'),
                      numeric: true,
                    ),
                  ],
                  /*
                  rows: List<DataRow>.generate(_dessertsDataSource.rowCount,
                          (index) => _dessertsDataSource.getRow(index)),

                   */
                  rows: List<DataRow>.generate(
                      100,
                          (index) => DataRow(cells: [
                        DataCell(Text('A' * (10 - index % 10))),
                        DataCell(Text('B' * (10 - (index + 5) % 10))),
                        DataCell(Text('C' * (15 - (index + 5) % 10))),
                        DataCell(Text('D' * (15 - (index + 10) % 10))),
                        DataCell(Text(((index + 0.1) * 25.4).toString()))
                      ]))),
              )
            ],
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
