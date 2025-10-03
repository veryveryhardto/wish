
//import 'dart:js_interop';

//@JS()
//external JSPromise execDaumPostcode();

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: false,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff50C7E1),
              foregroundColor: Colors.white,
            )
        ),
        primaryColor: Color(0xff50C7E1),
        scaffoldBackgroundColor: Color(0xffF9F9F9),
      ),
      home: SampleScreen(),
    );
  }
}

class SampleScreen extends StatelessWidget {
  const SampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DialogOpenBtn(
            openDialog: () async{ var text = await alertDialog(context);
              print(text);},
            btnName: 'Alert Dialog',
          ),
          DialogOpenBtn(
            openDialog: () => cupertinoDialog(context),
            btnName: 'Cupertino Dialog',
          ),
        ],
      ),
    );
  }

  showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  alertDialog(BuildContext context) {
    bool istrue = false;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('AlertDialog Title'),
            content: const Text('Sample AlertDialog'),
            actions: [
              TextButton(
                onPressed: (){
                  istrue = true;
                  Navigator.pop(context);
                  },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  istrue = false;
                  Navigator.pop(context);},
                child: const Text('OK'),
              ),
            ],
          );
        }).then((value) => istrue);
  }

  cupertinoDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('CupertinoAlertDialog Title'),
            content: const Text('Sample CupertinoAlertDialog'),
            actions: [
              CupertinoButton(
                onPressed: () => Navigator.pop(context, 'Cupertino Cancel'),
                child: const Text('Cancel'),
              ),
              CupertinoButton(
                onPressed: () => Navigator.pop(context, 'Cupertino OK'),
                child: const Text('OK'),
              ),
            ],
          );
        }).then((value) => showSnackBar(context, value));
  }
}

class DialogOpenBtn extends StatelessWidget {
  final VoidCallback openDialog;
  final String btnName;

  const DialogOpenBtn({
    Key? key,
    required this.openDialog,
    required this.btnName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: openDialog,
        child: Text(
          btnName,
        ),
      ),
    );
  }
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