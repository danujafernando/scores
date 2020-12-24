import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/notification_text.dart';

enum Status{ Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier{

  Status _status  = Status.Uninitialized;
  String _token;

  final String api = "http://tower3.test/api/auth";

  void login(data) async{
     var url = api + '/login';
     var res = await http.post(
        url,
        body: jsonEncode(data),
        headers: _setHeaders()
     );
     var response = jsonDecode(res.body);
     print(response);
  }

  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  
}