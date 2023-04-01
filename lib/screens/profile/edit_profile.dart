
import 'package:first/models/user.dart';
import 'package:first/services/database.dart';
import 'package:first/shared/constants.dart';
import 'package:first/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:background_sms/background_sms.dart';


final CollectionReference appUsers = FirebaseFirestore.instance.collection('Users');
bool loading = true;
FirebaseAuth _auth = FirebaseAuth.instance;
late AppUser? data;
final String uid = _auth.currentUser!.uid;
 Future<void> updateUserData(String? name, String? contact1,String? contact2, String? contact3, String? contactName1, String? contactName2, String? contactName3, String? email, String uid, String? fakeContactName, String? fakeContact) async {
    String msg = "You have been added as emergency contact by $name ";
    await BackgroundSms.sendMessage(phoneNumber: contact1!, message: msg);
    await BackgroundSms.sendMessage(phoneNumber: contact2!, message: msg);
    await BackgroundSms.sendMessage(phoneNumber: contact3!, message: msg);


    return await appUsers.doc(uid).set({
      'name': name,
      'contact1':contact1,
      'contact2':contact2,
      'contact3':contact3,
      'email':email,
      'uid':uid,
      'contactName1':contactName1,
      'contactName2':contactName2,
      'contactName3':contactName3,
      'fakeContactName':fakeContactName,
      'fakeContact':fakeContact
    });
  }
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
  // Convert to City object
  if (user != null) {
    return user;
  } else {
    print("No such document.");
    return Null;
  }
}


class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();

  // form values
  String? _currentName;
  String? _email;
  String? _contact1;
  String? _contact2;
  String? _contact3;
  String? _contactName1;
  String? _contactName2;
  String? _contactName3;
  String? _fakeContactName;
  String? _fakeContact;

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<Object>(
      future: getData(),
      builder: (context, snapshot) {
        return loading?Loading():Scaffold(
          backgroundColor: white2,
                body: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 100,),
                              Text(
                                'UPDATE YOUR PROFILE',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                initialValue: data!.name,
                                decoration: textInputDecoration,
                                validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                                onChanged: (val) => setState(() => _currentName = val),
                              ),
                              SizedBox(height: 10.0),
                              TextFormField(
                                initialValue: data!.email,
                                decoration: textInputDecoration,
                                validator: (val) => val!.isEmpty ? 'Please enter a vaild email' : null,
                                onChanged: (val) => setState(() => _email = val),
                              ),
                            ],
                          ),
                          Container(
                            child: Column(
                              children: [
                                SizedBox(height:20),
                                Text(
                                  "UPDATE EMERGENCY CONTACTS",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                SizedBox(height: 20,),
                                TextFormField(
                                  initialValue: data!.contactName1,
                                  decoration: textInputDecoration,
                                  validator: (val) => val!.isEmpty ? 'Please enter vaild contact name' : null,
                                  onChanged: (val) => setState(() => _contactName1 = val),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  initialValue: data!.contact1,
                                  decoration: textInputDecoration,
                                  validator: (val) => val!.length < 10 ? 'Please enter vaild contact' : null,
                                  onChanged: (val) => setState(() => _contact1 = val),
                                ),
                                SizedBox(height: 20,),
                                TextFormField(
                                  initialValue: data!.contactName2,
                                  decoration: textInputDecoration,
                                  validator: (val) => val!.isEmpty ? 'Please enter vaild contact name' : null,
                                  onChanged: (val) => setState(() => _contactName2 = val),
                                ),
                                SizedBox(height: 10.0),
                                TextFormField(
                                  initialValue: data!.contact2,
                                  decoration: textInputDecoration,
                                  validator: (val) => val!.length < 10 ? 'Please enter vaild contact' : null,
                                  onChanged: (val) => setState(() => _contact2 = val),
                                ),
                                SizedBox(height: 20,),
                                TextFormField(
                                  initialValue: data!.contactName3,
                                  decoration: textInputDecoration,
                                  validator: (val) => val!.isEmpty ? 'Please enter vaild contact name' : null,
                                  onChanged: (val) => setState(() => _contactName3 = val),
                                ),
                                SizedBox(height: 10.0),
                                TextFormField(
                                  initialValue: data!.contact3,
                                  decoration: textInputDecoration,
                                  validator: (val) => val!.length < 10 ? 'Please enter vaild contact' : null,
                                  onChanged: (val) => setState(() => _contact3 = val),
                                ),
                                SizedBox(height: 10.0),  
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                SizedBox(height:20),
                                Text(
                                  "FAKE CALL DETAILS",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                SizedBox(height: 20,),
                                TextFormField(
                                  initialValue: data!.fakeContactName,
                                  decoration: textInputDecoration,
                                  validator: (val) => val!.isEmpty ? 'Please enter vaild contact name' : null,
                                  onChanged: (val) => setState(() => _fakeContactName = val),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  initialValue: data!.fakeContact,
                                  decoration: textInputDecoration,
                                  validator: (val) => val!.length < 10 ? 'Please enter vaild contact' : null,
                                  onChanged: (val) => setState(() => _fakeContact = val),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                
                              SizedBox(height: 20.0),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: black,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  elevation: 2,
                                  fixedSize: Size(170, 50),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),),
                                child: Text(
                                  'U P D A T E',
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                onPressed: () async {
                                  debugPrint(_currentName);
                                  debugPrint(_contact1);
                                  debugPrint(_email);
                                  if(_formKey.currentState!.validate()){
                                    await updateUserData(
                                      _currentName==null?data!.name:_currentName,
                                      _contact1==null?data!.contact1:_contact1,
                                      _contact2==null?data!.contact2:_contact2,
                                      _contact3==null?data!.contact3:_contact3,
                                      _contactName1==null?data!.contactName1:_contactName1,
                                      _contactName2==null?data!.contactName2:_contactName2,
                                      _contactName3==null?data!.contactName3:_contactName3,
                                      _email==null?data!.email:_email,
                                      uid,
                                      _fakeContactName==null?data!.fakeContactName:_fakeContactName,
                                      _fakeContact==null?data!.fakeContact:_fakeContact,
                                    );
                                    Navigator.popAndPushNamed(context, './viewProfile');
                                  }
                                }
                              ),
                              SizedBox(height:20),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: black,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  elevation: 2,
                                  fixedSize: Size(170, 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),),
                                onPressed: () {Navigator.popAndPushNamed(context, './home');},
                                child: Text("C A N C E L",
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 2.2,
                                        color: white)),
                              ),
                              SizedBox(height:20),
                              ]),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        );
      }
    );
  }
}