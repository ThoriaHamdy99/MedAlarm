import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med_alarm/models/user.dart';

class Patient extends User {
  Patient({
    firstname,
    lastname,
    email,
    uid,
    profPicURL,
    address,
    type,
    phoneNumber,
    dob,
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

  Patient.fromDoc(uid, doc) {
    this.uid = uid;
    email = doc.get('email');
    type = doc.get('type');
    firstname = doc.get('firstname');
    lastname = doc.get('lastname');
    profPicURL = doc.get('profPicURL');
    phoneNumber = doc.get('phoneNumber');
    address = doc.get('address');
    dob = doc.get('dob');
  }

  Patient.fromMap(doc) {
    uid = doc['uid'];
    email = doc['email'];
    type = doc['type'];
    firstname = doc['firstname'];
    lastname = doc['lastname'];
    profPicURL = doc['profPicURL'];
    phoneNumber = doc['phoneNumber'];
    address = doc['address'];
    dob = Timestamp.fromMillisecondsSinceEpoch(doc['dob']);
  }

  Patient.fromSignUpModel(uid, model) { 
    this.uid = uid;
    email = model.email.trim();
    type = model.type.trim();
    firstname = model.firstname.trim();
    lastname = model.lastname.trim();
    profPicURL = '';
    phoneNumber = model.phoneNumber.trim();
    address = model.address.trim();
    dob = Timestamp.fromDate(model.dob);
  }

  Patient.fromPatient(patient) {
    uid = patient.uid;
    email = patient.email;
    type = patient.type;
    firstname = patient.firstname;
    lastname = patient.lastname;
    profPicURL = patient.profPicURL;
    phoneNumber = patient.phoneNumber;
    address = patient.address;
    dob = patient.dob;
  }
}