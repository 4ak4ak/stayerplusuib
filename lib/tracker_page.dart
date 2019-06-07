import 'dart:async';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'dependencies/application_dependencies.dart';
import 'util/tracker_util.dart';
import 'model/run.dart';
import 'ui/dialog.dart';

class TrackerPage extends StatefulWidget {
  @override
  _TrackerPageState createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {

  TrackerState _trackerState = TrackerState();
  StreamSubscription<TrackerState> _stateSubscription;
  bool _loading = false;

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
        body: ModalProgressHUD(
            inAsyncCall: _loading,
            child: SafeArea(
              child: Stack(
                children: <Widget>[
                  BackButton(color: Colors.white),
                  _getBody(),
                ],
              )
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
    int meters = _getMeters();
    if (meters > 0) {
      kmTemp = (1000.0 * _trackerState.totalSeconds) / meters;
    }
    return _getTime(kmTemp.floor(), false, 'СРЕД. ТЕМП', 30);
  }

  Widget _getCurrentTemp() {
    double kmTemp = 0.0;
    if (_trackerState.speed > 0) {
      kmTemp = 1000.0 / _trackerState.speed;
    }
    return _getTime(kmTemp.floor(), false, 'ТЕКУЩ. ТЕМП', 30);
  }

  int _getMeters() {
    // это по идее правильный вариант. но не работет почему-то.
     return _trackerState.totalDistance.floor();

    // делаем допущение, что один шаг = один метр
//    return _trackerState.totalSteps;
  }

  Widget _getDistance() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          _getMeters().toString(),
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

  String _getTimeString(int seconds, bool showHours) {
    int mins = (seconds / 60).floor();
    int secs = seconds % 60;
    String minsString = mins.toString().padLeft(2, '0');
    String secsString = secs.toString().padLeft(2, '0');
    String timeString = '$minsString:$secsString';

    if (showHours) {
      int hours = (seconds / (60 * 60)).floor();
      String hoursString = hours.toString().padLeft(2, '0');
      timeString = '$hoursString:$timeString';
    }

    return timeString;
  }

  Widget _getTime(int seconds, bool showHours, String label, double fontSize) {

    String timeString = _getTimeString(seconds, showHours);

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
          _trackerState = TrackerModule.trackerUtil.stop();
          _saveRun();
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

  _saveRun() {
    final run = Run(
      seconds: _trackerState.totalSeconds,
      meters: _trackerState.totalDistance.floor(),
    );
    setState(() {
      _loading = true;
    });
    DataModule.dataUtil.setRun(run)
        .then((_) {

      setState(() {
        _loading = false;
      });

      final secondsString = 'Время: ${_getTimeString(_trackerState.totalSeconds, true)}';
      final metersString = 'Дистанция: ${_trackerState.totalDistance.floor()}м';
      SPDialog.show(context, 'Финиш', '$secondsString\n$metersString\nДанные сохранены');

      TrackerModule.trackerUtil.clear();

    }).catchError((error) {

      setState(() {
        _loading = false;
      });

      SPDialog.show(context, 'Ошибка', error.toString().replaceAll('Exception: ', ''));
    });
  }
}
