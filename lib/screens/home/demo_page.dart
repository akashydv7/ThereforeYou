import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shake/shake.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:first/services/auth.dart';
import 'package:first/services/networking.dart';
import 'package:first/screens/sos/tracking.dart';
import 'package:first/screens/location/location_page.dart';
import 'package:location/location.dart';
import 'package:background_sms/background_sms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/shared/loading.dart';
import 'package:first/shared/constants.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
final AuthService _auth = AuthService.instance();

// declared detector here
late ShakeDetector detector;
final CollectionReference appUsers = FirebaseFirestore.instance.collection('Users');
FirebaseAuth auth = FirebaseAuth.instance;
late AppUser? data;
final String uid = auth.currentUser!.uid;
Future<Object> getData() async {
        detector.startListening();
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

class Contacts extends StatelessWidget {
  String data;
  Contacts({super.key, required this.data});

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: black,
        child: SizedBox(
          width: 320,
          height: 60,
          child: Center(
            child: Row(
              children: <Widget>[
                SizedBox(width: 10,),
                Icon(
                  Icons.person,
                  size: 40,
                  color: white2,
                  ),
                SizedBox(width: 35,),
                Text(
                  data,
                  style: TextStyle(color: Colors.black, fontSize: 20)
                  )
                
              ],
            )
        ),
      ),
    )
    );
  }
}

bool loading = true;
class DemoPage extends StatefulWidget {
  
  @override
  _DemoPageState createState() => _DemoPageState();
  
}
void _sendSMS() async {
    String to1 = data!.contact1;
    String to2 = data!.contact2;
    String to3 = data!.contact3;
    Location _location = Location();
    LocationData ldata = await _location.getLocation();
    String message = '''
***** SOS *****
I AM IN TROUBLE, NEED YOUR HELP!
https://www.google.com/maps/search/?api=1&query=${ldata.latitude},${ldata.longitude}''';
      await BackgroundSms.sendMessage(phoneNumber: to1, message: message);
      await BackgroundSms.sendMessage(phoneNumber: to2, message: message);
      await BackgroundSms.sendMessage(phoneNumber: to3, message: message);
  }
_callNumber() async{
  const number = '7489035006'; //set the number here
  bool? res = await FlutterPhoneDirectCaller.callNumber(number);
}
class _DemoPageState extends State<DemoPage> {
  
  Tracking tracker = Tracking();
  String link = "none";
  @override
  void initState() {
    super.initState();
    showAlertDialog(BuildContext context) {
// set up the button
      Widget cancelButton = TextButton(
        child: Text("No"),
        onPressed:  () {Navigator.pop(context);},
      );
      Widget continueButton = TextButton(
        child: Text("Yes"),
        onPressed:  (()async {
              _sendSMS();
              _callNumber();
          }),
      );

      // set up the AlertDialog

      AlertDialog alert = AlertDialog(
        
        title: Text("Shake Detected",),
        content: Text("Do you need help?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // added stopping feature
          detector.stopListening();
          Future.delayed(Duration(seconds: 5), () {
            if (context!=null){
              Navigator.pop(context);
            }
          });
          
          detector.startListening();
          return StatefulBuilder(builder: (context, setState) {
              return alert;
          });
        },
      );
    }
    detector = ShakeDetector.waitForStart(
      onPhoneShake: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Shake!'), backgroundColor: Colors.amber[300]));
        // Do stuff on phone shake
        showAlertDialog(context);
      },
      minimumShakeCount: 3,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  
    // To close: detector.stopListening();
    // ShakeDetector.waitForStart() waits for user to call detector.startListening();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: getData(),
      builder: (context, snapshot) {
        return loading?Loading():Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            backgroundColor: white2,
            title: Center(child: Text('Therefor(e)You',)),
            centerTitle: true,
            actions: [
              IconButton(onPressed: (){
                Navigator.popAndPushNamed(context,'./viewProfile');
              },
              icon: Icon(Icons.settings))
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              LocationPage(),
              SizedBox(height: 20,),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                  color: white2,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height:10),
                      Text("EMERGENCY CONTACTS", style: TextStyle(color: white, fontSize: 15),),
                      SizedBox(height: 10,),
                      Contacts(data: data!.contact1),
                      SizedBox(height: 10,),
                      Contacts(data: data!.contact2),
                      SizedBox(height: 10,),
                      Contacts(data: data!.contact3),
                      SizedBox(height: 50,),
                      
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: red,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          elevation: 2,
                          fixedSize: Size(300, 80),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: (()async {
                          _callNumber();
                          _sendSMS();
                        }),
                        child: Text("S O S", style: TextStyle(color: white, fontSize: 40))
                      ),
                    
                    ],
                  ),
                ),
              ),
            ]
            
            ),
              
          
        );
      }
    );
  }
}