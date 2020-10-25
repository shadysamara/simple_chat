import 'dart:io';

import 'package:chat_online2/models/message_model.dart';
import 'package:chat_online2/utils/custom_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
registerInMyApp(
    {String email,
    String password,
    String userName,
    String city,
    String country,
    String phoneNumber}) async {
  try {
    CustomProgress.pr.show();
    String userId = await createUserUsingEmailAndPassword(email, password);
    if (userId != null) {
      bool isSuccuss = await saveUserInFirestore(
          city: city,
          country: country,
          email: email,
          userID: userId,
          userName: userName);
      CustomProgress.pr.hide();
    } else {
      CustomProgress.pr.hide();
      throw Exception('regestration process faild');
    }
  } on Exception catch (e) {
    CustomProgress.pr.hide();
    print(e.toString());
  }
}

//////////////////////////////////////////////////////////////////////////////////
Future<String> createUserUsingEmailAndPassword(
    String email, String password) async {
  try {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user.uid;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
      return null;
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
  return null;
}

//////////////////////////////////////////////////////////////////////////////////
Future<String> loginUserUsingEmailAndPassword(
    String email, String passwoord) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: passwoord);

    return userCredential.user.uid;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
      return null;
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
      return null;
    }
  }
  return null;
}

////////////////////////////////////////////////////////////////////////
signOut() {
  firebaseAuth.signOut();
}

//////////////////////////////////////////////////////////////////////
String getUser() {
  if (firebaseAuth.currentUser != null) {
    String userId = firebaseAuth.currentUser.uid;
    return userId;
  } else {
    return null;
  }
}

//////////////////////////////////////////////////////////////////////////////////
Future<bool> saveUserInFirestore(
    {String userID,
    String email,
    String userName,
    String city,
    String country}) async {
  try {
    await firestore.collection('Users').doc(userID).set({
      'email': email,
      'userName': userName,
      'city': city,
      'country': country,
      'userId': userID
    });
    return true;
  } on Exception catch (e) {
    print(e);
    return false;
  }
}

//////////////////////////////////////////////////////////////////////////////////
Future<List<Map<String, dynamic>>> getAllChats() async {
  try {
    QuerySnapshot querySnapshot = await firestore.collection('Users').get();
    List<Map<String, dynamic>> maps =
        querySnapshot.docs.map((e) => e.data()).toList();
    return maps;
  } on Exception catch (e) {
    print(e.toString());
  }
}

/////////////////////////////////////////////////////////////
Future<List<Map<String, dynamic>>> getMyChats(String myId) async {
  try {
    QuerySnapshot querySnapshot =
        await firestore.collection('Users').doc(myId).collection('Chats').get();

    List<Map<String, dynamic>> maps =
        querySnapshot.docs.map((e) => e.data()).toList();
    return maps;
  } on Exception catch (e) {
    print(e.toString());
  }
}

//////////////////////////////////////////////////////////////////////////////////
Stream<QuerySnapshot> getChatMessages(String myId, String otherId) {
  try {
    Stream<QuerySnapshot> stream = firestore
        .collection('Users')
        .doc(myId)
        .collection('Chats')
        .doc(otherId)
        .collection('Messages')
        .orderBy('timeStamp')
        .snapshots();
    return stream;
  } on Exception catch (e) {
    print(e);
  }
}

/////////////////////////////////////////////////////////////////////////////////
Future<String> uploadFile(File file) async {
  try {
    StorageTaskSnapshot storageTaskSnapshot = await firebaseStorage
        .ref()
        .child('chats/${file.path}')
        .putFile(file)
        .onComplete;
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return imageUrl;
  } catch (e) {
    // e.g, e.code == 'canceled'
  }
}

//////////////////////////////////////////////////////////////////////////////////
insertMessage(Message message, [File file]) async {
  try {
    if (file != null) {
      String url = await uploadFile(file);
      firestore
          .collection('Users')
          .doc(message.senderId)
          .collection('Chats')
          .doc(message.recieverId)
          .collection('Messages')
          .add({'imageUrl': url, ...message.toJson()});

      firestore
          .collection('Users')
          .doc(message.recieverId)
          .collection('Chats')
          .doc(message.senderId)
          .collection('Messages')
          .add({'imageUrl': url, ...message.toJson()});
    } else {
      firestore
          .collection('Users')
          .doc(message.senderId)
          .collection('Chats')
          .doc(message.recieverId)
          .collection('Messages')
          .add(message.toJson());
      firestore
          .collection('Users')
          .doc(message.recieverId)
          .collection('Chats')
          .doc(message.senderId)
          .collection('Messages')
          .add(message.toJson());
    }
  } on Exception catch (e) {
    print(e);
  }
}
