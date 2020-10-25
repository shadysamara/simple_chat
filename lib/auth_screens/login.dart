import 'package:chat_online2/auth_screens/TextField.dart';
import 'package:chat_online2/auth_screens/market_registration.dart';
import 'package:chat_online2/auth_screens/primary_button.dart';
import 'package:chat_online2/chat_screens/chat_page.dart';
import 'package:chat_online2/firebase_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String userName;
  String password;
  saveUserName(String value) {
    this.userName = value;
  }

  savePassword(String value) {
    this.password = value;
  }

  validatepasswordFunction(String value) {
    if (value.isEmpty) {
      return 'null_error';
    } else if (value.length < 8) {
      return 'password_error';
    }
  }

  validateEmailFunction(String value) {
    final bool isValid = isEmail(value.trim());
    if (value.isEmpty) {
      return "enter_your_username";
    }
    if (!isValid) {
      return 'invalid email syntax';
    }
    return null;
  }

  Widget _loginLabel(context) {
    return Container(
      margin: EdgeInsets.only(top: 25, bottom: 25),
      child: Text(
        "login",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w500,
          fontSize: 22,
        ),
      ),
    );
  }

  final GlobalKey<FormState> loginFormKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.only(left: 20, top: 15, right: 20),
                child: Form(
                  key: loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _loginLabel(context),
                      _userNameField(),
                      _passwordField(),
                    ],
                  ),
                ),
              ),
              _loginButton(),
              _registerButton(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginFun() async {
    final mFormData = loginFormKey.currentState;
    if (!mFormData.validate()) {
      return;
    }

    mFormData.save();

    try {
      String username = this.userName.trim().toLowerCase();
      String password = this.password.trim();
      String userId = await loginUserUsingEmailAndPassword(username, password);
      if (userId != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatPage();
        }));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _userNameField() {
    return MyTextField(
      hintTextKey: 'user_name',
      nofLines: 1,
      saveFunction: saveUserName,
      validateFunction: validateEmailFunction,
    );
  }

  Widget _passwordField() {
    return MyTextField(
      hintTextKey: 'password',
      nofLines: 1,
      saveFunction: savePassword,
      validateFunction: validatepasswordFunction,
    );
  }

  Widget _loginButton() {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 15, right: 20),
      child: PrimaryButton(
        color: Colors.blue,
        textKey: 'login',
        buttonPressFun: loginFun,
      ),
    );
  }

  registerButtonFunction() {
    FocusScope.of(context).unfocus();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RegistrationPage();
    }));
  }

  Widget _registerButton() {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 15, right: 20),
      child: PrimaryButton(
        color: Colors.black.withOpacity(0.65),
        textKey: 'register',
        buttonPressFun: registerButtonFunction,
      ),
    );
  }
}
