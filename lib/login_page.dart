import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'auth_api.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;




  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType{
  login,
  register

}
class _LoginPageState extends State<LoginPage> {

  final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  FormType _formtype = FormType.login;

//Phone Num authentification

  String phoneNum;
  String smsCode;
  String verificationId;



  //Google Sign In
  GoogleSignIn googleAuth = new GoogleSignIn();



  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> verifyPhone() async {

    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId){
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSend = (String verId, [int forceCodeResend]){
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('Signed In');
      });

    };

    final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user){
      print('verified');
    };
    final PhoneVerificationFailed veriFailed = (AuthException exception){
      print('${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNum ,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed,
        codeSent: null,
        codeAutoRetrievalTimeout: autoRetrieve);
  }

  Future<bool> smsCodeDialog(BuildContext context){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return new AlertDialog(
          title: Text('Enter sms code'),
          content: TextField(
            onChanged: (value){
              this.smsCode = value;
            }
          ),
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            new FlatButton(
              child: Text('Done'),
                onPressed: (){
                FirebaseAuth.instance.currentUser().then((user) {
                  if(user != null) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/homepage');
                  }else{
                    Navigator.of(context).pop();
                    signIn();
                  }
                });
                },
                )
          ],
        );
      }
    );
  }

  signIn(){
    FirebaseAuth.instance
        .signInWithPhoneNumber(verificationId: verificationId, smsCode: smsCode)
        .then((user){
          Navigator.of(context).pushReplacementNamed('/homepage');
    }).catchError((e){
      print(e);
    });
  }



  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if(_formtype == FormType.login){
          String userId = await widget.auth.signInWIthEmailAndPassword(_email, _password);
          //FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
          print('Signed in: $userId');
        }else{
          String userId = await widget.auth.createUserWithEmailAndPassword(_email, _password);
        //FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
          print('Registered user: $userId');
        }widget.onSignedIn();
//        else{
//          RaisedButton(
//            child: Text('Lgin with Google'),
//            color: Colors.blue,
//            textColor: Colors.white,
//            elevation: 7.0,
//            onPressed: (){
//              //googleAuth.signIn().then();
//            },
//          );
//
//        }


      }
      catch (e) {
        print('Error: $e');
      }
    }
  }

  void moveToRegister(){
    formKey.currentState.reset();
    setState(() {
      _formtype = FormType.register;
    });
  }

  void  moveToLogin(){
    formKey.currentState.reset();
    setState(() {
      _formtype = FormType.login;
    });
  }

  void moveToLoginWithSocial(){
    formKey.currentState.reset();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new  Text('login_page'),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildInputs() + buildSubmitButtons()
           )),
       ),
      );
    }
    List<Widget> buildInputs(){
      return[
        new TextFormField(
          autofocus: false,
          decoration: new InputDecoration(
            hintText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            )),
          validator: (value) => value.isEmpty ? 'Email can not be empty': null,
          onSaved: (value) => _email = value,
        ),
        new TextFormField(
            decoration: new InputDecoration(labelText: 'Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            )),
            obscureText: true,
            validator: (value) => value.isEmpty ? 'Password is empty': null,
            onSaved: (value) => _password = value
        ),
      ];
  }
   List<Widget> buildSubmitButtons() {
     if (_formtype == FormType.login) {
       return [
         new RawMaterialButton(
           fillColor: Colors.cyan,
           splashColor: Colors.indigoAccent,
           shape: const StadiumBorder(),
           child: Row(
             children: const <Widget>[
               SizedBox(width: 100.0),
               Icon(Icons.done_outline,
                 color: Colors.black,
               ),
               SizedBox(width: 8.0),
               Center(
                   child:  Text(
                   'Log In', style: TextStyle(fontSize: 20.0, color: Colors.white))),
             ],
           ),
           onPressed:  (){
              validateAndSubmit();
           },
         ),
         new FlatButton(
           child: new Text(
               'Create an account', style: new TextStyle(fontSize: 20.0)),
           onPressed: moveToRegister,
         ),
//        new RawMaterialButton(
//          fillColor: Colors.cyan,
//          splashColor: Colors.blueAccent,
//          shape: const StadiumBorder(),
//          child: Row(
//            children: const <Widget>[
//              SizedBox(width: 50.0),
//              Icon(Icons.person_pin,
//              color: Colors.amber,
//              ),
//              SizedBox(width: 8.0),
//              Text(
//                 'Login with Google', style: TextStyle(fontSize: 20.0, color: Colors.white)),
//            ],
//          ),
//           onPressed:  () async {
//              bool b = await _loginUser();
//              b
//                  ? Navigator.of(context).pushNamed('RootPage')
//                  : Scaffold.of(context).showSnackBar(
//                    SnackBar(
//                        content: Text('Wrong Email'),
//                    )
//                    );
//           },
//        ),
//         new RawMaterialButton(
//           fillColor: Colors.cyan,
//           splashColor: Colors.blue,
//           shape: const StadiumBorder(),
//           child: Row(
//             children: const <Widget>[
//               SizedBox(width: 50.0),
//               Icon(Icons.person_pin,
//                 color: Colors.blue,
//               ),
//               SizedBox(width: 8.0),
//               Text(
//                   'Login with Facebook', style: TextStyle(fontSize: 20.0, color: Colors.white)),
//             ],
//           ),
//           onPressed:  (){
//
//           },
//         ),
         new RawMaterialButton(
           fillColor: Colors.cyan,
           splashColor: Colors.blueAccent,
           shape: const StadiumBorder(),
           child: Row(
             children: const <Widget>[
               SizedBox(width: 50.0),
               Icon(Icons.phone,
                 color: Colors.black,
               ),
               SizedBox(width: 8.0),
               Text(
                   'Login with phone number', style: TextStyle(fontSize: 20.0, color: Colors.white)),
             ],
           ),
           onPressed:  (){

           },
         )];
     }else if(){}else{
       return [
         new RaisedButton(
           child: new Text('Create an account', style: new TextStyle(fontSize: 20.0)),
           onPressed: validateAndSubmit,
         ),
         new RawMaterialButton(
           fillColor: Colors.cyan,
           splashColor: Colors.blueAccent,
           shape: const StadiumBorder(),
           child: Row(
             children: const <Widget>[
               SizedBox(width: 50.0),
               Icon(Icons.person_pin,
                 color: Colors.amber,
               ),
               SizedBox(width: 8.0),
               Text(
                   'Login with Google', style: TextStyle(fontSize: 20.0, color: Colors.white)),
             ],
           ),
           onPressed:  () async {
             bool b = await _loginUser();
             b
                 ? Navigator.of(context).pushNamed('RootPage')
                 : Scaffold.of(context).showSnackBar(
                 SnackBar(
                   content: Text('Wrong Email'),
                 )
             );
           },
         ),
         new RawMaterialButton(
           fillColor: Colors.cyan,
           splashColor: Colors.blue,
           shape: const StadiumBorder(),
           child: Row(
             children: const <Widget>[
               SizedBox(width: 50.0),
               Icon(Icons.person_pin,
                 color: Colors.blue,
               ),
               SizedBox(width: 8.0),
               Text(
                   'Login with Facebook', style: TextStyle(fontSize: 20.0, color: Colors.white)),
             ],
           ),
           onPressed:  (){

           },
         ),

         new FlatButton(
           child: new Text(
               'Have an account? Login', style: new TextStyle(fontSize: 20.0)),
           onPressed: moveToLogin,
         ),

       ];
     }
   }
  Future<bool> _loginUser() async{
    final api = await  FBApi.signInWithGoogle();
    if(api != null){
      return true;
    }else{
      return false;
    }
  }
}


