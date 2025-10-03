import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Service{

  String _token = '';
  String _device = '';

  late Map<String, String> headers={
    'Access-Control-Allow-Origin': '*',
    'Connection':'keep-alive',
    'Authorization':_token,
    'Device':_device
  };


  Future<dynamic> Fetch(var data,String method,String link,[var token,String? device]) async{
    //String url= 'http://115.68.232.69:22000';
    String url= 'http://api.wishclean.co.kr:22000';
    _token='Bearer $token';
    _device=device ?? '';
    http.Response response;
    print(token);
    print(data);
    print(url+link);
/*
    try {
      switch (method) {
        case 'get':
          response = await http.get(Uri.parse(url + link), headers: headers);
          break;
        case 'post':
          response = await http.post(Uri.parse(url + link), body: data, headers: headers);
          break;
        case 'put':
          response = await http.put(Uri.parse(url + link), body: data, headers: headers);
          break;
        case 'patch':
          response = await http.patch(Uri.parse(url + link), body: data, headers: headers);
          break;
        case 'delete':
          response = await http.delete(Uri.parse(url + link), body: data, headers: headers);
          break;
        default:
          return false;
      }
    } catch(e){
      print(e);
      return e;
    }

 */
    switch (method) {
      case 'get':
        response = await http.get(Uri.parse(url + link), headers: headers);
        break;
      case 'post':
        response = await http.post(Uri.parse(url + link), body: data, headers: headers);
        break;
      case 'put':
        response = await http.put(Uri.parse(url + link), body: data, headers: headers);
        break;
      case 'patch':
        response = await http.patch(Uri.parse(url + link), body: data, headers: headers);
        break;
      case 'delete':
        response = await http.delete(Uri.parse(url + link), body: data, headers: headers);
        break;
      default:
        return false;
    }
    final int statusCode=response.statusCode;
    print('bytes:${utf8.decode(response.bodyBytes)}');
    if (statusCode<200||statusCode>500) return false;
    return json.decode(utf8.decode(response.bodyBytes));
  }

}
