import 'package:flutter/material.dart';
import 'package:med_alarm/models/doctor.dart';
import 'package:med_alarm/models/sign_up_model.dart';
import 'package:med_alarm/utilities/firebase_provider.dart';
import 'package:med_alarm/utilities/user_provider.dart';
import 'dart:io';

import '../../main.dart';
import '../home_screen.dart';
import 'edit_profile.dart';
import '../../utilities/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '/models/user.dart';
import 'package:intl/intl.dart';

class UserProfile extends StatefulWidget {
  final User user;
  final bool isCurrentUser;

  UserProfile(this.user, this.isCurrentUser);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // final User user = UserProvider.instance.currentUser;
  _UserProfileState();


  @override
  Widget build(BuildContext context) {
    String convertedDate;
    convertedDate =
        DateFormat.yMMMd().format(widget.user.dob.toDate());

    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        centerTitle: true,
        elevation: 5,
        title: const Text('User Profile'),
        actions: [
          if(widget.isCurrentUser)
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProfile.id)
                .whenComplete(() => setState(() {}));
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          head(widget.user),
          Divider(
            thickness: 0.8,
          ),
          otherDetails("email", widget.user.email),
          otherDetails("First Name", widget.user.firstname),
          otherDetails("Last Name", widget.user.lastname),
          otherDetails("Phone Number", widget.user.phoneNumber),
          otherDetails("Address", widget.user.address),
          if (widget.user.type == 'Doctor')
            otherDetails("Speciality", (widget.user as Doctor).speciality),
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

Widget head(User user) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Hero(
          tag: 'profPic-${user.uid}',
          child: Center(
            child: (user.profPicURL == '')
              ? Icon(Icons.account_circle, size: 170.0,)
              : Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CircleAvatar(
                  radius: 70.0,
                  backgroundImage: NetworkImage(user.profPicURL),
                ),
              ),
          ),
        ),
        Text(
          user.firstname,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Text(user.type)
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
