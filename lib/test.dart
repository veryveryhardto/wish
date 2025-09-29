
//import 'dart:js_interop';

//@JS()
//external JSPromise execDaumPostcode();

import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DataTableSource _data = MyData();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(20),
            child: PaginatedDataTable(
              source: _data,
              columns: const [
                DataColumn(label: Text('')),
                DataColumn(label: Text(''),numeric: true)
              ],
              headingRowHeight : 20,
              rowsPerPage: 5,
              dataRowMinHeight: 30,
              dataRowMaxHeight: 30,
              dividerThickness: 0.0001,
              showCheckboxColumn: false,
            ),
          )
        ],
      ),

    );
  }
}

class MyData extends  DataTableSource{

  final List<Map<String, dynamic>> _data = List.generate(
      10,
          (index) => {
        "title": "Item ${Random().nextInt(10000)}",
        "price": Random().nextInt(10000)
      });

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index]["title"])),
      DataCell(Text(_data[index]["price"].toString())),
    ],
      onSelectChanged: (selected){
      if(selected!) print(index);
      },

    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => _data.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

}
/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () async {
          await execDaumPostcode().toDart;
          try {
            // JavaScript의 fetchData() 함수 호출 결과를 Dart의 Future로 변환하고, 값을 받아온다.

          } catch (e) {
            print('Error: $e');
          }

          // addNumbers 함수 호출 및 결과 받기
          //final result = js.context.callMethod('addNumbers', [5, 7]);
          //print('Result from addNumbers: $result'); // 콘솔에 12 출력

        }, child: Text('test')),
      ),
    );
  }
}

 */