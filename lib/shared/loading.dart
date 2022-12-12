import 'package:first/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SpinKitChasingDots(
            color: Colors.black,
            size: 50.0,
          ),
    );
  }
}