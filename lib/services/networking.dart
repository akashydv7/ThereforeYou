import 'package:flutter/material.dart';
import 'package:hypertrack_plugin/hypertrack.dart';
// import 'package:hypertrack_views_flutter/hypertrack_views_flutter.dart';
// import 'package:hypertrack_views_flutter/models/submodels/trip.dart';
// import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
const String publishableKey =
    'jeamuwzWUK0l6AC0RFbJsnYUPLgAsR_p9Y1CZeWwPkIR6Od36j8Hn5y-Kgxtx4EyjTARlCPy94BaKWNT5Ceykw';

class NetworkHelper{
  late String url;
  late String id;
  late String basicauth;

  NetworkHelper({required String this.id, required String this.url, required String this.basicauth});

  Future startTracing() async {
  http.Response response = await http.post(Uri.parse('$url/devices/$id/start'),
      body: null, headers: {'Authorization': basicauth});
  if (response.statusCode == 200) {
      String data = response.body;
      debugPrint("Tracing start");
      debugPrint(data);
      
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
  
  

  Future getData() async {
    http.Response response =
        await http.get(Uri.parse('$url/devices/$id'), headers: {'Authorization': basicauth});
        
    if (response.statusCode == 200) {
      String data = response.body;
      debugPrint("Custom Data");
      debugPrint(data);
      // debugPrint(jsonDecode(data));
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  //   http.Response tracker =
  //       await http.get(Uri.parse('$url/devices/$id/history/2022-11-18'), headers: {'Authorization': basicauth});
  //   if (tracker.statusCode == 200) {
  //     String data = tracker.body;
  //     debugPrint("Custom Data");
  //     // debugPrint(data);
  //     // debugPrint(jsonDecode(data));
  //     dynamic jdata = jsonDecode(data);
  //     debugPrint(jdata);
  //     return data;
  //   } else {
  //     print(tracker.statusCode);
  //   }
    // http.Response response =
    //     await http.get(Uri.parse('$url/devices/$id'), headers: {'Authorization': basicauth});
  //   dynamic payload = jsonEncode(
  //     {"device_id": id, 
  //      "destination":{
  //       "geometry":{ 
  //         "type": "Point",
  //         "coordinates": [
  //           22.706411393093653, 75.90619115532594
  //         ],
  //       },
  //       "generate_estimate": true,
  //      },
  //     }
  //   );
  //   http.Response response = await http.post(
  //   Uri.parse('https://v3.api.hypertrack.com/trips'),
  //   headers: {
  //     'Content-Type': 'application/json; charset=UTF-8',
  //     'Authorization': basicauth,
  //   },
  //   body: "$payload",
  // );
  //   if (response.statusCode == 201) {
  //     String data = response.body;
  //     debugPrint("Custom Data");
  //     debugPrint(data);
  //     // debugPrint(jsonDecode(data));
  //     return jsonDecode(data);
  //   } else {
  //     debugPrint("No Response");
      
  //     debugPrint(response.body);
  //     print(response.statusCode);
  //   }
  
  // return Null;
  }

  Future endTracing() async {
    http.Response response = await http.post(Uri.parse('$url/devices/$id/stop'),
        body: null, headers: {'Authorization': basicauth});
    if (response.statusCode == 200) {
      String data = response.body;

      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}