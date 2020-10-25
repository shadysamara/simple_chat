import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintTextKey;

  final Function saveFunction;
  final Function validateFunction;
  final int nofLines;
  final TextInputType textInputType;
  MyTextField(
      {this.hintTextKey,
      this.saveFunction,
      this.validateFunction,
      this.nofLines = 1,
      this.textInputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        maxLines: nofLines,
        onFieldSubmitted: (value) {
          FocusScope.of(context).nextFocus();
        },
        textInputAction: TextInputAction.next,
        keyboardType: textInputType,
        decoration: InputDecoration(
          helperText: ' ',
          alignLabelWithHint: true,
          labelText: hintTextKey,
          labelStyle: TextStyle(
            fontSize: 15,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.all(new Radius.circular(50.0)),
          ),
        ),
        validator: (value) {
          return validateFunction(value.trim());
        },
        onSaved: (newValue) => saveFunction(newValue.trim()),
        onChanged: (value) => validateFunction(value.trim()),
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    );
  }
}
