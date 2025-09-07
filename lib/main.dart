import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Provider/UIProvider.dart';
import 'package:wish/Screen/SignLayout/loginPage.dart';
import 'package:wish/Screen/SignLayout/signLayout.dart';
import 'package:wish/Screen/detailPage.dart';
import 'Screen/mainScreen.dart';
import 'Service.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>UIProvider())
      ],
      child: const MyApp()
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff50C7E1)),
        scaffoldBackgroundColor: Color(0xffF9F9F9),
      ),
      home: const DetailPage(),
    );
  }
}
