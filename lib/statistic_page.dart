import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Statistic extends StatefulWidget {
  @override
  _StatisticState createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {

  var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, 0.0, 0.0 ];

  Material mychart1Items(String  title, String priceVal, String subtitle){
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.all(1.0),
                child: Text(title, style: TextStyle(
                  fontSize: 30.0
                ),),
                ),
                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text(priceVal, style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.green
                  ),),
                ),
                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text(subtitle, style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.blueGrey
                  ),),
                ),
                Padding(padding: EdgeInsets.all(1.0),
                    child: Sparkline(
                      data: data,
                   fillMode: FillMode.below,
                    fillGradient: new LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.amber[800], Colors.amber[200]],
                    ),),
                ),
              ],
            ),
          ],
        ),),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.menu), onPressed: (){


        }),
        title: Text("Статистика"),
        actions: <Widget>[
          IconButton(icon: Icon(
            FontAwesomeIcons.chartLine
          ), onPressed: (){

          })
        ],
      ),
      body: Container(
        color: Colors.teal,
        child: StaggeredGridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            children: <Widget>[
              Padding(padding: const EdgeInsets.all(8.0),
              child: mychart1Items('Статистика за месяц', '421.3km', '+12%'))
            ],
        staggeredTiles: [
          StaggeredTile.extent(4, 250.0),
        ],),
      ),
    );
  }
}
