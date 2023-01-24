import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = ' AIzaSyDwAWjiwPZYeQd4fsVXiSo8LP6SvlCDQ6g';
  final storage = FlutterSecureStorage();

  Uri getHeadersRequest(String type) {
    return Uri.https(_baseUrl, '/v1/accounts:$type', {
      'key': _firebaseToken
    });
  }

  Future<String?> singIn(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final response = await http.post(getHeadersRequest('signUp'), body: json.encode(authData));
    final Map<String, dynamic> decodedResponse = json.decode(response.body);
    
    if(decodedResponse.containsKey('idToken')) {
      await storage.write(key: 'token', value: decodedResponse['idToken']);
      return null;
    } else {
      return decodedResponse['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final response = await http.post(getHeadersRequest('signInWithPassword'), body: json.encode(authData));
    final Map<String, dynamic> decodedResponse = json.decode(response.body);
    
    if(decodedResponse.containsKey('idToken')) {
      await storage.write(key: 'token', value: decodedResponse['idToken']);
      return null;
    } else {
      return decodedResponse['error']['message'];
    }
  }

  Future logout () async {
    await storage.delete(key: 'token');
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

}
