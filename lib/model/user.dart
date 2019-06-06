class User {
  static const _NICKNAME = 'nickname';
  static const _EMAIL = 'email';
  static const _SEX = 'sex';
  static const _CITY = 'city';
  static const _BORN_YEAR = 'bornYear';

  String nickname;
  String email;
  String sex;
  String city;
  int bornYear;

  User()
  : nickname = ''
  , email = ''
  , sex = ''
  , city = ''
  , bornYear = 0;

  User.fromMap(Map<String, dynamic> map) {
    this.nickname = map[_NICKNAME] ?? '';
    this.email = map[_EMAIL] ?? '';
    this.sex = map[_SEX] ?? '';
    this.city = map[_CITY] ?? '';
    this.bornYear = map[_BORN_YEAR] ?? 0;
  }

  User.fromUser(User other) {
    this.nickname = other.nickname;
    this.email = other.email;
    this.sex = other.sex;
    this.city = other.city;
    this.bornYear = other.bornYear;
  }

  toMap() {
    return {
      _NICKNAME: nickname,
      _EMAIL: email,
      _SEX: sex,
      _CITY: city,
      _BORN_YEAR: bornYear,
    };
  }

  bool isEquals(User other) {
    return (
        this.nickname == other.nickname &&
        this.email == other.email &&
        this.sex == other.sex &&
        this.city == other.city &&
        this.bornYear == other.bornYear
    );
  }
}