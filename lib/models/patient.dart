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
}