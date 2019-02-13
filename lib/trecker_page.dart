import 'package:flutter/material.dart';

class Trecker extends StatefulWidget {
  @override
  _TreckerState createState() => _TreckerState();
}

class _TreckerState extends State<Trecker> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('Трекер'),
      ),
      body: new Center(
          child:   new Container(
              child: new Text('Трекер')
          )
      ),
    );
  }
}
