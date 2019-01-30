import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';


class HomePage extends StatefulWidget{
  HomePage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String uid = '';

  getUid(){}

  @override
  void initState(){
    this.uid = '';
    FirebaseAuth.instance.currentUser().then((val){
      setState((){
        this.uid = val.uid;
      });
    }).catchError((e) {
      print(e);
    });
    super.initState();
  }

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

    //var assetsImage = new  AssetImage('assets/menuback.jpg');
    //var image  = new Image(image: assetsImage, width: 100.0, height: 100.0,)


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
            child: FlatButton(onPressed: null, child: null),
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