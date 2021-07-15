import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:med_alarm/models/user.dart';
import 'package:med_alarm/providers/user_provider.dart';
import 'package:med_alarm/utilities/sql_helper.dart';

class FirebaseProvider with ChangeNotifier {
  FirebaseProvider._privateConstructor();
  static final FirebaseProvider instance = FirebaseProvider._privateConstructor();

  final Auth.FirebaseAuth auth = Auth.FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  // Future<void> login() async {
  //   final email = '1@1.1';
  //   // final email = '2@2.2';
  //   // final email = '3@3.3';
  //   final pass = '000000';
  //   try{
  //     await auth.signInWithEmailAndPassword(email: email, password: pass)
  //         .timeout(Duration(seconds: 5));
  //     await registerDeviceToken();
  //   } catch(e) {
  //     print(e);
  //   }
  // }

  Future<void> logout() async {
    try{
      await SQLHelper.getInstant().deleteUser();
      await removeDeviceToken();
      auth.signOut();
    } catch(e) {
      print(e);
    }
  }

  getLoggedUserInfo() async {
    var value = await firestore
        .collection("Users")
        .doc(auth.currentUser.uid)
        .get();
    UserProvider.instance.currentUser = User.fromDoc(auth.currentUser.uid, value);
  }

  Future<String> getDeviceToken() async {
    return await firebaseMessaging.getToken();
  }

  Future<void> registerDeviceToken() async {
    String token = await getDeviceToken();
    await firestore
        .collection('Users/${auth.currentUser.uid}/Tokens')
        .doc('$token')
        .set({'token': token});
  }

  Future<void> removeDeviceToken() async {
    String token = await getDeviceToken();
    await firestore
        .collection('Users/${auth.currentUser.uid}/Tokens')
        .doc('$token')
        .delete();
  }
}