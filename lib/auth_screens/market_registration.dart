import 'dart:io';

import 'package:chat_online2/auth_screens/TextField.dart';
import 'package:chat_online2/auth_screens/primary_button.dart';
import 'package:chat_online2/firebase_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:string_validator/string_validator.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _MarketRegistrationPageState createState() => _MarketRegistrationPageState();
}

class _MarketRegistrationPageState extends State<RegistrationPage> {
  GlobalKey<FormState> marketRegFormKey = GlobalKey();

  String email;
  String password;

  String userId;
  String userName;
  String city;
  String country;

  saveCountry(String country) {
    this.country = country;
  }

  saveCity(String city) {
    this.city = city;
  }

  savepassword(String value) {
    this.password = value;
  }

  saveemail(String value) {
    this.email = value;
  }

  saveUserName(String value) {
    this.userName = value;
  }

  validateEmailFunction(String value) {
    if (value.isEmpty) {
      return 'null_error';
    } else if (!isEmail(value)) {
      return 'email_error';
    }
  }

  validatepasswordFunction(String value) {
    if (value.isEmpty) {
      return 'null_error';
    } else if (value.length < 8) {
      return 'password_error';
    }
  }

  nullValidation(String value) {
    if (value.isEmpty) {
      return 'null_error';
    }
  }

  saveForm() async {
    if (marketRegFormKey.currentState.validate()) {
      marketRegFormKey.currentState.save();
      bool isSuccess = await registerInMyApp(
          city: city,
          country: country,
          email: email,
          password: password,
          userName: userName);
      // if (isSuccess) {
      // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return Chat();
      // }));
      // }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('register_appbar'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Form(
            key: marketRegFormKey,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MyTextField(
                      hintTextKey: 'user_name',
                      nofLines: 1,
                      validateFunction: nullValidation,
                      saveFunction: saveUserName,
                    ),
                    MyTextField(
                      hintTextKey: 'email',
                      nofLines: 1,
                      validateFunction: nullValidation,
                      saveFunction: saveemail,
                    ),
                    MyTextField(
                      hintTextKey: 'password',
                      nofLines: 1,
                      validateFunction: validatepasswordFunction,
                      saveFunction: savepassword,
                      textInputType: TextInputType.visiblePassword,
                    ),
                    MyTextField(
                      hintTextKey: 'country',
                      nofLines: 1,
                      validateFunction: nullValidation,
                      saveFunction: saveCountry,
                      textInputType: TextInputType.emailAddress,
                    ),
                    MyTextField(
                      hintTextKey: 'city',
                      nofLines: 1,
                      validateFunction: nullValidation,
                      saveFunction: saveCity,
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    PrimaryButton(
                      buttonPressFun: saveForm,
                      textKey: 'register',
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
