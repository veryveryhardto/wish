import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Provider/UIProvider.dart';
import 'package:wish/Screen/Note/noteListPage.dart';
import 'package:wish/Screen/SignLayout/loginPage.dart';

import 'Model/Note/NoteList.dart';
import 'Screen/mainScreen.dart';

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
      home: NoteListPage(),
    );
  }
}
