// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:uniconnect/Widgets/global_var.dart';

// // Chat List Page
// class ChatListPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Chats')),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('chats')
//             .where('participants',
//                 arrayContains: FirebaseAuth.instance.currentUser!.email)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.data!.docs.isEmpty) {
//             return Center(
//               child: Text(
//                 'No chats yet',
//                 style: Theme.of(context).textTheme.bodyLarge,
//               ),
//             );
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               var chat = snapshot.data!.docs[index];

//               // Safely get the other user's email
//               String otherUserEmail = '';
//               try {
//                 List<dynamic> participants =
//                     chat['participants'] as List<dynamic>;
//                 otherUserEmail = participants.firstWhere(
//                   (email) => email != FirebaseAuth.instance.currentUser!.email,
//                   orElse: () => '',
//                 );
//               } catch (e) {
//                 // If there's any error processing the participants, skip this item
//                 return SizedBox
//                     .shrink(); // Returns an empty widget instead of showing an error
//               }

//               // If we couldn't get a valid email, don't show this chat
//               if (otherUserEmail.isEmpty) {
//                 return SizedBox.shrink();
//               }

//               return ListTile(
//                 leading: CircleAvatar(
//                   child: Text(otherUserEmail[0].toUpperCase()),
//                   backgroundColor: Theme.of(context).primaryColor,
//                 ),
//                 title: Text(otherUserEmail),
//                 subtitle: Text(
//                   chat['lastMessage']?.toString() ?? 'No messages yet',
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ChatDetailPage(
//                       chatId: chat.id,
//                       otherUserEmail: otherUserEmail,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// // Chat Detail Page
// class ChatDetailPage extends StatelessWidget {
//   final String chatId;
//   final String otherUserEmail;

//   ChatDetailPage({required this.chatId, required this.otherUserEmail});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(otherUserEmail)),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('chats')
//                   .doc(chatId)
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return CircularProgressIndicator();
//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     var message = snapshot.data!.docs[index];
//                     return ListTile(
//                       title: Text(message['text']),
//                       subtitle: Text(message['senderEmail']),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           MessageInput(chatId: chatId),
//         ],
//       ),
//     );
//   }
// }

// // Message Input Widget
// class MessageInput extends StatefulWidget {
//   final String chatId;

//   MessageInput({required this.chatId});

//   @override
//   _MessageInputState createState() => _MessageInputState();
// }

// class _MessageInputState extends State<MessageInput> {
//   final _controller = TextEditingController();

//   void _sendMessage() async {
//     if (_controller.text.isNotEmpty) {
//       await FirebaseFirestore.instance
//           .collection('chats')
//           .doc(widget.chatId)
//           .collection('messages')
//           .add({
//         'text': _controller.text,
//         'senderEmail': FirebaseAuth.instance.currentUser!.email,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//       _controller.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _controller,
//               decoration: InputDecoration(hintText: 'Type a message'),
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.send),
//             onPressed: _sendMessage,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // New Chat Page
// class NewChatPage extends StatelessWidget {
//   final String otherUserEmail;

//   NewChatPage({required this.otherUserEmail});

//   void _startNewChat(BuildContext context) async {
//     var currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

//     // Check if a chat already exists
//     var existingChatQuery = await FirebaseFirestore.instance
//         .collection('chats')
//         .where('participants',
//             isEqualTo: [currentUserEmail, otherUserEmail]).get();

//     if (existingChatQuery.docs.isNotEmpty) {
//       // Chat already exists, navigate to existing chat
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ChatDetailPage(
//             chatId: existingChatQuery.docs.first.id,
//             otherUserEmail: otherUserEmail,
//           ),
//         ),
//       );
//     } else {
//       // Create a new chat
//       var chatDoc = await FirebaseFirestore.instance.collection('chats').add({
//         'participants': [currentUserEmail, otherUserEmail],
//         'lastMessage': null,
//         'lastMessageTimestamp': null,
//       });

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ChatDetailPage(
//             chatId: chatDoc.id,
//             otherUserEmail: otherUserEmail,
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Start the chat immediately when the page is built
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _startNewChat(context);
//     });

//     return Scaffold(
//       appBar: AppBar(title: Text('Starting Chat')),
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

// Chat List Page
class ChatListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: currentUserEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var chat = snapshot.data!.docs[index];
              var participants = List<String>.from(chat['participants']);
              var otherUserEmail =
                  participants.firstWhere((email) => email != currentUserEmail);

              return ListTile(
                leading: CircleAvatar(child: Text(otherUserEmail[0])),
                title: Text(otherUserEmail),
                subtitle: Text(
                  chat['lastMessage']?.toString() ?? 'No messages yet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatDetailPage(
                      chatId: chat.id,
                      otherUserEmail: otherUserEmail,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Chat Detail Page
class ChatDetailPage extends StatelessWidget {
  final String chatId;
  final String otherUserEmail;

  ChatDetailPage({required this.chatId, required this.otherUserEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(otherUserEmail)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var message = snapshot.data!.docs[index];
                    var timestamp = message['timestamp'] as Timestamp?;
                    var timeString = timestamp != null
                        ? DateFormat('HH:mm').format(timestamp.toDate())
                        : '';

                    bool isCurrentUser = message['senderEmail'] ==
                        FirebaseAuth.instance.currentUser!.email;

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isCurrentUser
                                ? Colors.white70
                                : Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(message['text']),
                              SizedBox(height: 4),
                              Text(
                                timeString,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          MessageInput(chatId: chatId),
        ],
      ),
    );
  }
}

// Message Input Widget
class MessageInput extends StatefulWidget {
  final String chatId;

  MessageInput({required this.chatId});

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _controller = TextEditingController();

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final timestamp = FieldValue.serverTimestamp();

      // Add message to subcollection
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
        'text': _controller.text,
        'senderEmail': FirebaseAuth.instance.currentUser!.email,
        'timestamp': timestamp,
      });

      // Update main chat document
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .update({
        'lastMessage': _controller.text,
        'lastMessageTimestamp': timestamp,
      });

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Type a message'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}

// New Chat Page
class NewChatPage extends StatelessWidget {
  final String otherUserEmail;

  NewChatPage({required this.otherUserEmail});

  void _startNewChat(BuildContext context) async {
    var currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

    // Check if a chat already exists
    var existingChatQuery = await FirebaseFirestore.instance
        .collection('chats')
        .where('participants',
            isEqualTo: [currentUserEmail, otherUserEmail]).get();

    if (existingChatQuery.docs.isNotEmpty) {
      // Chat already exists, navigate to existing chat
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailPage(
            chatId: existingChatQuery.docs.first.id,
            otherUserEmail: otherUserEmail,
          ),
        ),
      );
    } else {
      // Create a new chat
      var chatDoc = await FirebaseFirestore.instance.collection('chats').add({
        'participants': [currentUserEmail, otherUserEmail],
        'lastMessage': '',
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailPage(
            chatId: chatDoc.id,
            otherUserEmail: otherUserEmail,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startNewChat(context);
    });

    return Scaffold(
      appBar: AppBar(title: Text('Starting Chat')),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
