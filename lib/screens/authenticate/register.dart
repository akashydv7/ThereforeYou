import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/services/auth.dart';
import 'package:first/shared/constants.dart';
import 'package:first/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ required this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService.instance();
  final _formKey = GlobalKey<FormState>();
  String? error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: bgcolor,
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'email'),
                  validator: (val) => val!.isEmpty? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'password'),
                  obscureText: true,
                  validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 20.0),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    TextButton(

                      child: Text(' SIGN IN', style: TextStyle(fontSize: 15),),
                      onPressed: () => widget.toggleView(),
                    ),
                  ],
                ),
                
                SizedBox(height: 20.0),

                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    minimumSize: MaterialStateProperty.all<Size>(Size(400, 80)),
                  ),
                  child: Text("R E G I S T E R", style: TextStyle(color: Colors.white, fontSize: 20)),
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      setState(() => loading = true);
                      dynamic result;
                      try {
                        result = await _auth.registerWithEmailAndPassword(email, password);
                        
                      } on FirebaseException catch (e){
                        setState(() {
                          error = e.message;
                          if (error==null){
                            error = "Enter Correct Details";
                          }
                        });
                      }
                      if(result == null) {
                        setState(() {
                          loading = false;
                        });
                      }
                    }
                  }
                ),
                SizedBox(height: 12.0),
                Text(
                  error!,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}