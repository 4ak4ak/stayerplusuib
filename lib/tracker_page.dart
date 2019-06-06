import 'dart:async';
import 'package:flutter/material.dart';

import 'dependencies/application_dependencies.dart';
import 'util/tracker_util.dart';

class TrackerPage extends StatefulWidget {
  @override
  _TrackerPageState createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {

  TrackerState _trackerState = TrackerState();
  StreamSubscription<TrackerState> _stateSubscription;

  @override
  void initState() {
    super.initState();
    _stateSubscription = TrackerModule.trackerUtil.getStateStream().listen((state) {
      setState(() {
        _trackerState = state;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stateSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF222022),
        body: SafeArea(
            child: Stack(
              children: <Widget>[
                BackButton(color: Colors.white),
                _getBody(),
              ],
            )
        )
    );
  }

  Widget _getBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _getScoreboard(),
        _getToolbar(),
      ],
    );
  }

  Widget _getScoreboard() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 120,
              child: Center (
                child: _getTime(_trackerState.totalSeconds, true, 'ВРЕМЯ', 40),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.white),
                              bottom: BorderSide(color: Colors.white)
                          )
                      ),
                      child: Center (
                        child: _getDistance(),
                      ),
                    ),
                  ),
                  Container(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: Center (
                            child: _getCurrentTemp(),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 12),
                          width: 1,
                          decoration: BoxDecoration(
                              color: Colors.white
                          ),
                        ),
                        Expanded(
                          child: Center (
                            child: _getAverageTemp(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getAverageTemp() {
    double kmTemp = 0.0;
    if (_trackerState.totalDistance > 0) {
      kmTemp = (1000.0 * _trackerState.totalSeconds) / _trackerState.totalDistance;
    }
    return _getTime(kmTemp.round(), false, 'СРЕД. ТЕМП', 30);
  }

  Widget _getCurrentTemp() {
    double kmTemp = 0.0;
    if (_trackerState.speed > 0) {
      kmTemp = 1000.0 / _trackerState.speed;
    }
    return _getTime(kmTemp.round(), false, 'ТЕКУЩ. ТЕМП', 30);
  }

  Widget _getDistance() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          _trackerState.totalDistance.round().toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 60.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'ДИСТАНЦИЯ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ],
    );
  }

  Widget _getTime(int seconds, bool showHours, String label, double fontSize) {

    int mins = (seconds / 60).round();
    int secs = seconds % 60;
    String minsString = mins.toString().padLeft(2, '0');
    String secsString = secs.toString().padLeft(2, '0');
    String timeString = '$minsString:$secsString';

    if (showHours) {
      int hours = (seconds / (60 * 60)).round();
      String hoursString = hours.toString().padLeft(2, '0');
      timeString = '$hoursString:$timeString';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          timeString,
          style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              fontFamily: 'RobotoMono'
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  Widget _getToolbar() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
          color: Color(0xFF2C404F)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _getStartPauseButton(),
          SizedBox(width: 20),
          _getStopButton(),
        ],
      ),
    );
  }

  Widget _getStartPauseButton() {
    return _getButton(
      color: Color(0xFFFDB446),
      iconData: _trackerState.status != TrackerStatus.started ? Icons.play_arrow : Icons.pause,
      onTap: () {
        if (_trackerState.status == TrackerStatus.stopped) {
          TrackerModule.trackerUtil.start();
        } else if (_trackerState.status == TrackerStatus.paused) {
          TrackerModule.trackerUtil.pause(false);
        } else {
          TrackerModule.trackerUtil.pause(true);
        }
      }
    );
  }

  Widget _getStopButton() {
    return _getButton(
        color: Color(0xFF218CF9),
        iconData: Icons.stop,
        onTap: (_trackerState.status == TrackerStatus.stopped) ? null : () {
          TrackerModule.trackerUtil.stop();
        }
    );
  }

  Widget _getButton({
    Color color,
    IconData iconData,
    GestureTapCallback onTap,
  }) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: onTap == null ? Colors.grey : color,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          iconData,
          size: 60,
          color: Colors.white,
        ),
      ),
      onTap: onTap,
    );
  }
}
