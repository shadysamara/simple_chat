import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String content;
  String senderId;
  String recieverId;
  FieldValue timeStamp;
  Message({this.content, this.recieverId, this.senderId, this.timeStamp});
  Message.fromJson(Map map) {
    this.content = map['content'];
    this.senderId = map['senderId'];
    this.recieverId = map['recieverId'];
  }
  toJson() {
    return {
      'content': this.content,
      'senderId': this.senderId,
      'recieverId': this.recieverId,
      'timeStamp': this.timeStamp,
    };
  }
}
