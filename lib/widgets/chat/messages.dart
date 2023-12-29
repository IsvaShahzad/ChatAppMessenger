import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:async/async.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final chatDocs = chatSnapshot.data?.docs;

        return chatDocs?.isEmpty ?? true
            ? Container()  // Display a blank container when there are no chat documents
            : ListView.builder(
          reverse: true,
          itemCount: chatDocs?.length,
          itemBuilder: (context, index) {
            final text = chatDocs?[index]['text'] ?? "";
            final isCurrentUser =
                chatDocs?[index]['userId'] == FirebaseAuth.instance.currentUser?.uid;
            final username = chatDocs?[index]['username'] ?? "";
            final userImage = chatDocs?[index]['userImage'] ?? "";

            // Check if the text is not empty before displaying the message bubble
            if (text.isNotEmpty) {
              return MessageBubble(
                text,
                isCurrentUser,
                username,
                userImage,
                key: ValueKey(chatDocs?[index].id),
              );
            } else {
              // Return an empty container if there's no text
              return Container();
            }
          },
        );



      },
    );
  }
}
