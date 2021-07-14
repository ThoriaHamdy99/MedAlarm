import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String firstname;
  String lastname;
  String email;
  String username;
  String uid;
  String profPicURL;
  String address;
  String type;
  String phoneNumber;
  Timestamp dob;


  User({
    this.firstname,
    this.lastname,
    this.email,
    this.username,
    this.uid,
    this.profPicURL,
    this.address,
    this.type,
    this.phoneNumber,
    this.dob,
  });

  User.fromDoc(uid, doc) {
    this.uid = uid;
    username = doc.get('username');
    email = doc.get('email');
    type = doc.get('type');
    firstname = doc.get('firstname');
    lastname = doc.get('lastname');
    profPicURL = doc.get('profPicURL');
    phoneNumber = doc.get('phoneNumber');
    address = doc.get('address');
    dob = doc.get('dob');
    print('+++++++++++++++++++ From User Constructor +++++++++++++++++++');
    print(uid);
    print(username);
    print(email);
    print(type);
    print(firstname);
    print(lastname);
    print(profPicURL);
    print(phoneNumber);
    print(address);
    print(dob);
    print('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
  }
}