
import 'package:flutter/material.dart';

import '../services/retrieve_data.dart';
import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';


// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   description:
//       'This channel is used for important notifications.', // description
//   importance: Importance.high,
// );

// class PushNotificationService {
//   static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//
//   void initState() {
//
//     //send push notification when app is in background
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification notification = message.notification;
//       AndroidNotification android = message.notification?.android;
//       if (notification != null && android != null) {
//         flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               channelDescription: channel.description,
//               icon: android.smallIcon,
//             ),
//           ),
//         );
//       }
//     });
//
//
//   }
//
//   Future<String> getToken() async {
//     String token = await firebaseMessaging.getToken();
//     return token;
//   }
//
//
// }

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(

                    child: Row(
                      children: <Widget>[
                        Icon(Icons.exit_to_app),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text('Logout ')
                      ],
                    )),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier)async {
              if (itemIdentifier == 'logout') {


                //token of the user we want to use to send notifications to
                final token='euBZbg39Qm-FGXEvYrgTtF:APA91bEykK8Ln-83U81U74E9AC3IxvejdTYkeog3um8ghWQ5zk2muGGWn50foM3ommv8NKU7cVIw8Li9mwLLmhQ6tjdki9E-_cxx6OOxjMYqDNYWtBkeR3-ggGXjO8Kr_z3b3MKTGukk';

                await Future.delayed(Duration(seconds: 3));
                //   await PushNotifcationService().sendNotification(
                //       token: token,
                //       body: 'how are you? :)'
                //
                //
                // );

                // FirebaseAuth.instance.signOut();
              }
              RetrieveData();
            },
          )
        ],
      ),
      body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Messages(),
              ),
              NewMessage(),
            ],
          )),
    );
  }
}
