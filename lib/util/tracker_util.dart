import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

enum TrackerStatus {
  started,
  paused,
  stopped,
}

class TrackerState {
  final TrackerStatus _status;
  final int _totalSteps;
  final int _totalSeconds;
  final double _totalDistance;
  final double _speed;

  TrackerState({
    TrackerStatus status,
    int totalSteps,
    int totalSeconds,
    double totalDistance,
    double speed,
  }): _status = status ?? TrackerStatus.stopped
    , _totalSteps = totalSteps ?? 0
    , _totalSeconds = totalSeconds ?? 0
    , _totalDistance = totalDistance ?? 0.0
    , _speed = speed ?? 0.0;

  TrackerStatus get status => _status;
  int get totalSteps => _totalSteps;
  int get totalSeconds => _totalSeconds;
  double get totalDistance => _totalDistance;
  double get speed => _speed;
}

class TrackerUtil {

  TrackerStatus _status = TrackerStatus.stopped;
  int _totalSteps = 0;
  int _totalSeconds = 0;
  double _totalDistance = 0.0;
  double _speed = 0.0;
  DateTime _segmentStartTime;
  int _segmentStartSteps = 0;
  int _segmentLastSteps = 0;
  double _segmentDistance = 0.0;

  final _pedometer = Pedometer();
  final _stateSubject = BehaviorSubject<TrackerState>();

  TrackerUtil() {
    _pedometer.stepCountStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);

    bg.BackgroundGeolocation.onLocation(_onLocation, _onLocationError);

    bg.BackgroundGeolocation.ready(bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 0,
        stopOnTerminate: true,
        startOnBoot: false,
        debug: false,
        reset: true,
        locationUpdateInterval: 1000,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
    )).then((bg.State state) {
      print('[ready]: ${state.toString()}');
    }).catchError((error) {
      print('[ready] ERROR: $error');
    });
  }
  
  Stream<TrackerState> getStateStream() {
    return _stateSubject.stream;
  }

  void start() async {
    if (_status == TrackerStatus.stopped) {

      _status = TrackerStatus.started;

      await bg.BackgroundGeolocation.stop();
      await bg.BackgroundGeolocation.start();

      _startSegment();

      _totalSeconds = 0;
      _totalSteps = 0;

      _addState();

    } else {
      print ('tracker is not stopped');
    }
  }

  void pause(bool pause) {
    if (pause) {
      if (_status == TrackerStatus.started) {

        bg.BackgroundGeolocation.stop();

        _status = TrackerStatus.paused;

        int diffSeconds = DateTime
            .now()
            .difference(_segmentStartTime)
            .inSeconds;

        int diffSteps = _segmentLastSteps - _segmentStartSteps;

        _totalSeconds += diffSeconds;
        _totalSteps += diffSteps;
        _totalDistance += _segmentDistance;

        _addState();
      } else {
        print ('tracker is not started');
      }
    } else {
      if (_status == TrackerStatus.paused) {

        _status = TrackerStatus.started;

        _startSegment();

        _addState();

        bg.BackgroundGeolocation.start();
      } else {
        print ('tracker is not paused');
      }
    }
  }

  TrackerState stop() {
    if (_status == TrackerStatus.started || _status == TrackerStatus.paused) {

      _status = TrackerStatus.stopped;

      bg.BackgroundGeolocation.stop();

      int diffSeconds = DateTime
          .now()
          .difference(_segmentStartTime)
          .inSeconds;

      int diffSteps = _segmentLastSteps - _segmentStartSteps;

      _totalSeconds += diffSeconds;
      _totalSteps += diffSteps;
      _totalDistance += _segmentDistance;

      return _addState();
    } else {
      print ('tracker is not started or paused');
    }

    return null;
  }

  Future<void> _listenTime() async {
    _segmentStartTime = DateTime.now();
    while (true) {
      if (_status == TrackerStatus.started) {
        _addCurrentState();
        await Future.delayed(Duration(milliseconds: 100));
      } else {
        break;
      }
    }
  }

  void clear() {
    _totalSeconds = 0;
    _totalSteps = 0;
    _totalDistance = 0.0;
    _status = TrackerStatus.stopped;
    _addState();
  }

  void _startSegment() {
    bg.BackgroundGeolocation.setOdometer(0.0);
    _segmentStartSteps = 0;
    _segmentLastSteps = 0;
    _segmentDistance = 0.0;
    _speed = 0.0;
    _listenTime();
  }

  TrackerState _addCurrentState() {
    int diffSeconds = DateTime
        .now()
        .difference(_segmentStartTime)
        .inSeconds;
    int diffSteps = _segmentLastSteps - _segmentStartSteps;

    return _addState(
      totalSteps: (_totalSteps + diffSteps),
      totalSeconds: (_totalSeconds + diffSeconds),
      totalDistance: (_totalDistance + _segmentDistance),
      speed: _speed,
    );
  }

  TrackerState _addState({
    TrackerStatus status,
    int totalSteps,
    int totalSeconds,
    double totalDistance,
    double speed,

  }) {

    final state = TrackerState(
        status: status ?? _status,
        totalSteps: totalSteps ?? _totalSteps,
        totalSeconds: totalSeconds ?? _totalSeconds,
        totalDistance: totalDistance ?? _totalDistance,
        speed: speed ?? _speed,
    );

    _stateSubject.add(state);

    return state;
  }

  // pedometer events

  void _onData(int stepCountValue) async {
    if (_status == TrackerStatus.started) {

      if (_segmentStartSteps == 0) {
        _segmentStartSteps = stepCountValue;
      }
      _segmentLastSteps = stepCountValue;

      _addCurrentState();
    }
  }

  void _onDone() => print("pedometer done");

  void _onError(error) => print("pedometer error: $error");


  // background location events
  void _onLocation(bg.Location location) {
    print('[location] - ${location}');
    _segmentDistance = location.odometer;
    _speed = location.coords.speed;
    _addCurrentState();
  }

  void _onLocationError(bg.LocationError error) {
    print('[location] ERROR - $error');
  }
}
