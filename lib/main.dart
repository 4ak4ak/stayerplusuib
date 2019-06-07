import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'homepage.dart';
import 'signuppage.dart';
import 'profile_page.dart';
import 'tracker_page.dart';
import 'statistic_page.dart';
import 'record_page.dart';
import 'map_page.dart';
import 'community_page.dart';

import 'ui/button.dart';

void main(){
  _setPreferredOrientation()
      .then((_) => runApp(new MyApp()));
}

Future<void> _setPreferredOrientation() {
  return SystemChrome.setPreferredOrientations(_getPortraitOrientations());
}

List<DeviceOrientation> _getPortraitOrientations() {
  return [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ];
}


class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'StayerPlus',
      theme:  new ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      // home: new RootPage(auth: new Auth()),
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        '/homepage':(BuildContext context) => new Dashboard(),
        '/landinpage': (BuildContext context) => new MyApp(),
        '/signup': (BuildContext context) => new SignupPage(),
        '/profile':(BuildContext context) => new ProfilePage(),
        '/community': (BuildContext context) => new Community(),
        '/trecker': (BuildContext context) => new TrackerPage(),
        '/record': (BuildContext context) => new Records(),
        '/statistic': (BuildContext context) => new Statistic(),
        '/map': (BuildContext context) => new Map()
      }

    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  _MyHomePageState createState() => new _MyHomePageState();


}

class _MyHomePageState extends  State<MyHomePage>{

  //Google Sign In
  GoogleSignIn googleAuth = new GoogleSignIn();

  String phoneNum = '';
  String smsCode;
  String verificationId;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
    body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: _getBody(),
      ),
    );
  }

  _getBody() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            width: double.infinity,
            height: 60,
            child: SPButton(
              text: 'Войти по номеру телефона',
              colorScheme: SPButton.COLOR_SCHEME_3,
              onPressed: () {
                _phoneAuth();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            width: double.infinity,
            height: 60,
            child: SPButton(
              text: 'Войти через Google',
              colorScheme: SPButton.COLOR_SCHEME_2,
              onPressed: () {
                _googleAuth();
              },
            ),
          ),
          SizedBox(height: 60,),
        ],
      ),
    );
  }

  _verifyPhone() {

    setState(() {
      _loading = true;
    });

    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId){
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSend = (String verId, [int forceCodeResend]){this.verificationId = verId;
    setState(() {
      _loading = false;
    });
    _smsCodeDialog(context).then((value) {
      print('Signed In');
    });
    };

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential phoneAuthCredential){
      setState(() {
        _loading = false;
      });
      _signIn(authCredential: phoneAuthCredential);
      print('verified');
    };

    final PhoneVerificationFailed veriFailed = (AuthException exception){
      setState(() {
        _loading = false;
      });
      _phoneAuth();
      print('${exception.message}');
    };

    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNum ,
        timeout: const Duration(seconds: 10),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed,
        codeSent: smsCodeSend,
        codeAutoRetrievalTimeout: autoRetrieve);
  }

  Future<bool> _smsCodeDialog(BuildContext context){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return new AlertDialog(
            title: Text('Код из смс'),
            content: TextField(
                style: TextStyle(fontSize: 20.0),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: new InputDecoration(
                    hintText: "123456"
                ),
                onChanged: (value){
                  this.smsCode = value;
                }
            ),
            contentPadding: EdgeInsets.all(12.0),
            actions: <Widget>[
              new FlatButton(
                child: Text('Закрыть', style: TextStyle(color: Colors.red),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: Text('Продолжить'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _signIn();
                },
              ),
            ],
          );
        }
    );
  }

  _signIn({AuthCredential authCredential}){

    setState(() {
      _loading = true;
    });

    final credential = authCredential ?? PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsCode);

    FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((user) {
      Navigator.of(context).pushReplacementNamed('/homepage');
    }).catchError((e){
      print(e);
    }).whenComplete((){
      setState(() {
        _loading = false;
      });
    });
  }

  _phoneAuth() {
    var textController = MaskedTextController(mask: '+7 (000) 000-00-00');
    textController.text=phoneNum.isEmpty ? '+7' : phoneNum;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return new AlertDialog(
          title: Text('Номер телефона'),
          content: TextField(
            keyboardType: TextInputType.phone,
            textAlign: TextAlign.center,
            controller: textController,
              style: TextStyle(fontSize: 20.0),
              autofocus: true,
              decoration: new InputDecoration(
                  hintText: "Телефон"
              ),
          ),
          contentPadding: EdgeInsets.all(12.0),
          actions: <Widget>[
            new FlatButton(
              child: Text('Закрыть', style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: Text('Продолжить'),
              onPressed: () {
                phoneNum = textController.text.replaceAll(RegExp(r'[^+0-9]'), '');
                Navigator.of(context).pop();
                _verifyPhone();
              },
            ),
          ],
        );
      }
    );
  }

  _googleAuth() {
    setState(() {
      _loading = true;
    });

    googleAuth.signIn().then((result) {
      result.authentication.then((googleKey) {

        final credential = GoogleAuthProvider.getCredential(
            idToken: googleKey.idToken,
            accessToken: googleKey.accessToken);

        FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((signedInUser) {
          setState(() {
            _loading = false;
          });
          print('Signed in as ${signedInUser.displayName}');
          Navigator.of(context).pushReplacementNamed(
              '/homepage');
        }).catchError((e) {
          setState(() {
            _loading = false;
          });
          print(e);
        });
      }).catchError((e) {
        setState(() {
          _loading = false;
        });
        print(e);
      });
    }).catchError((e) {
      setState(() {
        _loading = false;
      });
      print(e);
    });
  }

  _checkAuth() {
    setState(() {
      _loading = true;
    });
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        Navigator.of(context).pushReplacementNamed('/homepage');
      }
    }).whenComplete((){
      setState(() {
        _loading = false;
      });
    });
  }
}


