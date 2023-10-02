import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../models/HDUserModel.dart';

class UserProvider extends ChangeNotifier {
  HDUserModel? _currentUser;

  HDUserModel? get currentUser => _currentUser;

  static final UserProvider _instance = UserProvider._internal();

  factory UserProvider() {
    return _instance;
  }

  UserProvider._internal();

  void setCurrentUser(HDUserModel user) {
    _currentUser = user;
  }
  void logout() {
    _currentUser = null;
  }
}