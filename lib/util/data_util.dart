import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_firestore_util.dart';
import '../model/user.dart';
import '../model/dictionary.dart';

class DataUtil {

  FirebaseFirestoreUtil _firebaseUtil;
  User _user;
  Dictionary _dictionary;

  DataUtil(this._firebaseUtil);

  Future<User> getCurrentUser() {
    return FirebaseAuth.instance.currentUser()
        .then((firebaseUser) => _firebaseUtil.getUserDocument(firebaseUser.uid)
        .then((userDocument) => userDocument.get()
        .then((userSnapshot) {
      if (userSnapshot.data == null) {
        final newUser = User();
        return userDocument.setData(newUser.toMap())
            .then((_) {
          _user = newUser;
          return _user;
        });
      } else {
        _user = User.fromMap(userSnapshot.data);
        return _user;
      }
    })));
  }

  Future<User> setUser(User user, bool checkNickname) async {
    final firebaseUser = await FirebaseAuth.instance.currentUser();
    final userDocument = await _firebaseUtil.getUserDocument(firebaseUser.uid);

    if (user.nickname.isNotEmpty && checkNickname) {
      var documents = await _firebaseUtil.getUserDocumentByNickname(user.nickname);
      if (documents.length > 0) {
        final duplicated = documents.firstWhere((d) {
          return d.reference.path != userDocument.path;
        }, orElse: (){});
        if (duplicated != null) {
          throw Exception('Никнейм \'${user.nickname}\' уже используется другим пользователем');
        }
      }
    }

    return userDocument.setData(user.toMap())
        .then((_) {
      _user = user;
      return _user;
    });
  }

  Future<Dictionary> getDictionary() {
    if (_dictionary != null) {
      return Future.value(_dictionary);
    }
    return _firebaseUtil.getDictionaryDocument()
        .then((dict) => dict.get()
        .then((dictSnapshot) {

      _dictionary = Dictionary.fromMap(dictSnapshot.data);
      return _dictionary;
    }));
  }

//  Future<void> fillDictionary() {
//    return _firebaseUtil.getDictionaryDocument()
//        .then((dict) =>
//      dict.setData({
//        'cities': [
//          {'id':'000','name':'Абай'},
//          {'id':'001','name':'Ақкөл'},
//          {'id':'002','name':'Ақсай'},
//          {'id':'003','name':'Ақсу'},
//          {'id':'004','name':'Ақтау'},
//          {'id':'005','name':'Ақтөбе'},
//          {'id':'006','name':'Алға'},
//          {'id':'007','name':'Алматы'},
//          {'id':'008','name':'Арал'},
//          {'id':'009','name':'Арқалық'},
//          {'id':'010','name':'Арыс'},
//          {'id':'011','name':'Нур-Султан'},
//          {'id':'012','name':'Атбасар'},
//          {'id':'013','name':'Атырау'},
//          {'id':'014','name':'Аягөз'},
//          {'id':'015','name':'Байқоңыр'},
//          {'id':'016','name':'Балқаш'},
//          {'id':'017','name':'Булаев'},
//          {'id':'018','name':'Державин'},
//          {'id':'019','name':'Ерейментау'},
//          {'id':'020','name':'Есік'},
//          {'id':'021','name':'Есіл'},
//          {'id':'022','name':'Жаңаөзен'},
//          {'id':'023','name':'Жаңатас'},
//          {'id':'024','name':'Жаркент'},
//          {'id':'025','name':'Жезқазған'},
//          {'id':'026','name':'Жем'},
//          {'id':'027','name':'Жетісай'},
//          {'id':'028','name':'Жітіқара'},
//          {'id':'029','name':'Зайсаң'},
//          {'id':'030','name':'Зыряновск'},
//          {'id':'031','name':'Қазалы'},
//          {'id':'032','name':'Қандыағаш'},
//          {'id':'033','name':'Қапшағай'},
//          {'id':'034','name':'Қарағанды'},
//          {'id':'035','name':'Қаражал'},
//          {'id':'036','name':'Қаратау'},
//          {'id':'037','name':'Қарқаралы'},
//          {'id':'038','name':'Қаскелең'},
//          {'id':'039','name':'Кентау'},
//          {'id':'040','name':'Көкшетау'},
//          {'id':'041','name':'Қостанай'},
//          {'id':'042','name':'Құлсары'},
//          {'id':'043','name':'Курчатов'},
//          {'id':'044','name':'Қызылорда'},
//          {'id':'045','name':'Леңгір'},
//          {'id':'046','name':'Лисаковск'},
//          {'id':'047','name':'Макинск'},
//          {'id':'048','name':'Мамлют'},
//          {'id':'049','name':'Павлодар'},
//          {'id':'050','name':'Петропавл'},
//          {'id':'051','name':'Приозер'},
//          {'id':'052','name':'Риддер'},
//          {'id':'053','name':'Рудный'},
//          {'id':'054','name':'Саран'},
//          {'id':'055','name':'Сарқант'},
//          {'id':'055','name':'Сарыағаш'},
//          {'id':'056','name':'Сәтбаев'},
//          {'id':'057','name':'Семей'},
//          {'id':'058','name':'Сергеев'},
//          {'id':'059','name':'Серебрянск'},
//          {'id':'060','name':'Степногорск'},
//          {'id':'061','name':'Степняк'},
//          {'id':'062','name':'Тайынша'},
//          {'id':'063','name':'Талғар'},
//          {'id':'064','name':'Талдықорған'},
//          {'id':'065','name':'Тараз'},
//          {'id':'066','name':'Текелі'},
//          {'id':'067','name':'Темір'},
//          {'id':'068','name':'Теміртау'},
//          {'id':'069','name':'Түркістан'},
//          {'id':'070','name':'Орал'},
//          {'id':'071','name':'Өскемен'},
//          {'id':'072','name':'Үшарал'},
//          {'id':'073','name':'Үштөбе'},
//          {'id':'074','name':'Форт-Шевченко'},
//          {'id':'075','name':'Хромтау'},
//          {'id':'076','name':'Шардара'},
//          {'id':'077','name':'Шалқар'},
//          {'id':'078','name':'Шар'},
//          {'id':'079','name':'Шахтинск'},
//          {'id':'080','name':'Шемонаиха'},
//          {'id':'081','name':'Шу'},
//          {'id':'082','name':'Шымкент'},
//          {'id':'083','name':'Щучинск'},
//          {'id':'084','name':'Екібастұз'},
//          {'id':'085','name':'Ембі'},
//        ],
//        'sex': [
//          {'id':'0','name':'Муж'},
//          {'id':'1','name':'Жен'},
//        ]
//      })
//    );
//  }
}