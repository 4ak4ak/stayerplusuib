import 'package:flutter/material.dart';
import 'model/profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final _appBarHeight = 300.0;
  Profile _profile = Profile()..firstName='Айдос'..lastName='Б';

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white ,
      body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: _appBarHeight,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  _getTitle(),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                centerTitle: true,
                collapseMode: CollapseMode.pin,
                background: Container(
                  padding: EdgeInsets.only(bottom: 80),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: EdgeInsets.only(bottom: 60),
                        child: Image.asset(
                          'assets/menuBack.jpg',
                          fit: BoxFit.cover,
                          color: Colors.indigo,
                          colorBlendMode: BlendMode.softLight,
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Material(
                              color: Colors.white,
                              elevation: 10.0,
                              borderRadius: BorderRadius.circular(70),
                              child: Padding(padding: const EdgeInsets.all(30.0),
                                child: Icon(
                                  Icons.person,
                                  color: Color(0xFFE34043),
                                  size: 70.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
//            SliverFillRemaining(
//              child: StaggeredGridView.count (
//                crossAxisCount: 2,
//                crossAxisSpacing: 12.0,
//                mainAxisSpacing: 12.0,
//                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
//                children: <Widget>[
//                  InkWell(
//                    onTap: (){
//                      Navigator.of(context).pushNamed('/profile');
//                    },
//                    child: items(
//                        Icons.account_circle, "Профиль"),
//                  ),
//                  InkWell(
//                    onTap: (){
//                      Navigator.of(context).pushNamed('/community');
//                    },
//                    child: items(Icons.group, "Коммьюнити"),
//                  ),
//                  InkWell(
//                    onTap: (){
//                      Navigator.of(context).pushNamed('/statistic');
//                    },
//                    child:  items(Icons.trending_down, "Статистика"),
//                  ),
//                  InkWell(
//                    onTap: (){
//                      Navigator.of(context).pushNamed('/trecker');
//                    },
//                    child: items(Icons.track_changes, "Трекер"),
//                  ),
//                  InkWell(
//                    onTap: (){
//                      Navigator.of(context).pushNamed('/record');
//                    },
//                    child: items(Icons.star, "Рекорды"),
//                  ),
//                  InkWell(
//                    onTap: (){
//                      Navigator.of(context).pushNamed('/map');
//                    },
//                    child: items(Icons.map, "Карты"),
//                  )
//
//
//
//                ],
//                staggeredTiles: [
//                  StaggeredTile.extent(1, 120.0),
//                  StaggeredTile.extent(1, 120.0),
//                  StaggeredTile.extent(1, 120.0),
//                  StaggeredTile.extent(1, 120.0),
//                  StaggeredTile.extent(1, 120.0),
//                  StaggeredTile.extent(1, 120.0),
//                ],),
//
//
//
//
//            ),
          ]),
    );
  }

  String _getTitle() {
    String name = '';
    if (_profile.firstName != null && _profile.firstName.isNotEmpty) {
      name += _profile.firstName;
      name += ' ';
    }
    if (_profile.lastName != null && _profile.lastName.isNotEmpty) {
      name += _profile.lastName[0];
      name += '.';
    }
    return name;
  }
}
