
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();

  }

class _DashboardState extends State<Dashboard> {

  Material items(IconData icon, String heading, int color){
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(heading,
                  style: TextStyle(
                    color: new Color(color),
                fontSize: 20.0),),
                Material(
                  color: new Color(color),
                  borderRadius: BorderRadius.circular(24.0),
                  child: Padding(padding: const EdgeInsets.all(16.0),
                  child: Icon(icon, color: Colors.white, size: 30.0,),),
                )
              ],
            )
          ],
        ),),
      ),
    );
  }


  String uid = '';

  getUid() {}

  @override
  void initState() {
    this.uid = '';
    FirebaseAuth.instance.currentUser().then((val) {
      setState(() {
        this.uid = val.uid;
      });
    }).catchError((e) {
      print(e);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              actions: <Widget>[
                new FlatButton(child: new Text('Log out',
                    style: new TextStyle(fontSize: 10.0, color: Colors.white)),
                    onPressed: () {
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
                title: Text('Stayer+', textAlign: TextAlign.center),
                background: Image.asset(
                    'assets/menuBack.jpg', fit: BoxFit.cover),

              ),
            ),
            SliverFillRemaining(
              child: StaggeredGridView.count (
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              children: <Widget>[
                InkWell(
                  onTap: (){
                  Navigator.of(context).pushNamed('/profile');
                },
                  child: items(
                      Icons.account_circle, "Профиль", 0xffed622b),
                ),
                InkWell(
                  onTap: (){
                  Navigator.of(context).pushNamed('/community');
                },
                  child: items(Icons.group, "Коммьюнити", 0xffed622b),
                ),
                InkWell(
                  onTap: (){
                  Navigator.of(context).pushNamed('/statistic');
                },
                child:  items(Icons.trending_down, "Статистика", 0xffed622b),
                  ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pushNamed('/trecker');
                },
                child: items(Icons.track_changes, "Трекер", 0xffed622b),
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pushNamed('/record');
                },
                child: items(Icons.star, "Рекорды", 0xffed622b),
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pushNamed('/map');
                  },
                  child: items(Icons.map, "Карты", 0xffed622b),
                )



              ],
              staggeredTiles: [
                StaggeredTile.extent(1, 120.0),
                StaggeredTile.extent(1, 120.0),
                StaggeredTile.extent(1, 120.0),
                StaggeredTile.extent(1, 120.0),
                StaggeredTile.extent(1, 120.0),
                StaggeredTile.extent(1, 120.0),
              ],),




              ),



          ]),
    );
  }
}




