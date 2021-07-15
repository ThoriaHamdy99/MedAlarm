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

  Stream getLatestMsgStream(String msgPath) {
    return firestore
        .collection('Messages/$msgPath/$msgPath')
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots();
  }

  Future getLatestMsg(String msgPath) {
    return firestore
        .collection('Messages/$msgPath/$msgPath')
        .orderBy('date', descending: true)
        .limit(1)
        .get();
  }

  Stream getChat(String msgPath) {
    return firestore
        .collection('Messages/$msgPath/$msgPath')
        .orderBy('date', descending: true)
        .snapshots();
  }

  deleteContact(String uid1, String uid2) async {
    await firestore
        .collection(
        'Users/$uid1/Contacts')
        .doc(uid2)
        .delete();
    await firestore
        .collection('Users/$uid2/Contacts')
        .doc(uid1)
        .delete();
  }

  addContact(String uid1, String uid2) async {
    await firestore
        .collection('Users/$uid1/Contacts')
        .doc(uid2)
        .set({
      'uid': uid2,
    });
    await firestore
        .collection('Users/$uid2/Contacts')
        .doc(uid1)
        .set({
      'uid': uid1,
    });
  }

  Future searchEmailExcept(String email, String excEmail) {
    return firestore
        .collection('Users')
        .where('email', isEqualTo: email)
        .where('email', isNotEqualTo: excEmail)
        .get();
  }

  Stream getContactFromUser(String userUid, String uid) {
    return firestore
        .collection('Users/$userUid/Contacts')
        .doc(uid)
        .snapshots();
  }

  Stream getContacts(String userUid) {
    return firestore.collection("Users/$userUid/Contacts").snapshots();
  }

  sendMessage(
      String msgPath,
      String from,
      String to,
      String type,
      String msg,
      String url,
  ) async {
    type == 'text'?
    await firestore.collection('Messages/$msgPath/$msgPath').add({
      'from': from,
      'to': to,
      'type': type,
      'text': msg,
      'date': DateTime.now().toIso8601String().toString()
    }):
    await firestore.collection('Messages/$msgPath/$msgPath').add({
      'from': from,
      'to': to,
      'type': type,
      'url': url,
      'date': DateTime.now().toIso8601String().toString()
    });
  }

  insertNewUser(
      String uid,
      String email,
      String type,
      String firstname,
      String lastname,
      String phoneNumber,
      String address,
      String date,
  ) async {
    await firestore
        .collection('Users')
        .doc(uid)
        .set({
      'email': email,
      'type': type,
      'firstname': firstname,
      'lastname': lastname,
      'profPicURL': '',
      'phoneNumber': phoneNumber,
      'address': address,
      'dob': Timestamp.fromDate(DateTime.parse(date)),
    });
    initNewUserContacts(uid);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String userUid) async {
    return await firestore.collection('Users').doc(userUid).get();
  }

  initNewUserContacts(String uid) async {
    await firestore
        .collection('Users')
        .doc(uid)
        .collection('Contacts')
        .doc('_init')
        .set({});
  }


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