import 'package:flutter/material.dart';

class SPTextField extends StatelessWidget {

  @required final TextEditingController controller;
  @required final TextInputType keyboardType;
  @required final TextCapitalization textCapitalization;
  @required final bool autovalidate;
  @required final FormFieldValidator<String> validator;
  @required final TextStyle style;
  @required final int maxLines;
  @required final String hint;

  SPTextField({
    this.controller,
    this.keyboardType,
    this.textCapitalization,
    this.autovalidate,
    this.validator,
    this.style,
    this.maxLines,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      autovalidate: autovalidate,
      validator: validator,
      style: style,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(fontSize: 18.0),
        border: OutlineInputBorder()
      ),
    );
  }
}