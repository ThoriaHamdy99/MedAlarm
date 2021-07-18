import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med_alarm/models/user.dart';

class Doctor extends User {
  String speciality;

  Doctor({
    firstname,
    lastname,
    email,
    uid,
    profPicURL,
    address,
    type,
    phoneNumber,
    dob,
    this.speciality
  }) : super(
    firstname: firstname,
    lastname: lastname,
    email: email,
    uid: uid,
    profPicURL: profPicURL,
    address: address,
    type: type,
    phoneNumber: phoneNumber,
    dob: dob,
  );

  Doctor.fromDoc(uid, doc) {
    this.uid = uid;
    email = doc.get('email');
    type = doc.get('type');
    firstname = doc.get('firstname');
    lastname = doc.get('lastname');
    profPicURL = doc.get('profPicURL');
    phoneNumber = doc.get('phoneNumber');
    address = doc.get('address');
    dob = doc.get('dob');
    speciality = doc.get('speciality');
  }

  Doctor.fromMap(map) {
    uid = map['uid'];
    email = map['email'];
    type = map['type'];
    firstname = map['firstname'];
    lastname = map['lastname'];
    profPicURL = map['profPicURL'];
    phoneNumber = map['phoneNumber'];
    address = map['address'];
    dob = Timestamp.fromMillisecondsSinceEpoch(map['dob']);
    speciality = map['speciality'];
  }

  Doctor.fromSignUpModel(uid, model) {
    this.uid = uid;
    email = model.email.trim();
    type = model.type.trim();
    firstname = model.firstname.trim();
    lastname = model.lastname.trim();
    profPicURL = '';
    phoneNumber = model.phoneNumber.trim();
    address = model.address.trim();
    dob = Timestamp.fromDate(model.dob);
    speciality = model.speciality;
  }
}