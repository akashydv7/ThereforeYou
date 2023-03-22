import 'package:first/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:first/services/database.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated, Registered }

class AuthService with ChangeNotifier {

  FirebaseAuth _auth = FirebaseAuth.instance;
  // FirebaseAuth _auth;
  late User _user;
  late String basicauth;
  Status _status = Status.Uninitialized;
  
  Status get status => _status;
  User get user => _user;
  AuthService.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen((User? user){
      if (user == null) {
      _status = Status.Unauthenticated;
        print('User is currently signed out!');
      } else {
        _user = user;
        _status = Status.Authenticated;
        print('User is signed in!');
      }
      notifyListeners();
    });
  }

  // create UserModel obj based on firebase UserModel
  UserModel? _userFromFirebaseUser(User? user){
    return UserModel(uid: user!.uid);
  }

  // auth change user stream
  // Stream<UserModel?> get user {
  //   return _auth
  //   .authStateChanges()
  //   .map((User? user) => _userFromFirebaseUser(user!));
  //   // return _auth.authStateChanges().map(_userFromFirebaseUser);
  // }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      
      _status = Status.Authenticating;
      notifyListeners();
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      basicauth = 'Basic '+base64Encode(utf8.encode('$user.userid:$password'));
      return user;
    } catch (error) {
      
      _status = Status.Unauthenticated;
      notifyListeners();
      print(error.toString());
      return null;
    } 
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      basicauth = 'Basic '+base64Encode(utf8.encode('$user.userid:$password'));
      _status = Status.Registered;
      notifyListeners();
      await DatabaseService(uid: user!.uid).updateUserData('name', "xx", "xx", "xx", email, _auth.currentUser!.uid);
      return _userFromFirebaseUser(user);
    } catch (error) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(error.toString());
      return null;
    } 
  }

  // sign out
  Future signOut() async {
    try {
      await _auth.signOut();
      _status = Status.Unauthenticated;
      notifyListeners();
      return Future.delayed(Duration.zero);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

}