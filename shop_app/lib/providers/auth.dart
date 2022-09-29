import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  late String? _token;
  late DateTime? _expiryDate = DateTime.now();
  late String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId ?? null;
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  void autoLogout() {
    if (_authTimer == null) {
      final timeToExpire = _expiryDate!.difference(DateTime.now()).inSeconds;
      _authTimer = Timer(Duration(seconds: timeToExpire), logout);
    } else {
      _authTimer!.cancel();
      final timeToExpire = _expiryDate!.difference(DateTime.now()).inSeconds;
      _authTimer = Timer(Duration(seconds: timeToExpire), logout);
    }
  }

  Future<void> signup(String email, String password) async {
    const urlString =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDk9uXIAmLF1Olid6CdeBala8NVMVlwRoU";
    final url = Uri.parse(urlString);
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400 || responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      } else {
        _token = responseData['idToken'];
        _userId = responseData['localId'];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(responseData['expiresIn'])));
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString("userData")!) as Map<String, Object>;
    final expiryDate =
        DateTime.parse(extractedUserData['expiryDate'] as String);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'] as String;
    _userId = extractedUserData['userId'] as String;
    _expiryDate = expiryDate;
    autoLogout();
    return true;
  }

  Future<void> signin(String email, String password) async {
    const urlString =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDk9uXIAmLF1Olid6CdeBala8NVMVlwRoU";
    final url = Uri.parse(urlString);
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400 || responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      } else {
        _token = responseData['idToken'];
        _userId = responseData['localId'];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(responseData['expiresIn'])));
        autoLogout();
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        });
        prefs.setString("userData", userData);
      }
    } catch (error) {
      throw error;
    }
  }
}
