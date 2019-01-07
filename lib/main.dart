import 'package:flutter/material.dart';
import 'login_page.dart';
import 'auth.dart';
import 'root_page.dart';


void main(){
  runApp(new MyApp());

}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'StayerPlus',
      theme:  new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(auth: new Auth())
    );
  }
}