import 'dart:async';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'model/user.dart';
import 'model/dictionary.dart';
import 'ui/button.dart';
import 'ui/text_field.dart';

import 'dependencies/application_dependencies.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final _appBarHeight = 300.0;
  bool _loading = true;
  bool _modified = false;
  User _user;
  User _originalUser;
  Dictionary _dictionary;

  GlobalKey<FormState> _formKey;
  TextEditingController _nicknameController;
  TextEditingController _emailController;

  static List<DropdownMenuItem<int>> _yearMenuItems;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();

    _nicknameController = TextEditingController();
    _nicknameController.addListener(() {
      _user.nickname = _nicknameController.text;
      _checkModified();
    });

    _emailController = TextEditingController();
    _emailController.addListener(() {
      _user.email = _emailController.text;
      _checkModified();
    });

    _getUser();
  }

  Future<void>_getUser() {
    setState(() {
      _loading = true;
    });

    DataModule.dataUtil.getCurrentUser()
        .then((user) {

      _userDidLoad(user);

      return _getDictionary();
    })
        .catchError((error) {
      setState(() {
        _loading = false;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Ошибка"),
            content: new Text("Возникли проблемы при загрузке данных"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Закрыть"),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/homepage'));
                },
              ),
            ],
          );
        },
      );
    });
  }

  Future<void> _getDictionary() {
    setState(() {
      _loading = true;
    });

    return DataModule.dataUtil.getDictionary()
        .then((dict) {
      _dictionary = dict;
      setState(() {
        _loading = false;
      });
    });
  }

  Widget _getBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: _getCustomScrollView(),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          height: 60,
          child: SPButton(
            text: 'Изменить',
            colorScheme: SPButton.COLOR_SCHEME_1,
            onPressed: !_modified ? null : () {
              _setUser();
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white ,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _hideKeyboard();
        },
        child: ModalProgressHUD(
          child: _getBody(),
          inAsyncCall: _loading,
        ),
      ),
    );
  }

  Widget _getTitle() {
    return Text(
      _originalUser?.nickname ?? '',
      style: TextStyle(
        color: Colors.black,
      ),
    );
  }

  Widget _getCustomScrollView() {
    return CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor: Colors.white,
            expandedHeight: _appBarHeight,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: _getTitle(),
              centerTitle: true,
              collapseMode: CollapseMode.pin,
              background: _getAppBarBackground(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              _getFields(),
            ]),
          ),
        ]);
  }

  Widget _getAppBarBackground() {
    return Container(
      padding: EdgeInsets.only(bottom: 80),
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.only(bottom: 60),
            child: Image.asset(
              'assets/menuBack.jpg',
              fit: BoxFit.cover,
              color: Colors.indigo,
              colorBlendMode: BlendMode.softLight,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Material(
                  color: Colors.white,
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(70),
                  child: Padding(padding: const EdgeInsets.all(30.0),
                    child: Icon(
                      Icons.person,
                      color: Color(0xFFE34043),
                      size: 70.0,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _getFields() {
    final widgets = List<Widget>();

    widgets.add(
      _getTextField(
        hint: 'Никнейм',
        value: _user == null ? '' : _user.nickname,
        controller: _nicknameController,
        keyboardType: TextInputType.text,
        validator: (value) {
          return null;
        },
      ),
    );

    widgets.add(
        _getDropDownField(
            label: 'Пол',
            value: _user == null || _user.sex.isEmpty ? null : _user.sex,
            items: _dictionary == null ? List() : _dictionary.sexList.map((item) {
              return DropdownMenuItem(
                value: item.id,
                child: Text(item.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _user.sex = value;
              });
              _checkModified();
            }));

    widgets.add(
        _getDropDownField(
            label: 'Год рождения',
            value: _user == null || _user.bornYear == 0 ? null : _user.bornYear,
            items: _getYearMenuItems(),
            onChanged: (value) {
              setState(() {
                _user.bornYear = value;
              });
              _checkModified();
            }));

    widgets.add(
        _getDropDownField(
            label: 'Город',
            value: _user == null || _user.city.isEmpty ? null : _user.city,
            items: _dictionary == null ? List() : _dictionary.cities.map((item) {
              return DropdownMenuItem(
                value: item.id,
                child: Text(item.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _user.city = value;
              });
              _checkModified();
            }));

    widgets.add(
      _getTextField(
        hint: 'Емейл',
          controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (!_isValidEmail(value)) {
            return 'Неверный формат';
          }
        },
        autovalidate: true,
      ),
    );

    return Container(
      child: Column(
        children: widgets,
      ),
    );
  }

  Widget _getTextField({
    String value,
    String hint,
    TextEditingController controller,
    bool autovalidate,
    FormFieldValidator<String> validator,
    TextInputType keyboardType,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: SPTextField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: TextCapitalization.sentences,
        autovalidate: autovalidate ?? false,
        validator: validator,
        style: TextStyle(color: Colors.black, fontSize: 18.0,),
        maxLines: 1,
        hint: hint,
      ),
    );
  }

  Widget _getDropDownField({
    String label,
    dynamic value,
    List<DropdownMenuItem<dynamic>> items,
    ValueChanged onChanged
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: InputDecorator(
        decoration: InputDecoration(
            labelText: label,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            labelStyle: TextStyle(fontSize: 18.0),
            border: OutlineInputBorder()
        ),
        isEmpty: value == null,
        child: DropdownButton(
          isExpanded: true,
          isDense: true,
          underline: Container(),
          style: TextStyle(color: Colors.black, fontSize: 18.0,),
          value: value,
          onChanged: onChanged,
          items: items,
        ),
      ),
    );
  }

  void _checkModified() {
    setState(() {
      _modified = (
        _originalUser != null &&
        _user != null &&
        !_user.isEquals(_originalUser) &&
        _user.nickname.isNotEmpty &&
        _isValidEmail(_user.email)
      );
    });
  }

  String _getBornYearString() {
    if (_user != null && _user.bornYear >= 0 && _dictionary != null) {
      return _user.bornYear.toString();
    }
    return '';
  }

  void _hideKeyboard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }
  
  bool _isValidEmail(String email) {
    return (
        email.isEmpty ||
        RegExp(r"^[a-zA-Z0-9.-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+").hasMatch(email)
    );
  }

  void _setUser() {
    _hideKeyboard();

    setState(() {
      _loading = true;
    });

    DataModule.dataUtil.setUser(_user, _user.nickname != _originalUser.nickname)
        .then((user){

      _userDidLoad(user);

      setState(() {
        _loading = false;
      });

      _checkModified();

      _showDialog('Профиль', 'Данные сохранены');
    })
        .catchError((error) {

      setState(() {
        _loading = false;
      });

      _showDialog('Ошибка', error.toString().replaceAll('Exception: ', ''));
    });
  }

  void _userDidLoad(User user) {
    _user = user;
    _originalUser = User.fromUser(_user);
    _nicknameController.text = _user.nickname;
    _emailController.text = _user.email;
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            new FlatButton(
              child: new Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static List<DropdownMenuItem<int>> _getYearMenuItems() {
    if (_yearMenuItems == null) {
      int currYear = DateTime
          .now()
          .year;

      _yearMenuItems = List<int>.generate(100, (i) => currYear-i)
          .map((year) => DropdownMenuItem(
              value: year,
              child: Text(year.toString())))
          .toList();
    }
    return _yearMenuItems;
  }
}
