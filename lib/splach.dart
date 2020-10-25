import 'package:chat_online2/auth_screens/login.dart';
import 'package:flutter/material.dart';

import 'chat_screens/chat_page.dart';
import 'firebase_helper.dart';

class Splach extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2)).then((value) {
      String userId = getUser();
      if (userId == null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return LoginScreen();
        }));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatPage();
        }));
      }
    });
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text('Complany Logo'),
      ),
    );
  }
}
