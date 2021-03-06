import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth{
  Future<String> signInWIthEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password );
  Future<String> currentUser();
  Future<void> signOut();
 // Future<bool> _loginUser();


}

class Auth implements BaseAuth{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;



  Future<String> signInWIthEmailAndPassword(String email, String password)async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;

  }
  Future<String> createUserWithEmailAndPassword(String email, String password ) async{
   FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
   return user.uid;
  }
  Future<String> currentUser()async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }
  Future<void> signOut() async{
    return _firebaseAuth.signOut();

  }

//  Future<bool> _loginUser() async{
//    final api = await  FBApi.signInWithGoogle();
//    if(api != null){
//      return true;
//    }else{
//      return false;
//    }
//  }



}

class  FBApi{
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseUser firebaseUser;

  FBApi(FirebaseUser user){
    this.firebaseUser = user;

  }

  static Future<FBApi> signInWithGoogle()async{
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;


    final credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken);

    final FirebaseUser user  = await _auth.signInWithCredential(credential);

    assert(user.email != null);
    assert(user.displayName != null);


    assert (await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return FBApi(user);

  }


}
