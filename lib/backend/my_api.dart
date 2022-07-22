// @dart=2.12
// ignore_for_file: unused_import, import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _url = 'https://ana57357.com/api/';

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    http.Response response =
        await http.get(Uri.parse(fullUrl), headers: _setHeaders());

    try {
      if (response.statusCode == 200) {
        return response;
      } else {
        return 'failed';
      }
    } catch (e) {
      print(e);
    }
  }

  //  final String _url = 'http://10.0.2.2:8000/api/';

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    http.Response response = await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());

    return response;
  }

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
}
