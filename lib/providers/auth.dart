import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;
  Timer _authTimer;

  String get userId {
    return _userId;
  }

  bool get isAuthenticated {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) return _token;
    return null;
  }

  Future<void> _authenticate(
      String _email, String _pswrd, String _urlSegnment) async {
    final _url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$_urlSegnment?key=AIzaSyAH4YNqbTADZNW2eGMOJTKLhS7qJTmfwF4');
    try {
      final _response = await http.post(_url,
          body: json.encode({
            'email': _email,
            'password': _pswrd,
            'returnSecureToken': true,
          }));
      final _responseData = json.decode(_response.body);
      if (_responseData.containsKey("error")) {
        throw HttpException(_responseData['error']['message']);
      }
      _token = _responseData['idToken'];
      _userId = _responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(_responseData['expiresIn']),
        ),
      );
      autoLogout();
      notifyListeners();
      final _prefs = await SharedPreferences.getInstance();
      final _userData = json.encode({
        'token':_token,
        'userId':_userId,
        'expiryDate':_expiryDate.toIso8601String(),
      });
      _prefs.setString('userData', _userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String _email, String _pswrd) async {
    return _authenticate(_email, _pswrd, 'signUp');
  }

  Future<void> login(String _email, String _pswrd) async {
    return _authenticate(_email, _pswrd, 'signInWithPassword');
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if(_authTimer!=null){
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final _prefs = await SharedPreferences.getInstance();
    // _prefs.remove('userData');
    _prefs.clear();
  }

  Future<bool> tryAutoLogin() async {
    final _prefs = await SharedPreferences.getInstance();
    if(!_prefs.containsKey('userData'))
      return false;
    final _extractedUserData = json.decode(_prefs.getString("userData")) as Map<String,Object>;
    final expiryDate = DateTime.parse(_extractedUserData['expiryDate']);
    if(expiryDate.isBefore(DateTime.now())) return false;
    _token = _extractedUserData['token'];
    _userId = _extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }

  void autoLogout(){
    if(_authTimer!=null){
      _authTimer.cancel();
    }
    var _timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds:_timeToExpiry),logout);
  }
}
