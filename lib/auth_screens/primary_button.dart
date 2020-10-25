import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  Function buttonPressFun;
  String textKey;
  Color color;
  PrimaryButton({this.buttonPressFun, this.textKey, this.color = Colors.blue});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      child: RaisedButton(
          color: this.color,
          child: Text(
            textKey,
            style: TextStyle(color: Colors.white),
            maxLines: 1,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          onPressed: () => buttonPressFun()),
    );
  }
}
