import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
);

final bgcolor = Colors.grey[300];
// final white2 = Colors.teal[100];
final white2 = Color.fromRGBO(239, 242, 239, 1);
final grey = Colors.grey[700];
final white = Colors.white;
final black = Colors.black;
final red = Color.fromRGBO(255, 32, 110, 1);
final green = Color.fromRGBO(28, 227, 224, 1);
final blue = Color.fromRGBO(102, 153, 255, 1);
final gunmetal = Color.fromRGBO(42, 45, 52, 1);
final green2 = Colors.greenAccent;

Decoration textBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  color: Colors.grey[200],
  boxShadow: [
    BoxShadow(
      color: Colors.grey,
      blurRadius: 5,
      offset: Offset(0, 3),
    ),
  ],
);
ButtonStyle mainButtonStyle(buttonSize, color){
  return TextButton.styleFrom(
    fixedSize: Size(buttonSize, buttonSize),
    padding: EdgeInsets.symmetric(
      horizontal: buttonSize * 0.2,
      vertical: buttonSize * 0.1,
    ),
    foregroundColor: Colors.white,
    backgroundColor: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonSize * 0.3),
    ),
    elevation: 20,
    shadowColor: Colors.black.withOpacity(1),
  );
}

Widget bottomBar(context){
  final Size screenSize = MediaQuery.of(context).size;

  return Container(
    color: white, // light grey background color
    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {Navigator.pushNamed(context, "./viewProfile");},
          icon: Icon(Icons.person, color: black, size: screenSize.width*0.08,),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.greenAccent,
          ),
          width: screenSize.width * 0.4,
          child: IconButton(
            onPressed: () {
              // Navigator.pushNamed(context, './home');
              Navigator.pushNamed(context, './home');
            },
            icon: Icon(Icons.home, color:black, size: screenSize.width*0.08,),
          ),
        ),
        
        IconButton(
          onPressed: () {Navigator.pushNamed(context, './defense');},
          icon: Icon(Icons.security, color: black, size: screenSize.width*0.08,),
        ),
      ],
    ),
  );
}
