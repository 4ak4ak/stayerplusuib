import 'package:flutter/material.dart';
import 'package:stayerplusuib/home_page.dart';

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
      home: new RootPage(auth: new Auth()),
//      initialRoute: '/homepage',
//      routes:{
//        '/homepage': (context) => HomePage(),
//
//      },

    );
  }
}

