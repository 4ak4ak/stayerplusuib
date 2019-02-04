
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();

  }

class _DashboardState extends State<Dashboard>{



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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    return new Scaffold(
//      appBar: AppBar(
//        title: new Text('Dashboard'),
//        centerTitle: true,
//      ),
//      body: Center(
//        child: Container(
//          child: new Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              new Text('You are logged in as ${uid}'),
//              SizedBox(
//                height: 15.0,
//
//              ),
//              new OutlineButton(
//                borderSide: BorderSide(
//                  color: Colors.red, style: BorderStyle.solid, width: 3.0
//                ),
//                child: Text('Logout'),
//                onPressed: (){
//                  FirebaseAuth.instance.signOut().then((action){
//                    Navigator
//                    .of(context)
//                        .pushReplacementNamed('/landinpage');
//                  }).catchError((e) {
//                    print(e);
//                  });
//                },
//              )
//            ],
//          ),
//        ),
//      ),
//    );


    return new Scaffold(
      body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              actions: <Widget>[
                new FlatButton(child: new Text('Log out', style: new TextStyle(fontSize: 10.0, color: Colors.white)),onPressed:  () {
                  FirebaseAuth.instance.signOut().then((action) {
                    Navigator
                        .of(context)
                        .pushReplacementNamed('/landinpage');
                  }).catchError((e) {
                    print(e);
                  });
                }),
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
                    child: new Text('Content', style: TextStyle(fontSize: 20.0),)
                ),

              ),

            ),
          ]),
    );}


  }

