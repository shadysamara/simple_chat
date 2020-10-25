import 'package:chat_online2/firebase_helper.dart';
import 'package:chat_online2/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messanger extends StatelessWidget {
  String myId;
  String otherId;
  Messanger({this.myId, this.otherId});
  TextEditingController textEditingController = TextEditingController();
  buildMessage(Map map, String myId, double width) {
    if (map['senderId'] == myId) {
      return myMessage(map['content'], width);
    } else {
      return partnerMessageView(map['content'], width);
    }
  }

  Widget myMessage(String content, double width) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            constraints: BoxConstraints(
              minWidth: 50,
              maxWidth: 200,
            ),
            color: Colors.red,
            child: Container(child: Text(content)),
          ),
        ],
      ),
    );
  }

  Widget partnerMessageView(String content, double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          color: Colors.blue,
          child: Text(content),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                signOut();
              })
        ],
        title: Text('Messanger'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: getChatMessages(myId, otherId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData && snapshot.data == null) {
                    return Center(
                      child: Text('No Messages'),
                    );
                  } else {
                    List<Map<String, dynamic>> data =
                        snapshot.data.docs.map((e) => e.data()).toList();
                    List<Message> messages =
                        data.map((e) => Message.fromJson(e)).toList();
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return buildMessage(data[index], myId, size.width);
                      },
                    );
                  }
                },
              ),
            )),
            Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    blurRadius: 2,
                    offset: Offset(-1, -1),
                    color: Colors.blue[200])
              ]),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  )),
                  GestureDetector(
                    onTap: () {
                      Message message = Message(
                          content: textEditingController.text,
                          timeStamp: FieldValue.serverTimestamp(),
                          senderId: myId,
                          recieverId: otherId);

                      insertMessage(message);
                    },
                    child: Container(
                        height: 60,
                        width: 60,
                        color: Colors.orange,
                        child: Icon(Icons.send)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
