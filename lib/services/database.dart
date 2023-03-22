
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ required this.uid });

  // collection reference
  final CollectionReference appUsers = FirebaseFirestore.instance.collection('Users');

  Future<void> updateUserData(String name, String contact1, String contact2, String contact3, String email, String uid) async {
    return await appUsers.doc(uid).set({
      'name': name,
      'contact1':contact1,
      'contact2':contact2,
      'contact3':contact3,
      'email':email,
      'uid':uid,
    });
  }

  Future<AppUser?> getData() async {
         final ref = appUsers.doc(uid).withConverter(
          fromFirestore: AppUser.fromFirestore,
          toFirestore: (AppUser user, _) => user.toFirestore(),
        );
    final docSnap = await ref.get();
    final user = docSnap.data(); 
    debugPrint("FETCHING DATA");
    debugPrint(user.toString());
    // Convert to City object
    if (user != null) {
      return user;
    } else {
      print("No such document.");
      return AppUser(name: "-----", contact3: "-----", contact2: "-----", contact1: "-----", email: "-----");
    }
  }

  // Future<Object> getInfor() async{

  // }

 
}

class AppUser{
  late final String name;
  late final String contact1;
  late final String contact2;
  late final String contact3;
  late final String email;
  AppUser({
    required this.name,
    required this.contact1,
    required this.contact2,
    required this.contact3,
    required this.email,
  });

  factory AppUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return AppUser(
      name: data?['name'],
      contact1: data?['contact1'],
      contact2: data?['contact2'],
      contact3: data?['contact3'],
      email: data?["email"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (contact1 != null) "contact1": contact1,
      if (contact2 != null) "contact2": contact2,
      if (contact3 != null) "contact3": contact3,
      if (email != null) "email": email,
    };
  }
}