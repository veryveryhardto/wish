import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Service{

  Future<dynamic> Fetch(var data,String method,String link,[var token,String? device]) async{
    //String url= 'http://115.68.232.69:22000';
    String url= 'http://api.wishclean.co.kr:22000';
    final headers = <String, String>{
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      if (device != null && device.isNotEmpty) 'device': device,
      // ❌ 'Connection' 같은 금지/무의미 헤더는 넣지 말 것
    };
    http.Response response;
    debugPrint(token);
    debugPrint(data);
    debugPrint(url+link);

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
      debugPrint(e as String);
      return e;
    }

    final int statusCode=response.statusCode;
    debugPrint('bytes:${utf8.decode(response.bodyBytes)}');
    if (statusCode<200||statusCode>500) return false;
    return json.decode(utf8.decode(response.bodyBytes));
  }

}
