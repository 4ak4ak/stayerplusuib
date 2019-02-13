import 'package:flutter/material.dart';

class Community extends StatefulWidget {
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('Коммьюнити'),
      ),
      body: new Center(
          child:   new Container(
              child: new Text('Коммьюнити')
          )
      ),
    );
  }
}
