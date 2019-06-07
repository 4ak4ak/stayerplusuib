class Run {
  static const _DATE = 'date';
  static const _SECONDS = 'seconds';
  static const _METERS = 'meters';

  DateTime _date;
  int _seconds;
  int _meters;

  Run({int seconds, int meters})
      : _date = DateTime.now()
      , _seconds = seconds ?? 0
      , _meters = meters ?? 0;

  Run.fromMap(Map<String, dynamic> map) {
    _date = map[_DATE] != null ? map[_DATE].toDate() : DateTime.now();
    _seconds = map[_SECONDS] ?? 0;
    _meters = map[_METERS] ?? 0;
  }

  toMap() {
    return {
      _DATE: _date,
      _SECONDS: _seconds,
      _METERS: _meters,
    };
  }

  DateTime get date => _date;
  int get seconds => _seconds;
  int get meters => _meters;
}

class Runs {
  static const _ITEMS = 'items';

  List<Run> _items;

  Runs()
      : _items = List();

  Runs.fromMap(Map<String, dynamic> map) {
    this._items = List.of(map[_ITEMS])
        .map((m) => Run.fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  toMap() {
    return {
      _ITEMS: _items.map((item) => item.toMap()).toList(growable: false),
    };
  }

  List<Run> get items => _items;
}