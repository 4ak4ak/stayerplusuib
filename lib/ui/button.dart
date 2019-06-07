import 'package:flutter/material.dart';

class SPButton extends StatelessWidget {

  static const COLOR_SCHEME_1 = <Color>[
    Color(0xFFFC67A2),
    Color(0xFFFD7784),
    Color(0xFFFD8768),
  ];

  static const COLOR_SCHEME_2 = <Color>[
    Color(0xFFF83B54),
    Color(0xFFF93B54),
    Color(0xFFF93B54),
  ];

  static const COLOR_SCHEME_3 = <Color>[
    Color(0xFF55C4FB),
    Color(0xFF55C4FB),
    Color(0xFF55C4FB),
  ];

  @required final String text;
  @required final List<Color> colorScheme;
  @required final VoidCallback onPressed;

  SPButton({this.text, this.colorScheme, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.transparent,
      disabledColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          gradient: LinearGradient(
            colors: onPressed != null
                ? colorScheme
                : <Color>[Colors.grey[500],Colors.grey[400]]
          ),
        ),
        child: Center(
          child: Text(
            this.text,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
      elevation: 0.0,
      highlightElevation: 0.0,
      disabledElevation: 0.0,
      onPressed: this.onPressed,
    );
  }
}