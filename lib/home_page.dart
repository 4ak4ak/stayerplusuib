import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:flutter/foundation.dart';


class HomePage extends StatefulWidget{
  HomePage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  _HomePageState createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {


  void _signOut()async{
    try{
      await widget.auth.signOut();
      widget.onSignedOut();
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {




    // TODO: implement build
    return new Scaffold(
      body: CustomScrollView(
                slivers: <Widget>[
          SliverAppBar(
            actions: <Widget>[
              new FlatButton(onPressed: _signOut,
                  child: new Text('Log out', style: new TextStyle(fontSize: 10.0, color: Colors.white))),
            ],
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Menu'),
              background: Image.asset('assets/menuBack.jpg', fit: BoxFit.cover),

            ),
          ),
          SliverFillRemaining(
          child: new Container(
            child: FlatButton(
                onPressed: (){

                },
                child: new Text('Жулдывка, I need a motivation', style: TextStyle(fontSize: 20.0),)
            ),
          ),

          ),
    ]),
    );}

  buildPhoneGridView() {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(6, (index) {
          return Card(
            child: Container(
              alignment: Alignment.center,
              color: Colors.teal[10 *(index % 9)],
              child: new Text('grid item $index'),
            ),
          );
      }),
    );
  }
}