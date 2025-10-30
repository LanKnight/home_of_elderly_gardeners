import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  bool get isLoggedIn => _user != null;

  void setUser(User u) {
    _user = u;
    notifyListeners();
  }

  void clear() {
    _user = null;
    notifyListeners();
  }
}
