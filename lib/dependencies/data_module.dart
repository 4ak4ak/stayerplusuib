import '../util/data_util.dart';
import 'firebase_module.dart';

class DataModule {
  static final dataUtil = DataUtil(
    FirebaseModule.firebaseFirestoreUtil
  );
}