/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:js_interop';
import 'dart:js_util';

@JS('')
external JSPromise execDaumPostcode();


void main() async {


  runApp(const MyApp());
}

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
          print('비동기 함수 호출 전');

          try {
            // JavaScript의 fetchData() 함수 호출 결과를 Dart의 Future로 변환하고, 값을 받아온다.
            final result = await promiseToFuture(execDaumPostcode());
            print('JavaScript 비동기 함수 결과: $result');
          } catch (e) {
            print('Error: $e');
          }

          print('비동기 함수 호출 후');
        }
            , child: Text('test')),
      ),
    );
  }
}
*/

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';

class DaumPostcodeSearch extends StatefulWidget {
  final String webPageTitle;
  final String assetPath;
  final _DaumPostcodeSearchState _state = _DaumPostcodeSearchState();

  final void Function(InAppWebViewController controller,
      WebResourceRequest request, WebResourceError error)? onReceivedError;
  final void Function(InAppWebViewController controller, int progress)?
  onProgressChanged;
  final void Function(
      InAppWebViewController controller, ConsoleMessage consoleMessage)?
  onConsoleMessage;
  final InAppWebViewSettings? initialSettings;

  InAppWebViewController? get controller => this._state._controller;

  DaumPostcodeSearch({
    Key? key,
    this.webPageTitle = "주소 검색",
    this.assetPath =
    "packages/wish/assets/html/daum_search.html",
    this.onReceivedError,
    this.onProgressChanged,
    this.onConsoleMessage,
    this.initialSettings,
  }) : super(key: key);

  @override
  _DaumPostcodeSearchState createState() => _state;
}

class _DaumPostcodeSearchState extends State<DaumPostcodeSearch> {
  InAppLocalhostServer localhostServer = InAppLocalhostServer();

  InAppWebViewController? _controller;
  InAppWebViewController? get controller => _controller;
  int progress = 0;
  bool isServerRunning = false;

  @override
  void initState() {
    super.initState();
    localhostServer.start().then((_) {
      setState(
            () => isServerRunning = true,
      );
    });
  }

  @override
  void dispose() {
    localhostServer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (isServerRunning) {
      result = InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(
            "http://localhost:8080/${widget.assetPath}",
          ),
        ),
        initialSettings: widget.initialSettings ??
            InAppWebViewSettings(
              mediaPlaybackRequiresUserGesture: false,
              useHybridComposition: true,
              allowsInlineMediaPlayback: true,
              javaScriptCanOpenWindowsAutomatically: true,
              javaScriptEnabled: true,
              clearCache: true,
              networkAvailable: true,
            ),
        onWebViewCreated: (InAppWebViewController webViewController) async {
          webViewController.addJavaScriptHandler(
              handlerName: 'onSelectAddress',
              callback: (args) {
                Navigator.of(context).pop(
                  DataModel.fromMap(
                    args[0],
                  ),
                );
              });

          this._controller = webViewController;
        },
        onConsoleMessage: widget.onConsoleMessage,
        onProgressChanged: widget.onProgressChanged,
        onReceivedError: widget.onReceivedError,
      );
    } else {
      result = Center(
        child: CircularProgressIndicator(),
      );
    }

    return result;
  }
}

class DataModel {
  final String postcode;
  final String postcode1;
  final String postcode2;
  final String postcodeSeq;
  final String zonecode;
  final String address;
  final String addressEnglish;
  final String addressType;
  final String bcode;
  final String bname;
  final String bnameEnglish;
  final String bname2English;
  final String sido;
  final String sidoEnglish;
  final String sigungu;
  final String sigunguEnglish;
  final String sigunguCode;
  final String userLanguageType;
  final String query;
  final String buildingName;
  final String buildingCode;
  final String apartment;
  final String jibunAddress;
  final String jibunAddressEnglish;
  final String roadAddress;
  final String roadAddressEnglish;
  final String autoJibunAddress;
  final String autoJibunAddressEnglish;
  final String userSelectedType;
  final String noSelected;
  final String hname;
  final String roadnameCode;
  final String roadname;
  final String roadnameEnglish;

  DataModel({
    required this.postcode,
    required this.postcode1,
    required this.postcode2,
    required this.postcodeSeq,
    required this.zonecode,
    required this.address,
    required this.addressEnglish,
    required this.addressType,
    required this.bcode,
    required this.bname,
    required this.bnameEnglish,
    required this.bname2English,
    required this.sido,
    required this.sidoEnglish,
    required this.sigungu,
    required this.sigunguEnglish,
    required this.sigunguCode,
    required this.userLanguageType,
    required this.query,
    required this.buildingName,
    required this.buildingCode,
    required this.apartment,
    required this.jibunAddress,
    required this.jibunAddressEnglish,
    required this.roadAddress,
    required this.roadAddressEnglish,
    required this.autoJibunAddress,
    required this.autoJibunAddressEnglish,
    required this.userSelectedType,
    required this.noSelected,
    required this.hname,
    required this.roadnameCode,
    required this.roadname,
    required this.roadnameEnglish,
  });

  static fromMap(Map<String, dynamic> map) {
    return DataModel(
      postcode: map["postcode"] ?? "",
      postcode1: map["postcode1"] ?? "",
      postcode2: map["postcode2"] ?? "",
      postcodeSeq: map["postcodeSeq"] ?? "",
      zonecode: map["zonecode"] ?? "",
      address: map["address"] ?? "",
      addressEnglish: map["addressEnglish"] ?? "",
      addressType: map["addressType"] ?? "",
      bcode: map["bcode"] ?? "",
      bname: map["bname"] ?? "",
      bnameEnglish: map["bnameEnglish"] ?? "",
      bname2English: map["bname2English"] ?? "",
      sido: map["sido"] ?? "",
      sidoEnglish: map["sidoEnglish"] ?? "",
      sigungu: map["sigungu"] ?? "",
      sigunguEnglish: map["sigunguEnglish"] ?? "",
      sigunguCode: map["sigunguCode"] ?? "",
      userLanguageType: map["userLanguageType"] ?? "",
      query: map["query"] ?? "",
      buildingName: map["buildingName"] ?? "",
      buildingCode: map["buildingCode"] ?? "",
      apartment: map["apartment"] ?? "",
      jibunAddress: map["jibunAddress"] ?? "",
      jibunAddressEnglish: map["jibunAddressEnglish"] ?? "",
      roadAddress: map["roadAddress"] ?? "",
      roadAddressEnglish: map["roadAddressEnglish"] ?? "",
      autoJibunAddress: map["autoJibunAddress"] ?? "",
      autoJibunAddressEnglish: map["autoJibunAddressEnglish"] ?? "",
      userSelectedType: map["userSelectedType"] ?? "",
      noSelected: map["noSelected"] ?? "",
      hname: map["hname"] ?? "",
      roadnameCode: map["roadnameCode"] ?? "",
      roadname: map["roadname"] ?? "",
      roadnameEnglish: map["roadnameEnglish"] ?? "",
    );
  }
}