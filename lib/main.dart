import 'package:first/screens/defense_training/videos_page.dart';
import 'package:first/screens/location/police_station_location.dart';
import 'package:first/screens/profile/edit_profile.dart';
import 'package:first/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:first/screens/home/demo_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first/screens/sos/sos.dart';
import 'package:first/screens/profile/view_profile.dart';
import 'package:home_widget/home_widget.dart';
import 'package:first/services/homeScreenWidgets/homeScreenWidget.dart';
import 'package:flutter_background/flutter_background.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "flutter_background example app",
      notificationText: "Background notification for keeping the example app running in the background",
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
    );
    await FlutterBackground.initialize(androidConfig: androidConfig);
    await FlutterBackground.enableBackgroundExecution();
    debugPrint(FlutterBackground.isBackgroundExecutionEnabled.toString());
    
  HomeWidget.registerBackgroundCallback(HomeScreenWidget.backgroundCallback);
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Therefor(e)You', 
      home: Wrapper(),
      initialRoute: '/',
      routes: {
        './home': (context) => DemoPage(),
        './sos' : (context) => HyperTrackQuickStart(),
        './viewProfile': (context) => ViewProfilePage(),
        './editProfile':(context) => SettingsForm(),
        './signIn':(context) => Wrapper(),
        './police':(context) => PoliceStationPage(),
        './defense':(context) => TrainingVideoPage(),
      }
    );
  }
}
