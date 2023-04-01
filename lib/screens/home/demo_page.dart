import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shake/shake.dart';
import 'package:first/services/auth.dart';
// import 'package:first/screens/sos/tracking.dart';
import 'package:first/screens/location/location_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/shared/loading.dart';
import 'package:first/shared/constants.dart';
import 'package:first/screens/notification/notifications.dart';
import 'package:first/services/utility.dart';
import 'package:home_widget/home_widget.dart';

final AuthService _auth = AuthService.instance();

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
  String data, name;
  Contacts({super.key, required this.data, required this.name});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Center(
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: black,
        child: Container(
          width: screenSize.width*0.7,
          height: screenSize.height*0.07,
          child: Center(
            child: Row(
              children: <Widget>[
                SizedBox(width: 10,),
                Icon(
                  Icons.person,
                  size: screenSize.height*0.04,
                  color: gunmetal,
                  ),
                SizedBox(width: 35,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(color: gunmetal, fontSize: 20)
                      ),
                    Text(
                      data,
                      style: TextStyle(color: gunmetal, fontSize: 20)
                      ),
                  ],
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

class _DemoPageState extends State<DemoPage> {
  
  // Tracking tracker = Tracking();
  String link = "none";
  @override
  void initState() {
    super.initState();
    HomeWidget.widgetClicked.listen((Uri? uri) => AppUtility.fakeCall());
    showAlertDialog(BuildContext context) {
// set up the button
      Widget cancelButton = TextButton(
        child: Text("No"),
        onPressed:  () {Navigator.pop(context);},
      );
      Widget continueButton = TextButton(
        child: Text("Yes"),
        onPressed:  (()async {
              AppUtility.sendSMS("data");
              AppUtility.callNumber();
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
  
  // Notification Bar
  // NotificationService.initializeNotification();
  // NotificationService.showNotificaion();

  
  }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double buttonSize = screenSize.width * 0.3;

    return FutureBuilder<Object>(
      future: getData(),
      builder: (context, snapshot) {
        return loading?Loading():WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            backgroundColor: white2,
            appBar: AppBar(
              backgroundColor: gunmetal,
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
                // SizedBox(height: 10,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // SizedBox(height:10),
                      SizedBox(height : screenSize.width*0.02),
                      Text("EMERGENCY CONTACTS", style: TextStyle(color: black, fontSize: 15),),
                      // SizedBox(height: 10,),
                      SizedBox(height : screenSize.width*0.02),
                      Contacts(data: data!.contact1, name: data!.contactName1,),
                      // SizedBox(height: 10,),
                      SizedBox(height : screenSize.width*0.03),
                      Contacts(data: data!.contact2, name: data!.contactName2),
                      // SizedBox(height: 10,),
                      SizedBox(height : screenSize.width*0.03),
                      Contacts(data: data!.contact3, name: data!.contactName3,),
                      SizedBox(height : screenSize.width*0.03),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                style: mainButtonStyle(buttonSize, red),
                                onPressed: (()async {
                                  AppUtility.callNumber();
                                  AppUtility.sendSMS("data");
                                }),
                                child: Text("S O S", style: TextStyle(color: white, fontSize: 20))
                              ),
                              TextButton(
                            style: mainButtonStyle(buttonSize, green),
                            onPressed: (()async {
                              // AppUtility.fakeCall();
                              Navigator.pushNamed(context, "./police",);
                            }),
                            child: Text("Take me to police", style: TextStyle(color: white, fontSize: 20))
                          ),
        
                          TextButton(
                            style: mainButtonStyle(buttonSize, blue),
                            onPressed: (()async {
                              AppUtility.fakeCall();
                            }),
                            child: Text("Fake Call", style: TextStyle(color: white, fontSize: 20))
                          ),
                          ],
                        ),
                        SizedBox(height : screenSize.width*0.05),
                        bottomBar(context),
                          
                        ],
                      ),
                    ],
                  ),
                ),
              ]
              
              ),
                
            
          ),
        );
      }
    );
  }
}