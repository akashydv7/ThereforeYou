import 'dart:ffi';

import 'package:background_sms/background_sms.dart';

import 'package:flutter/services.dart';
import 'package:first/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:hypertrack_plugin/hypertrack.dart';
import 'package:first/services/networking.dart';
import 'package:share/share.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'dart:convert';
//TODO Add your publishablekey here
const String publishableKey ='jeamuwzWUK0l6AC0RFbJsnYUPLgAsR_p9Y1CZeWwPkIR6Od36j8Hn5y-Kgxtx4EyjTARlCPy94BaKWNT5Ceykw';

class HyperTrackQuickStart extends StatefulWidget {

  @override
  _HyperTrackQuickStartState createState() => _HyperTrackQuickStartState();
}

class _HyperTrackQuickStartState extends State<HyperTrackQuickStart> {
  late HyperTrack sdk;
  late String deviceId;
  String result = '';
  bool isLoading = false;
  bool isLink = false;
  late NetworkHelper helper;
  String acc = "2sVQjr5I3FMb2wO2Nr8qIQMVsP0";
  String skey = "uVvwjbsctqAFYIpJKe6K4vzTe0REwBRobk2L2URKtNHNzhjgaBPsGw";
  // String basicauth;
  AuthService auth = AuthService.instance();
  @override
  void initState() {
    super.initState();
    initializeSdk();
  }
  void _sendSMS(String message, List<String> recipents) async {

  String to = recipents[0];
  await BackgroundSms.sendMessage(phoneNumber: to, message: message);
  
  }
  static const platform = const MethodChannel('sendSms');

  // Future<Null> sendSms(String phone, String msg)async {
  //   debugPrint("SendSMS");
  //   try {
  //     final String result = await platform.invokeMethod('send',<String,dynamic>{"phone":"+91$phone","msg": msg}); //Replace a 'X' with 10 digit phone number
  //     print(result);
  //   } on PlatformException catch (e) {
  //     print(e.toString());
  //   }
  // }
  Future<void> initializeSdk() async {
    sdk = await HyperTrack().initialize(publishableKey);
    deviceId = await sdk.getDeviceId();
    sdk.setDeviceName('akash');
    helper = NetworkHelper(
      url: 'https://v3.api.hypertrack.com',
      basicauth:
          'Basic '+base64Encode(utf8.encode('$acc:$skey')),
      id: deviceId,
    );
    print(deviceId);
  }

    shareLink() async {
    setState(() {
      isLoading = true;
    });
    var data = await helper.getData();
    late List<dynamic> result;
    setState(() {
      // result = data["views"]['share_url'];
      
      result = data['location']['geometry']['coordinates'];
      isLink = true;
      isLoading = false;
    });
    
    // Share.share(data['views']['share_url'], subject: 'USER NAME\'s Location');
    String maps = 'https://www.google.com/maps/search/?api=1&query=${result[1]},${result[0]}';
    // Share.share(maps, subject: 'akash\'s Location');
    
    _sendSMS(maps, ["8889383444"]);
    // sendSms("8889383444", maps);
  }

  void startTracking() async {
    setState(() {
      isLoading = true;
      result = '';
    });
    var startTrack = await helper.startTracing();
    setState(() {
      result = (startTrack['message']);
      isLink = false;
      isLoading = false;
    });
  }

  void endTracking() async {
    setState(() {
      isLoading = true;
      result = '';
    });
    var endTrack = await helper.endTracing();
    setState(() {
      result = (endTrack['message']);
      isLink = false;
      isLoading = false;
    });
  } 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 0.0,
            width: double.infinity,
          ),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoading ? CircularProgressIndicator() : Text(''),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    result,
                    style: TextStyle(
                        color: isLink ? Colors.blue[900] : Colors.red[900],
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),               
              ],
            ),
          ),
          TextButton(
            child: Text(
              'Strat Tracking my Location',
            ),
            onPressed: startTracking,
          ),
          TextButton(
            child: Text('Share my Location'),
            onPressed: shareLink
          ),
          TextButton(
            child: Text('End Tracking my Location'),
            onPressed: endTracking,
          ),
          Text(result==""?"None":result),
        ],

      ),
    ));
  }
}