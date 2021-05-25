import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool isAuth()  {
    return _token != null;
  }

  String get token {
    if (_token != null) return _token;
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signup(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signin(String email, String password) async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final token = userCredential.user;
      _token = await token.getIdToken();
      _userId = token.uid;
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            '36000',
          ),
        ),
      );
      _autoLogout();

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      print('Here');
      final userData = jsonEncode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );

      prefs.setString('userData', userData);
      print(jsonDecode(prefs.getString('userData')));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw 'Invalid password.';
      } else if (e.code == 'user-not-found') {
        throw 'Could not find user with that email.';
      } else {
        throw e.code;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = jsonDecode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() async {
    _token = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
