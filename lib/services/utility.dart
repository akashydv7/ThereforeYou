import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/screens/home/demo_page.dart';
import 'package:first/services/auth.dart';
import 'package:first/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:location/location.dart';
import 'package:background_sms/background_sms.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';
class AppUtility {
  static void sendSMS(data) async {
    AppUser? data = await getData();
    String to1 = data!.contact1;
    String to2 = data!.contact2;
    String to3 = data!.contact3;
    Location _location = Location();
    _location.enableBackgroundMode(enable: true);
    LocationData ldata = await _location.getLocation();
    String message = '''
  ***** SOS *****
  I AM IN TROUBLE, NEED YOUR HELP!
  https://www.google.com/maps/search/?api=1&query=${ldata.latitude},${ldata.longitude}''';
        await BackgroundSms.sendMessage(phoneNumber: to1, message: message);
        await BackgroundSms.sendMessage(phoneNumber: to2, message: message);
        await BackgroundSms.sendMessage(phoneNumber: to3, message: message);
  }
  
  static void callNumber() async{
    const number = '8889383444'; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }
  
  static Future<void> showCallkitIncoming(String uuid) async {
    
    AppUser? data = await getData();
    final params = CallKitParams(
      id: uuid,
      nameCaller: data!.fakeContactName,
      appName: 'Callkit',
      // avatar: 'https://i.pravatar.cc/100',
      handle: data!.fakeContact,
      type: 0,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      textMissedCall: 'Missed call',
      textCallback: 'Call back',
      extra: <String, dynamic>{'userId': '1a2b3c4d'},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        isShowCallback: true,
        isShowMissedCallNotification: true,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#8d918d',
        // backgroundUrl: 'assets/test.png',
        actionColor: '#4CAF50',
      ),
      ios: IOSParams(
        iconName: 'CallKitLogo',
        handleType: '',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0, 
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }
 
  static Future<void> fakeCall() async {
    debugPrint("FakeCall method called from app utility");
    late final Uuid _uuid = Uuid();
    await showCallkitIncoming(_uuid.toString());
  }

  static Future<AppUser?> getData() async {
    await Firebase.initializeApp();
    final AuthService _auth = AuthService.instance();
    final CollectionReference appUsers = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    final String uid = auth.currentUser!.uid;
    final ref = appUsers.doc(uid).withConverter(
      fromFirestore: AppUser.fromFirestore,
      toFirestore: (AppUser user, _) => user.toFirestore(),
    );
    
    final docSnap = await ref.get();
    final user = docSnap.data();
    debugPrint("FETCHING DATA");
    return user;
  }
}