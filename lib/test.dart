
//import 'dart:js_interop';

//@JS()
//external JSPromise execDaumPostcode();

void main() {
  var test;
  test=5;
  print(test);
  test='test?';
  print(test);
  //runApp(const MyApp());
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