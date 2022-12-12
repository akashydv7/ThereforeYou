import 'package:first/models/user.dart';
import 'package:first/screens/authenticate/authenticate.dart';
import 'package:first/screens/home/demo_page.dart';
import 'package:first/screens/home/home.dart';
import 'package:first/screens/profile/edit_profile.dart';
import 'package:first/services/auth.dart';
import 'package:first/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService.instance(),
      child: Consumer(
        builder: (context, AuthService user, _) {
          switch (user.status) {
            case Status.Uninitialized:
              return Authenticate();
            case Status.Unauthenticated:
              return Authenticate();
            case Status.Authenticating:
              return Loading();
            case Status.Authenticated:
              return DemoPage();
            case Status.Registered:
              return SettingsForm();
          }
        },
      ),
    );
  }
}