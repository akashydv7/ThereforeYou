// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   @override
//   void initState() {
//     super.initState();

//     // Initialize notification plugin
//     var initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettingsIOS = DarwinInitializationSettings();
//     var initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     // Show notification bar
//     _showNotification();
//   }

//   void _showNotification() async {
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'your channel id', 'your channel name',
//         importance: Importance.max, priority: Priority.high);
//     var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
//     var platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: iOSPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(
//         0,
//         'Notification Title',
//         'Notification Message',
//         platformChannelSpecifics,
//         payload: 'Default_Sound',
//         // Add two action buttons
//         actions: <NotificationAction>[
//           NotificationAction(
//             'action1',
//             'Action 1',
//           ),
//           NotificationAction(
//             'action2',
//             'Action 2',
//           ),
//         ]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notification Bar'),
//       ),
//       body: Center(
//         child: Text('This is the main content of the app.'),
//       ),
//     );
//   }
// }

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService{
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null, 
      [
        NotificationChannel(channelKey: "high_importance", channelName: "SOS Notification", channelDescription: "Notification Channel for SOS actions")
      ],
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async{
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      }
    );

    await AwesomeNotifications().setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    final payload = receivedAction.payload ?? {};
    debugPrint(payload.toString());
    if (payload["tirgger_sos"] == "true"){
      debugPrint("Clicked SOS from NOtificatoin");
    }
    if (payload["place_fake_call"] == "true"){
      debugPrint("Called from NOtificatoin");
    }
  }


  static Future<void>? showNotificaion(){
    AwesomeNotifications().createNotification(
      content: NotificationContent( //simgple notification
          id: 123,
          channelKey: 'high_importance', //set configuration wuth key "basic"
          title: 'Terefor(e)You',
          body: 'easy access',
          payload: {"name":"SOS"},
          autoDismissible: false,
      ),

      actionButtons: [
          NotificationActionButton(
            key: "trigger_sos", 
            label: "SOS",
          ),

          NotificationActionButton(
            key: "place_fake_call", 
            label: "Fake call",
          )
      ]
    );
  }


}