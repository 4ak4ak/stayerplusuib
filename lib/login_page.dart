import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'auth.dart';



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







  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }






  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if(_formtype == FormType.login){
          String userId = await widget.auth.signInWIthEmailAndPassword(_email, _password);

          print('Signed in: $userId');
        }else{
          String userId = await widget.auth.createUserWithEmailAndPassword(_email, _password);

          print('Registered user: $userId');
        }widget.onSignedIn();


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
//
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
     }else{
       return [
         new RaisedButton(
           child: new Text('Create an account', style: new TextStyle(fontSize: 20.0)),
           onPressed: validateAndSubmit,
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

}


