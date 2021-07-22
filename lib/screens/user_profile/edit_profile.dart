import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:med_alarm/models/doctor.dart';
import 'package:med_alarm/models/patient.dart';
import 'package:med_alarm/providers/firebase_provider.dart';
import 'package:med_alarm/providers/user_provider.dart';
import 'package:med_alarm/screens/medicine/add_medicine_screen.dart';
import 'package:med_alarm/screens/user_profile/user_profile.dart';
import 'package:med_alarm/utilities/sql_helper.dart';
import '/models/user.dart';

class EditProfile extends StatefulWidget {
  static const id = 'EDIT_PROFILE_SCREEN';
  EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool circular = false;
  PickedFile _imageFile;
  final _globalKey = GlobalKey<FormState>();
  DateTime dob = UserProvider.instance.currentUser.dob.toDate();
  final firstnameController =
      TextEditingController(text: UserProvider.instance.currentUser.firstname);
  final lastnameController =
      TextEditingController(text: UserProvider.instance.currentUser.lastname);
  final phoneNumberController = TextEditingController(
      text: UserProvider.instance.currentUser.phoneNumber);
  final addressController =
      TextEditingController(text: UserProvider.instance.currentUser.address);
  String profPicURL = UserProvider.instance.currentUser.profPicURL;

  final ImagePicker profPicPicker = ImagePicker();
  User user;

  get tfBorder => OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.circular(10),
  );

  get tfFBorder => OutlineInputBorder(
    borderSide: BorderSide(color: Theme.of(context).accentColor,width: 2),
  );

  @override
  void initState() {
    if(UserProvider.instance.currentUser.type == 'Patient')
      user = Patient.fromPatient(UserProvider.instance.currentUser);
    else if(UserProvider.instance.currentUser.type == 'Doctor')
      user = Doctor.fromDoctor(UserProvider.instance.currentUser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Edit Profile'),
      ),
      body: Form(
        key: _globalKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: <Widget>[
            profPicURLTextField(),
            SizedBox(
              height: 20,
            ),
            firstnameTextField(),
            SizedBox(
              height: 20,
            ),
            lastnameTextField(),
            SizedBox(
              height: 20,
            ),
            phoneNumberTextField(),
            SizedBox(
              height: 20,
            ),
            addressTextField(),
            SizedBox(
              height: 20,
            ),
            dobTextField(),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(25),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () async {
                      setState(() {
                        circular = true;
                      });
                      if (_globalKey.currentState.validate()) {
                        user.firstname = firstnameController.text;
                        user.lastname = lastnameController.text;
                        user.phoneNumber = phoneNumberController.text;
                        if(_imageFile != null) {
                          String url = await FirebaseProvider.instance
                              .uploadProfPic(File(_imageFile.path));
                          user.profPicURL = url;
                        }
                        user.address = addressController.text;
                        if(dob != null)
                        user.dob = Timestamp.fromDate(dob);

                        if(!await FirebaseProvider.instance.updateUser(user)) {
                          setState(() {
                            circular = false;
                          });
                          return;
                        }
                        UserProvider.instance.currentUser = user;
                        await SQLHelper.getInstant().insertUser();
                        setState(() {
                          circular = false;
                        });

                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed(UserProfile.id);
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 50,
                      child: Center(
                        child: circular
                            ? CircularProgressIndicator(color: Colors.white,)
                            : Text(
                                "Save",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget profPicURLTextField() {
    return Center(
      child: Stack(children: <Widget>[
        (profPicURL == '' && _imageFile == null)
        ? Icon(Icons.account_circle, size: 200.0,)
        : Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CircleAvatar(
            radius: 80.0,
            backgroundImage: _imageFile == null
                ? NetworkImage(profPicURL)
                : FileImage(File(_imageFile.path)),
          ),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Theme.of(context).accentColor,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await profPicPicker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Widget firstnameTextField() {
    return TextFormField(
      controller: firstnameController,
      validator: (value) {
        if (value.isEmpty) return "First name can't be empty";
        return null;
      },
      decoration: InputDecoration(
        border: tfBorder,
        focusedBorder: tfFBorder,
        labelText: "First Name",
        hintText: "First Name",
      ),
    );
  }

  Widget lastnameTextField() {
    return TextFormField(
      controller: lastnameController,
      validator: (value) {
        if (value.isEmpty) return "Last name can't be empty";
        return null;
      },
      decoration: InputDecoration(
        border: tfBorder,
        focusedBorder: tfFBorder,
        labelText: "Last Name",
        hintText: "Last Name",
      ),
    );
  }

  Widget phoneNumberTextField() {
    return TextFormField(
      controller: phoneNumberController,
      validator: (value) {
        if (value.isEmpty) return 'Phone number can\'t be empty';
        else if (value.length != 11) return 'Phone number must be 11 digits';
        return null;
      },
      decoration: InputDecoration(
        border: tfBorder,
        focusedBorder: tfFBorder,
        labelText: "Phone Number",
        hintText: "Phone Number",
      ),
    );
  }

  Widget addressTextField() {
    return TextFormField(
      controller: addressController,
      validator: (value) {
        if (value.isEmpty) return "Address can't be empty";
        return null;
      },
      decoration: InputDecoration(
        border: tfBorder,
        focusedBorder: tfFBorder,
        labelText: "Address",
        hintText: "Address",
      ),
    );
  }

  Widget dobTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: PanelTitle(
                title: "Birth Date",
                isRequired: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                DateFormat.yMMMd().format(dob),
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(50.0),
                ),
                primary: Theme.of(context).accentColor, // background
                onPrimary: Colors.white, // foreground
              ),
              child: Icon(Icons.date_range),
              onPressed: () => showRoundedDatePicker(
                context: context,
                theme: Theme.of(context),
                initialDate: dob,
                firstDate: DateTime(DateTime.now().year - 100),
                lastDate: DateTime(DateTime.now().year - 10),
                borderRadius: 16,
                onTapDay: (DateTime dateTime, bool available) {
                  if (!available) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("This date cannot be selected."),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: Text("OK"),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                    );
                  }
                  setState(() {
                    dob = dateTime;
                  });
                  return available;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
