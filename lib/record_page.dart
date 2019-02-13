import 'package:flutter/material.dart';

class Records extends StatefulWidget {
  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('Рекорды'),
      ),
      body: new Center(
          child:   new Container(
              child: new Text('Рекорды')
          )
      ),
    );
  }
}
