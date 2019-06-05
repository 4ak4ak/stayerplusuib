import 'package:flutter/material.dart';
import 'model/profile.dart';
import 'ui/button.dart';
import 'ui/text_field.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final _appBarHeight = 300.0;
  Profile _profile = Profile()..firstName='Айдос'..lastName='Б';

  GlobalKey<FormState> _formKey;
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _phoneController;
  TextEditingController _ageController;
  TextEditingController _sexController;
  TextEditingController _weightController;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _ageController = TextEditingController();
    _sexController = TextEditingController();
    _weightController = TextEditingController();
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
            onPressed: (){},
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white ,
      body: _getBody(),
    );
  }

  String _getTitleText() {
    String name = '';
    if (_profile.firstName != null && _profile.firstName.isNotEmpty) {
      name += _profile.firstName;
      name += ' ';
    }
    if (_profile.lastName != null && _profile.lastName.isNotEmpty) {
      name += _profile.lastName[0];
      name += '.';
    }
    return name;
  }

  Widget _getTitle(){
    return Text(
      _getTitleText(),
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
      _getField(
        hint: 'ФИО',
        controller: _nameController,
        validator: (value) {
          return null;
        },
        autovalidate: true,
      ),
    );

    widgets.add(
      _getField(
        hint: 'Емейл',
        controller: _emailController,
        validator: (value) {
          return null;
        },
        autovalidate: true,
      ),
    );

    widgets.add(
      _getField(
        hint: 'Телефон',
        controller: _phoneController,
        validator: (value) {
          return null;
        },
        autovalidate: true,
      ),
    );

    widgets.add(
      _getField(
        hint: 'Возраст',
        controller: _ageController,
        validator: (value) {
          return null;
        },
        autovalidate: true,
      ),
    );

    widgets.add(
      _getField(
        hint: 'Пол',
        controller: _sexController,
        validator: (value) {
          return null;
        },
        autovalidate: true,
      ),
    );

    widgets.add(
      _getField(
        hint: 'Вес',
        controller: _weightController,
        validator: (value) {
          return null;
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

  Widget _getField({
    String hint,
    TextEditingController controller,
    bool autovalidate,
    FormFieldValidator<String> validator,
    TextInputType keyboardType,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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

}
