import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Provider/JobProvider.dart';
import 'package:wish/Provider/UserProvider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:wish/Screen/mainScreen(customer).dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Provider/NoteProvider.dart';


void main() async {
  await initializeDateFormatting();

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>UserProvider()),
        ChangeNotifierProvider(create: (_)=>JobProvider()),
        ChangeNotifierProvider(create: (_)=>NoteProvider())
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko','KR'),
      ],
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
      home: MainScreen_Customer(),
    );
  }
}
