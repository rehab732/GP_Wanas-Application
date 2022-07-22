import 'package:flutter/material.dart';
import 'mainscreen.dart';
import 'patient_view/mood.dart';
import 'shared_pages/internetCheck.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();
  print(token);
  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
  });

  //     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     if (message.data['type'] == 'chat') {
  //       Navigator.pushNamed(context, '/chat',
  //         arguments: ChatArguments(message));
  //     }
  //   });
  // }
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  MainScreen().requestPermission();

  MainScreen().loadFCM();

  MainScreen().listenFCM();
  MainScreen().getData();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("mnmnm");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecordMood(),
        ),
      );
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeConnect(),
    );
  }
}
