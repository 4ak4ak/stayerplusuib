class Profile {
  static const FIRST_NAME = 'points';
  static const LAST_NAME = 'rubles';
  static const EMAIL = 'email';
  static const PHONE = 'phone';
  static const AGE = 'age';
  static const SEX = 'sex'; // 0 - муж, 1 - жен
  static const WEIGHT = 'weight';

  String firstName;
  String lastName;
  String email;
  String phone;
  int age;
  int sex; // 0 - муж, 1 - жен
  int weight;

  Profile();

  Profile.fromMap(Map<String, dynamic> map) {
    this.firstName = map[FIRST_NAME] ?? '';
    this.lastName = map[LAST_NAME] ?? '';
    this.email = map[EMAIL] ?? '';
    this.phone = map[PHONE] ?? '';
    this.age = map[AGE];
    this.sex = map[SEX];
    this.weight = map[WEIGHT];
  }

  toMap() {
    return {
      FIRST_NAME: firstName,
      LAST_NAME: lastName,
      EMAIL: email,
      PHONE: phone,
      AGE: age,
      SEX: sex,
      WEIGHT: weight,
    };
  }
}