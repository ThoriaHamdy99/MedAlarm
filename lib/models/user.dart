import 'package:cloud_firestore/cloud_firestore.dart';

abstract class User {
  String _firstname;
  String _lastname;
  String _email;
  String _uid;
  String _profPicURL;
  String _address;
  String _type;
  String _phoneNumber;
  Timestamp _dob;

  String get firstname => _firstname;

  set firstname(String value) {
    _firstname = value;
  }

  String get lastname => _lastname;

  set lastname(String value) {
    _lastname = value;
  }

  Timestamp get dob => _dob;

  set dob(Timestamp value) {
    _dob = value;
  }

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get profPicURL => _profPicURL;

  set profPicURL(String value) {
    _profPicURL = value;
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  User({
    firstname,
    lastname,
    email,
    uid,
    profPicURL,
    address,
    type,
    phoneNumber,
    dob,
  }) {
  this.firstname = firstname;
  this.lastname = lastname;
  this.email = email;
  this.uid = uid;
  this.profPicURL = profPicURL;
  this.address = address;
  this.type = type;
  this.phoneNumber = phoneNumber;
  this.dob = dob;
}

  User.fromDoc(uid, doc) {
    this.uid = uid;
    email = doc.get('email');
    type = doc.get('type');
    firstname = doc.get('firstname');
    lastname = doc.get('lastname');
    profPicURL = doc.get('profPicURL');
    phoneNumber = doc.get('phoneNumber');
    address = doc.get('address');
    dob = doc.get('dob');
    // print('+++++++++++++++++++ From User Constructor +++++++++++++++++++');
    // print(uid);
    // print(email);
    // print(type);
    // print(firstname);
    // print(lastname);
    // print(profPicURL);
    // print(phoneNumber);
    // print(address);
    // print(dob);
    // print('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
  }
}