class DictinaryItem {
  static const _NAME = 'name';
  static const _ID = 'id';

  String _name;
  String _id;

  DictinaryItem.fromMap(Map<String, dynamic> map) {
    this._name = map[_NAME];
    this._id = map[_ID];
  }

  toMap() {
    return {
      _ID: _id,
      _NAME: _name,
    };
  }

  String get name => _name;
  String get id => _id;
}

class Dictionary {
  static const _CITIES = 'cities';
  static const _SEX = 'sex';

  List<DictinaryItem> _cities;
  List<DictinaryItem> _sexList;

  Dictionary.fromMap(Map<String, dynamic> map) {
    this._cities = List.of(map[_CITIES])
        .map((m) => DictinaryItem.fromMap(Map<String, dynamic>.from(m)))
    .toList(growable: false);

    this._sexList = List.of(map[_SEX])
        .map((m) => DictinaryItem.fromMap(Map<String, dynamic>.from(m)))
        .toList(growable: false);
  }

  toMap() {
    return {
      _CITIES: _cities.map((item) => item.toMap()).toList(growable: false),
      _SEX: _sexList.map((item) => item.toMap()).toList(growable: false),
    };
  }

  DictinaryItem getCityById(int id) {
    return _cities.firstWhere(
      ((obj) => obj.id == id),
      orElse: () => null,
    );
  }

  DictinaryItem getSexById(int id) {
    return _sexList.firstWhere(
      ((obj) => obj.id == id),
      orElse: () => null,
    );
  }

  List<DictinaryItem> get cities => _cities;
  List<DictinaryItem> get sexList => _sexList;
}