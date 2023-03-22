import 'dart:ffi';
import 'package:first/services/auth.dart';
import 'package:hypertrack_plugin/hypertrack.dart';
import 'package:first/services/networking.dart';
import 'package:background_sms/background_sms.dart';
const String publishableKey =
    'jeamuwzWUK0l6AC0RFbJsnYUPLgAsR_p9Y1CZeWwPkIR6Od36j8Hn5y-Kgxtx4EyjTARlCPy94BaKWNT5Ceykw';


class Tracking{
  late HyperTrack sdk;
  late String deviceId;
  late NetworkHelper helper;
  String result = '';
  bool isLink = false;
  bool isLoading = false;
  AuthService auth = AuthService.instance();

  @override
  Tracking() {
    initializeSdk();
  }

  Future<void> initializeSdk() async {
    sdk = await HyperTrack().initialize(publishableKey);
    deviceId = await sdk.getDeviceId();
    sdk.setDeviceName('USER NAME');
    helper = NetworkHelper(
      url: 'https://v3.api.hypertrack.com',
      basicauth: auth.basicauth,
      id: deviceId,
    );
    print(deviceId);
  }
  void _sendSMS(String message, List<String> recipents) async {
    String to = recipents[0];
    await BackgroundSms.sendMessage(phoneNumber: to, message: message);
  }
  Future<String> shareLink() async {
    List<Float> result;

    var data = await helper.getData();
    result = data['location']['geometry']['coordinates'];
    // Share.share(data['views']['share_url'], subject: 'USER NAME\'s Location');
    String maps = 'https://www.google.com/maps/search/?api=1&query=$result[0],$result[1]';
    _sendSMS(maps, ["8889383444"]);
  return maps;
  }

  void startTracking() async {
    result = '';
    var startTrack = await helper.startTracing();
    result = (startTrack['message']);
  }

  void endTracking() async {
    result = "";
    var endTrack = await helper.endTracing();
    result = (endTrack['message']);
  }

  Future<String> send_sos() async{
    startTracking();
    return shareLink();
  }
}