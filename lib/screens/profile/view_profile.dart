
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first/services/database.dart';
import 'package:first/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/shared/loading.dart';

bool loading = true;
final CollectionReference appUsers = FirebaseFirestore.instance.collection('Users');

FirebaseAuth _auth = FirebaseAuth.instance;
late AppUser? data;
final String uid = _auth.currentUser!.uid;
Future<Object> getData() async {
        final ref = appUsers.doc(uid).withConverter(
        fromFirestore: AppUser.fromFirestore,
        toFirestore: (AppUser user, _) => user.toFirestore(),
      );
  final docSnap = await ref.get();
  final user = docSnap.data(); 
  data = user;
  debugPrint("FETCHING DATA");
  loading = false;
  debugPrint(user.toString());
  // Convert to City object
  if (user != null) {
    return user;
  } else {
    print("No such document.");
    return Null;
  }
}
class DisplayText extends StatelessWidget{
  String data;
  DisplayText(this.data);
  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        color: black,
        fontSize: 25

      ),
      );
  }
}

class ViewProfilePage extends StatefulWidget {
  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: getData(),
      builder: (context, snapshot) {
        return loading?Loading():Scaffold(
              appBar: AppBar(
                backgroundColor: white,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: black,
                  ),
                  onPressed: () {
                    Navigator.popAndPushNamed(context, './home');
                  },
                ),
                
              ),
              body: Container(
                padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                color: white,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: ListView(
                    children: [
                      Center(
                        child: Container(
                          child: Text(
                            "YOUR PROFILE",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              child: Icon(Icons.person, size: 50, color: black,),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 4,
                                      color: Theme.of(context).scaffoldBackgroundColor),
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        color: Colors.black.withOpacity(0.1),
                                        offset: Offset(0, 10))
                                  ],
                                  shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 35,
                          ),
                      // Text(data["name"]!),
                      DisplayText(data!.name),
                      SizedBox(
                        height: 35,
                      ),
                      // Text(data["email"]!),
                      DisplayText(data!.email),
                      SizedBox(
                        height: 35,
                      ),
                      // Text(data["contact1"]!),
                      DisplayText(data!.contact1),
                      SizedBox(
                        height: 35,
                      ),
                      // Text(data["contact2"]!),
                      DisplayText(data!.contact2),
                      SizedBox(
                        height: 35,
                      ),
                      // Text(data["contact3"]!),
                      DisplayText(data!.contact3),
                      SizedBox(
                        height: 35,
                      ),
                        ]),
                      Expanded(

                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: black,
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    elevation: 2,
                                    fixedSize: Size(170, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),),
                                  onPressed: () async{
                                    await _auth.signOut();
                                    Navigator.popAndPushNamed(context, './signIn');
                                  },
                                  child: Text("L O G O U T",
                                      style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 2.2,
                                          color: white)),
                                ),
                                ElevatedButton(
                                  onPressed: () {Navigator.popAndPushNamed(context, './editProfile');},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: black,
                                    padding: EdgeInsets.symmetric(horizontal: 50),
                                    elevation: 2,
                                    fixedSize: Size(170, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                  ),
                                  
                                  child: Text(
                                    "E D I T",
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 2.2,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
      }
    );
  }
}