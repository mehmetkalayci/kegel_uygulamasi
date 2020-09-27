import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  FirebaseUser user;
  StreamSubscription userAuthStreamSubscription;

  final FirebaseAuth _auth = FirebaseAuth.instance;


  AuthProvider() {
    userAuthStreamSubscription = _auth.onAuthStateChanged.listen((newUser) {
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - ${newUser != null ? newUser.uid : null})}');
      user = newUser;
      notifyListeners();
    }, onError: (e) {
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $e');
    });
  }

  @override
  void dispose() {
    if (userAuthStreamSubscription != null) {
      userAuthStreamSubscription.cancel();
      userAuthStreamSubscription = null;
    }
    super.dispose();
  }

  bool get isAuthenticated => user != null;

  Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }

  Future<AuthResult> signInAnonymously() async {
    return _auth.signInAnonymously();
  }

  void signOut() {
    _auth.signOut();
  }
}