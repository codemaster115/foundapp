import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:found_app/src/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:found_app/src/utils/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  // var MainUrl = 'https://found-app-nigeria.herokuapp.com/user';
  var MainUrl = 'http://192.168.1.55:8080/user';
  var AuthKey = Api.authKey;

  String _token;
  String _userId;
  String _userEmail;
  DateTime _expiryDate;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
  }

  String get userId {
    return _userId;
  }

  String get userEmail {
    return _userEmail;
  }

  Future<void> loginWithMail(String email, String password) async {
    try {
      String endpoint = 'login';
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      final url = '${MainUrl}/${endpoint}';

      final responce = await http.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode({
            'email': email,
            'password': password,
          }));

      final responceData = json.decode(responce.body);
      if (responce.statusCode == 200) {
        await sharedPreferences.setString('token', responceData['token']);
      } else {
        throw HttpException(responceData['message']);
      }
      _token = responceData['token'];
    } catch (e) {
      throw e;
    }
  }

  Future<void> loginWithGoogle(
      String googleId, String email, String image, String displayName) async {
    try {
      String endpoint = 'login_with_google';
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      final url = '${MainUrl}/${endpoint}';

      final responce = await http.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode({
            'googleId': googleId,
            'email': email,
            'image': image,
            'displayName': displayName,
          }));

      final responceData = json.decode(responce.body);
      if (responce.statusCode == 200) {
        await sharedPreferences.setString('token', responceData['token']);
      } else {
        throw HttpException(responceData['message']);
      }
      _token = responceData['token'];
    } catch (e) {
      throw e;
    }
  }

  Future<void> loginWithFacebook(String facebookId, String email, String image,
      String displayName, String firstName, String lastName) async {
    try {
      String endpoint = 'login_with_facebook';
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      final url = '${MainUrl}/${endpoint}';

      final responce = await http.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode({
            'facebookId': facebookId,
            'email': email,
            'image': image,
            'displayName': displayName,
            'firstName': firstName,
            'lastName': lastName
          }));

      final responceData = json.decode(responce.body);
      if (responce.statusCode == 200) {
        await sharedPreferences.setString('token', responceData['token']);
      } else {
        throw HttpException(responceData['message']);
      }
      _token = responceData['token'];
    } catch (e) {
      throw e;
    }
  }

  Future<bool> signupWithMail(String email, String password) async {
    try {
      String endpoint = 'signup';
      final url = '${MainUrl}/${endpoint}';

      final responce = await http.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode({
            'email': email,
            'password': password,
          }));

      final responceData = json.decode(responce.body);
      if (responce.statusCode == 200) {
        return true;
      } else {
        throw HttpException(responceData['message']);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      String endpoint = 'forgot_password';

      final url = '${MainUrl}/${endpoint}';

      final responce = await http.put(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode({
            'email': email,
          }));

      final responceData = json.decode(responce.body);
    } catch (e) {
      throw e;
    }
  }
}
