import 'package:chatapp/widgets/Chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, future) {
        if (future.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            final documents = snapshot.data.documents;
            return ListView.builder(
              reverse: true,
              itemCount: documents.length,
              itemBuilder: (ctx, i) => MessageBubble(
                documents[i]['text'],
                documents[i]['userId'] == future.data.uid,
                  documents[i]['username'],
                  documents[i]['imageUrl'],
                ValueKey(documents[i].documentID)
              ),
            );
          },
        );
      },
    );
  }
}
