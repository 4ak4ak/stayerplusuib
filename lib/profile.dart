import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('Профиль'),
      ),
      body: new Center(
      child:   new Container(
          child: new Text('Профиль')
        )
      ),
    );
  }
}
