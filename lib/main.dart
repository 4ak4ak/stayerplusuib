import 'package:flutter/material.dart';
import 'package:stayerplusuib/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'root_page.dart';
import 'homepage.dart';
import 'login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'signuppage.dart';


void main(){
  runApp(new MyApp());

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
     // home: new RootPage(auth: new Auth()),
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        '/homepage':(BuildContext context) => new Dashboard(),
        '/landinpage': (BuildContext context) => new MyApp(),
        '/signup': (BuildContext context) => new SignupPage()
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

  String phoneNum;
  String smsCode;
  String verificationId;


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
        codeSent: smsCodeSend,
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('PhoneAuth'),
      ),
      body: new Center(
        child: new Container(
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: 'Enter Phone num'),
                onChanged: (value){
                  this.phoneNum = value;
                },

              ),
              SizedBox(height: 10.0),
              RaisedButton(
                onPressed: verifyPhone,
                child: Text('Verify'),
                textColor: Colors.white,
                elevation: 7.0,
                color: Colors.blue
              ),
              RaisedButton(
                color: Colors.lightBlueAccent,
                  child: Text('Google'),
                  onPressed: () {
                    googleAuth.signIn().then((result) {
                      result.authentication.then((googleKey) {
                        FirebaseAuth.instance
                            .signInWithGoogle(
                            idToken: googleKey.idToken,
                            accessToken: googleKey.accessToken)
                            .then((signedInUser) {
                          print('Signed in as ${signedInUser.displayName}');
                          Navigator.of(context).pushReplacementNamed(
                              '/homepage');
                        }).catchError((e) {
                          print(e);
                        });
                      }).catchError((e) {
                        print(e);
                      });
                    }).catchError((e) {
                      print(e);
                    });
                  })],
          ),
        ),

      ),
    );
  }
}


