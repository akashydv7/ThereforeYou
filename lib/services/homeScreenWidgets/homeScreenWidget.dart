import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:first/services/utility.dart';

class HomeScreenWidget{
  static Future<void> backgroundCallback(Uri? uri) async {
    debugPrint(uri.toString());

    if (uri?.host == 'placecall') {
      debugPrint("Call works");
      AppUtility.fakeCall();
    }
    if (uri?.host == 'triggersos') {
      debugPrint("SOS works");
      // AppUtility.sendSMS("");
      AppUtility.callNumber();
    }
    
      // await HomeWidget.saveWidgetData<int>('_counter', counter);
      await HomeWidget.updateWidget(
          //this must the class name used in .Kt
          name: 'HomeScreenWidgetProvider',
          iOSName: 'HomeScreenWidgetProvider');
    }
  }
