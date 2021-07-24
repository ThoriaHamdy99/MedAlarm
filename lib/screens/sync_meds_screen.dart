import 'package:flutter/material.dart';
import 'package:med_alarm/models/dose.dart';
import 'package:med_alarm/models/medicine2.dart';
import 'package:med_alarm/utilities/firebase_provider.dart';
import 'package:med_alarm/screens/medicine/add_medicine_screen.dart';
import 'package:med_alarm/service/alarm.dart';
import 'package:med_alarm/utilities/sql_helper.dart';

class SyncMedsScreen extends StatelessWidget {
  static const id = 'SYNC_MEDS_SCREEN';
  SyncMedsScreen({Key key}) : super(key: key);

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
          title: Text(
            'Sync Medicines',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PanelTitle(title: 'Upload Data', isRequired: false),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildButton(context, 'Merge', () async {uploadMerge(context);}),
                    buildButton(context, 'Replace', () async {uploadReplace(context);}),
                  ],
                ),
                SizedBox(height: 20,),
                PanelTitle(title: 'Download Data', isRequired: false),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildButton(context, 'Merge', () async {downloadMerge(context);}),
                    buildButton(context, 'Replace', () async {downloadReplace(context);}),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget buildButton(context, text, callback) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Material(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          onTap: callback,
        ),
      ),
    );
  }

  Future<Widget> loadingScreen(context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // return loading ? false : true;
            return false;
          },
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
      barrierDismissible: false,
    );
  }

  uploadMerge(context) async {
    loadingScreen(context);
    String msg = 'Uploaded successfully';
    try {
      await FirebaseProvider.instance.uploadMedicinesMerge();
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      print(e);
      msg = 'Error, please try again later';
    }
    showSnackBar(context, msg);
  }

  uploadReplace(context) async {
    loadingScreen(context);
    String msg = 'Uploaded successfully';
    try {
      await FirebaseProvider.instance.uploadMedicinesReplace();
      // await Future.delayed(Duration(seconds: 5), () {});
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      print(e);
      msg = 'Error, please try again later';
    }
    showSnackBar(context, msg);
  }

  downloadMerge(context) async {
    loadingScreen(context);
    String msg = 'Downloaded successfully';
    try {
      List<Medicine> medicines = await FirebaseProvider.instance.getMedicines();
      if(medicines.isNotEmpty) {
        var sqlHelper = SQLHelper.getInstant();
        for(Medicine med in medicines) {
          await Alarm.updateAlarm(med);
          await sqlHelper.insertMedicine(med);
          for(Dose d in med.doses??[]) {
            await sqlHelper.insertDose(med.id, d);
          }
        }
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      print(e);
      msg = 'Error, please try again later';
    }
    showSnackBar(context, msg);
  }

  downloadReplace(context) async {
    loadingScreen(context);
    String msg = 'Downloaded successfully';
    try {
      List<Medicine> medicines = await FirebaseProvider.instance.getMedicines();
      if(medicines.isNotEmpty) {
        var sqlHelper = SQLHelper.getInstant();
        List<Medicine> oldMedicines = await sqlHelper.getAllMedicines();
        for(Medicine med in oldMedicines) {
          await Alarm.deleteAlarm(med);
        }
        await sqlHelper.deleteAllMedicine();
        for(Medicine med in medicines) {
          await Alarm.setAlarm(med);
          await sqlHelper.insertMedicine(med);
          for(Dose d in med.doses??[]) {
            await sqlHelper.insertDose(med.id, d);
          }
        }
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      print(e);
      msg = 'Error, please try again later';
    }
    showSnackBar(context, msg);
  }

  showSnackBar(context, String msg) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        duration: Duration(seconds:3),
        backgroundColor: Theme.of(context).accentColor,
      ));
    } catch (e) {}
  }
}
