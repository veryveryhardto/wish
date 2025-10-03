import 'dart:collection';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wish/Model/User/signIn.dart';

import '../Service.dart';

class Token {

  final _tokenStorage = const FlutterSecureStorage();
  final Map<String, String> _key = {
    'accessTokenKey': 'secure_Access',
    'refreshTokenKey': 'secure_Refresh',
    'UUIDKey': 'secure_UUID',
    'roleKey': 'roleKey'
  };

  Write(SignIn data,[String? UUID,int? role]) async {
    if(data==null||data.code=='failed') return 'failed';
    if(UUID!=null) await _tokenStorage.write(key: _key['UUIDKey']!, value: UUID);
    if(UUID!=role) await _tokenStorage.write(key: _key['roleKey']!, value: role.toString());
    await _tokenStorage.write(key: _key['accessTokenKey']!, value: data.data?.accessToken);
    await _tokenStorage.write(key: _key['refreshTokenKey']!, value: data.data?.refreshToken);
    return 'success';
  }

  Future<dynamic> AccessRead() async => await _tokenStorage.read(key: _key['accessTokenKey']!);
  Future<dynamic> RefreshRead() async => await _tokenStorage.read(key: _key['refreshTokenKey']!);
  Future<dynamic> UUIDRead() async => await _tokenStorage.read(key: _key['UUIDKey']!);
  Future<dynamic> RoleRead() async => int.parse(await _tokenStorage.read(key: _key['roleKey']!)??'0');

  Delete() async {
    await _tokenStorage.delete(key: _key['accessTokenKey']!);
    await _tokenStorage.delete(key: _key['refreshTokenKey']!);
    await _tokenStorage.delete(key: _key['UUIDKey']!);
    await _tokenStorage.delete(key: _key['roleKey']!);
  }

  Future<dynamic> RefreshToken() async {
    String? refreshToken = (await _tokenStorage.read(
        key: _key['refreshTokenKey']!))!;
    String? acceesToken = (await _tokenStorage.read(
        key: _key['accessTokenKey']!))!;

    Map<String, String> data = {
      "accessToken": "$acceesToken",
      "refreshToken": "$refreshToken"
    };

    var Message = await Service().Fetch(data, 'post', '/api/auth/refresh',);
    print(Message['code']);
    /*
    if (key == _key['refreshTokenKey']) {

      if (accessMessage is Map<String,dynamic> && accessMessage['code'] == 1) {
        await _tokenStorage.write(key: _key['accessTokenKey']!, value: accessMessage['accessToken']);
        return await _tokenStorage.read(key: _key['accessTokenKey']!);
      }
      else {
        refreshToken=await RefreshToken(_key['refreshTokenKey']!);
        Future.delayed(const Duration(seconds: 1),);
        if(refreshToken==null){
          await Delete({
            'accessTokenKey': '!!bioline_secure_Access!!',
            'refreshTokenKey': '!!bioline_secure_Refresh!!',
          });
          return null;
        }
        Future.delayed(const Duration(seconds: 1),);
        accessMessage = AccessMessage.fromJson(await TokenService().Fetch('''{
          "refreshToken": "$refreshToken"
          }''', 'put', '/token/token-access', ''));
        Future.delayed(const Duration(seconds: 1),);
        return await _tokenStorage.read(key: _key['accessTokenKey']!);
      }
    }
    await Delete();
    return null;
    */
  }
/*
  Future<dynamic> RefreshToken(String key) async {
    String refreshToken = '';
    String? mainDevice = await _tokenStorage.read(key: 'mainDeviceKey');
    if (key == _key['refreshTokenKey']!) {
      refreshToken = (await _tokenStorage.read(key: key))!;
      var refreshMessage = await TokenService().Fetch('''{
        "refreshToken": "$refreshToken"
        }''', 'patch', '/token/token-refresh', '', mainDevice);
      if (refreshMessage is Map<String,dynamic> && refreshMessage['code'] == 1) {
        await _tokenStorage.write(
            key: _key['refreshTokenKey']!, value: refreshMessage['refreshToken']);
        return await _tokenStorage.read(key: _key['refreshTokenKey']!);
      }
    }
    Delete();
    return null;
  }

 */
}