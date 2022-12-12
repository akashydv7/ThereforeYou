import 'package:first/services/auth.dart';
import 'package:first/shared/constants.dart';
import 'package:first/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ required this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService.instance();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: bgcolor,
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 200,),
                    
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 20.0),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(hintText: 'email'),
                              validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                              onChanged: (val) {
                                setState(() => email = val);
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              obscureText: true,
                              decoration: textInputDecoration.copyWith(hintText: 'password'),
                              validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                            SizedBox(height: 20.0),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                minimumSize: MaterialStateProperty.all<Size>(Size(400, 80)),
                              ),
                              onPressed: () async {
                                if(_formKey.currentState!.validate()){
                                  setState(() => loading = true);
                                  dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                                  if(result == null) {
                                    setState(() {
                                      loading = false;
                                      error = 'Could not sign in with those credentials';
                                    });
                                  }
                                }
                              },
                          
                              child: Text("S I G N  I N", style: TextStyle(color: Colors.white, fontSize: 20),
                            ),),
                            SizedBox(height: 12,),
                            Text(
                              error,
                              style: TextStyle(color: Colors.red, fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        TextButton(
                          child: Text(' SIGN UP'),
                          onPressed: () => widget.toggleView(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
