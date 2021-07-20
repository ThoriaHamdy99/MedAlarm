import 'package:flutter/material.dart';
import 'package:med_alarm/models/doctor.dart';
import 'package:med_alarm/models/sign_up_model.dart';
import 'package:med_alarm/providers/firebase_provider.dart';
import 'package:med_alarm/providers/user_provider.dart';
import 'dart:io';

import '../../main.dart';
import '../home_screen.dart';
import 'edit_profile.dart';
import '/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '/models/user.dart';
import 'package:intl/intl.dart';

class UserProfile extends StatefulWidget {
  static const id = 'USER_PROFILE_SCREEN';
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State {
  _UserProfileState();

  final User currentUser = UserProvider.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    String convertedDate;
    convertedDate =
        DateFormat.yMMMd().format(currentUser.dob.toDate());

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProfile.id)
                .whenComplete(() => setState(() {}));
            },
            color: Colors.black,
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          head(currentUser),
          Divider(
            thickness: 0.8,
          ),
          otherDetails("email", currentUser.email),
          otherDetails("First Name", currentUser.firstname),
          otherDetails("Last Name", currentUser.lastname),
          otherDetails("Phone Number", currentUser.phoneNumber),
          otherDetails("Address", currentUser.address),
          if (currentUser.type == 'Doctor')
            otherDetails("Speciality", (currentUser as Doctor).speciality),
          otherDetails("Date of Birth", convertedDate),
          Divider(
            thickness: 0.8,
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

Widget head(User currentUser) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: (currentUser.profPicURL == '')
            ? Icon(Icons.account_circle, size: 170.0,)
            : Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: CircleAvatar(
                radius: 70.0,
                backgroundImage: NetworkImage(currentUser.profPicURL),
              ),
            ),
        ),
        Text(
          currentUser.firstname,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Text(currentUser.type)
      ],
    ),
  );
}

Widget otherDetails(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "$label :",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          value,
          style: TextStyle(fontSize: 15),
        )
      ],
    ),
  );
}
