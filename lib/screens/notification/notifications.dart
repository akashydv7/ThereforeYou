import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  String notificationTitle = "My Notification Title";
  String notificationContent = "This is my notification content";
  int notificationId = 0;

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    // final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid); //, iOS: initializationSettingsIOS
    await flutterLocalNotificationsPlugin?.initialize(initializationSettings, onSelectNotification: selectNotification);
    updateNotification();
  }

  Future<void> updateNotification() async {
    final detailsAndroid = AndroidNotificationDetails(
        'my_channel_id', 'My Channel', 'Description', importance: Importance.high, priority: Priority.high, showWhen: false);
    final detailsIOS = IOSNotificationDetails();
    final details = NotificationDetails(android: detailsAndroid, iOS: detailsIOS);

    await flutterLocalNotificationsPlugin.show(
        notificationId,
        notificationTitle,
        notificationContent,
        details,
        payload: 'Custom_Sound',
        ongoing: true,
        autoCancel: false);

    await FlutterStatusbarManager.setStyle(StatusBarStyle.LIGHT_CONTENT);
    await FlutterStatusbarManager.setColor(Colors.transparent, animated: true);
  }

  Future<void> selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  Future<void> onButtonPressed() async {
    debugPrint('Button Pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Page'),
      ),
      body: Center(
        child: Text('Press the button on the notification to trigger the onPressed function'),
      ),
    );
  }
}
