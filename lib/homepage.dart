
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dependencies/application_dependencies.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();

  }

class _DashboardState extends State<Dashboard> {

  final _appBarHeight = 300.0;

  Material items(IconData icon, String heading){
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Center(
        child: Padding(padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: Padding(padding: const EdgeInsets.all(8.0),
                  child: Icon(icon, color: Color(0xFFE34043), size: 40.0,),),
                ),
                Text(heading,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0),),
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
      backgroundColor: Color(0xFF206BD0) ,
      body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Color(0xFF206BD0),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((action) {
                        Navigator
                            .of(context)
                            .pushReplacementNamed('/landinpage');
                      }).catchError((e) {
                        print(e);
                      });
                    }
                )
              ],
              expandedHeight: _appBarHeight,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Меню'),
                centerTitle: true,
                collapseMode: CollapseMode.pin,
                background: Container(
                  padding: EdgeInsets.only(bottom: 80),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.asset(
                          'assets/menuBack.jpg',
                          fit: BoxFit.cover,
                          color: Color(0x88a30e0e),
                          colorBlendMode: BlendMode.hardLight,
                        ),
                      ),
                      Center(
                        child: Text(
                          'Stayer+',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: StaggeredGridView.count (
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              children: <Widget>[
                InkWell(
                  onTap: (){
                  Navigator.of(context).pushNamed('/profile');
                },
                  child: items(
                      Icons.account_circle, "Профиль"),
                ),
                InkWell(
                  onTap: (){
                  Navigator.of(context).pushNamed('/community');
                },
                  child: items(Icons.group, "Коммьюнити"),
                ),
                InkWell(
                  onTap: (){
                  Navigator.of(context).pushNamed('/statistic');
                },
                child:  items(Icons.trending_down, "Статистика"),
                  ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pushNamed('/trecker');
                },
                child: items(Icons.track_changes, "Трекер"),
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pushNamed('/record');
                },
                child: items(Icons.star, "Рекорды"),
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pushNamed('/map');
                  },
                  child: items(Icons.map, "Карты"),
                )
              ],
              staggeredTiles: [
                StaggeredTile.extent(1, 120.0),
                StaggeredTile.extent(1, 120.0),
                StaggeredTile.extent(1, 120.0),
                StaggeredTile.extent(1, 120.0),
                StaggeredTile.extent(1, 120.0),
                StaggeredTile.extent(1, 120.0),
              ],
              ),
              ),
          ]),
    );
  }
}




