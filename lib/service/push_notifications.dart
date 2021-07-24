import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {
  static String token;

  PushNotificationsManager._();
  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool initialized = false;

  Future<void> init() async {

    if (!initialized) {
      //IOS
//      firebaseMessaging.requestNotificationPermissions();
//      firebaseMessaging.configure();

      // firebaseMessaging.configure(
      //   onMessage: (message) async {
      //     print('Messaging ***********************************************\n');
      //     print(message);
      //   },
      //   onResume: (message) async {
      //     print('Resuming ***********************************************\n');
      //     print(message);
      //   },
      //   onLaunch: (message) async {
      //     print('Launching ***********************************************\n');
      //     print(message);
      //   },
      // );

      firebaseMessaging.subscribeToTopic('all');

      token = await firebaseMessaging.getToken();

      initialized = true;
    }
  }
}
