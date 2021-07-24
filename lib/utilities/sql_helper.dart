import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med_alarm/models/doctor.dart';
import 'package:med_alarm/models/dose.dart';
import 'package:med_alarm/models/medicine2.dart';
import 'package:med_alarm/models/patient.dart';
import 'package:med_alarm/models/user.dart';
import 'package:med_alarm/providers/user_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SQLHelper {
  static SQLHelper dbHelper;
  static Database _database;
  String path;

  SQLHelper.getInstant();
  factory SQLHelper() {
    if (dbHelper == null) {
      dbHelper = SQLHelper.getInstant();
    }
    return dbHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initializedDatabase();
    }
    return _database;
  }

  Future<Database> _initializedDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    path = dir.path + "med_alarm.db";
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  void _createDatabase(Database db, int version) async {
    try {
      await db.execute('''CREATE TABLE User(
              uid TEXT PRIMARY KEY,
              email TEXT NOT NULL,
              type TEXT NOT NULL,
              speciality TEXT,
              firstname TEXT NOT NULL,
              lastname TEXT NOT NULL,
              profPicURL TEXT NOT NULL,
              phoneNumber TEXT NOT NULL,
              address TEXT NOT NULL,
              dob INT NOT NULL);''');

      await db.execute('''CREATE TABLE Medicine(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL UNIQUE,
              type TEXT NOT NULL,
              description TEXT NOT NULL,
              startDate INT NOT NULL,
              endDate INT NOT NULL,
              medAmount INT NOT NULL,
              doseAmount INT NOT NULL,
              nDoses INT NOT NULL,
              startTime INT NOT NULL,
              interval TEXT NOT NULL,
              intervalTime INT NOT NULL,
              isOn INT NOT NULL);''');

      await db.execute('''CREATE TABLE Dose(
              id INTEGER NOT NULL REFERENCES Medicine(id),
              doseTime INT NOT NULL,
              taken INT NOT NULL,
              snoozed INT NOT NULL,
              PRIMARY KEY (id, doseTime));''');

      print('DB Initialized successfully');
    } catch (e) {
      print(e);
      throw 'DB Initialization failed';
    }
  }

  Future<int> insertUser() async {
    Database db = await this.database;
    await db.execute('DELETE FROM User');
    User user = UserProvider.instance.currentUser;
    var result;
    if(UserProvider.instance.currentUser.type == 'Patient')
      result = await db.rawInsert('''INSERT INTO User(
        uid, email, type, firstname,
        lastname, profPicURL, phoneNumber, address, dob)
        VALUES(
        '${user.uid.toString()}',
        '${user.email}',
        '${user.type}',
        '${user.firstname}',
        '${user.lastname}',
        '${user.profPicURL}',
        '${user.phoneNumber}',
        '${user.address}',
        '${user.dob.toDate().millisecondsSinceEpoch}')''');
    else if(UserProvider.instance.currentUser.type == 'Doctor')
      result = await db.rawInsert('''INSERT INTO User(
        uid, email, type, speciality, firstname,
        lastname, profPicURL, phoneNumber, address, dob)
        VALUES(
        '${user.uid.toString()}',
        '${user.email}',
        '${user.type}',
        '${(user as Doctor).speciality}',
        '${user.firstname}',
        '${user.lastname}',
        '${user.profPicURL}',
        '${user.phoneNumber}',
        '${user.address}',
        '${user.dob.toDate().millisecondsSinceEpoch}')''');
    return result;
  }

  Future<User> getUser() async {
    Database db = await database;
    try {
      List<Map<String, dynamic>> result = await db.rawQuery(
          '''SELECT * FROM User;''');
      if (result[0]['type'] == 'Patient')
        return Patient(
          uid: result[0]['uid'],
          email: result[0]['email'],
          type: result[0]['type'],
          firstname: result[0]['firstname'],
          lastname: result[0]['lastname'],
          profPicURL: result[0]['profPicURL'],
          phoneNumber: result[0]['phoneNumber'],
          address: result[0]['address'],
          dob: Timestamp.fromMillisecondsSinceEpoch(result[0]['dob']),
        );
      else if (result[0]['type'] == 'Doctor')
        return Doctor(
          uid: result[0]['uid'],
          email: result[0]['email'],
          type: result[0]['type'],
          speciality: result[0]['speciality'],
          firstname: result[0]['firstname'],
          lastname: result[0]['lastname'],
          profPicURL: result[0]['profPicURL'],
          phoneNumber: result[0]['phoneNumber'],
          address: result[0]['address'],
          dob: Timestamp.fromMillisecondsSinceEpoch(result[0]['dob']),
        );
      return Patient();
    } catch (e) {
      print('Function getUser is not fine');
      return Patient();
    }
  }

  Future<bool> deleteUser() async {
    return await logout();
  }

  Future<bool> insertMedicine(Medicine med) async {
    Database db = await this.database;
    var result;
    String id = med.id == null ? '' : 'id,';
    String idVal = med.id == null ? '' : '${med.id},';
    try {
      result = await db.rawInsert('''REPLACE INTO Medicine(
        $id name, type, startDate, endDate, medAmount, doseAmount,
        description, nDoses, startTime, interval, intervalTime, isOn)
        VALUES(
        $idVal
        '${med.medName}',
        '${med.medType}',
        '${med.startDate.millisecondsSinceEpoch}',
        '${med.endDate.millisecondsSinceEpoch}',
        '${med.medAmount}',
        '${med.doseAmount}',
        '${med.description}',
        '${med.nDoses}',
        '${med.startTime.millisecondsSinceEpoch}',
        '${med.interval}',
        '${med.intervalTime}',
        '${med.isOn ? 1 : 0}')''');
      print('+++++++++++++++++++++ From InsertMedicine +++++++++++++++++++++');
      if(result != null) {
        print('Medicine Added');
        return true;
      }
    } catch (e) {
      print(e);
      throw 'Medicine name already exists';
      // return false;
    }
    return false;
  }

  Future<bool> updateMedicine(Medicine med) async {
    Database db = await this.database;
    var result;
    try {
      result = await db.rawUpdate('''UPDATE Medicine
        SET
        name = '${med.medName}',
        type = '${med.medType}',
        startDate = '${med.startDate.millisecondsSinceEpoch}',
        endDate = '${med.endDate.millisecondsSinceEpoch}',
        medAmount = '${med.medAmount}',
        doseAmount = '${med.doseAmount}',
        nDoses = '${med.nDoses}',
        startTime = '${med.startTime.millisecondsSinceEpoch}',
        interval = '${med.interval}',
        intervalTime = '${med.intervalTime}',
        isOn = '${med.isOn ? 1 : 0}'
        WHERE id = '${med.id}';''');
      print('+++++++++++++++++++++ From UpdateMedicine +++++++++++++++++++++');
      if(result != null) {
        print('Medicine Updated');
        return true;
      }
    } catch (e) {
      print(e);
      throw 'Medicine hasn\'t updated';
      // return false;
    }
    return false;
  }

  Future<bool> updateMedicineAlarm(Medicine med) async {
    Database db = await this.database;
    var result;
    try {
      result = await db.rawUpdate('''UPDATE Medicine
        SET isOn = '${med.isOn ? 1 : 0}'
        WHERE id = '${med.id}';'''
      );
      print('+++++++++++++++++++++ From UpdateMedicine +++++++++++++++++++++');
      if(result != null) {
        print('Medicine alarm Updated');
        return true;
      }
    } catch (e) {
      print(e);
      throw 'Medicine alarm hasn\'t updated';
      // return false;
    }
    return false;
  }

  Future<Medicine> getMedicine(String medName) async {
    Database db = await database;

    try {
      var result = await db.rawQuery(
          "SELECT * FROM Medicine WHERE name = '$medName';");
      if (result.isEmpty) return null;
      print('+++++++++++++++++++++ From GetMedicine +++++++++++++++++++++');
      // print(result[0]['name']);
      // print(result[0]['type']);
      // print(DateTime.fromMillisecondsSinceEpoch(result[0]['startDate']));
      // print(DateTime.fromMillisecondsSinceEpoch(result[0]['endDate']));
      // print(result[0]['medAmount']);
      // print(result[0]['description']);
      // print(result[0]['doseAmount']);
      // print(result[0]['nDoses']);
      // print(DateTime.fromMillisecondsSinceEpoch(result[0]['startTime']));
      // print(result[0]['interval']);
      // print(result[0]['intervalTime']);
      // print(result[0]['isOn'] ? 'ON' : 'OFF');
      // print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
      return Medicine.fromMap(result[0]);
    } catch (e) {
      return null;
    }
  }

  Future<List<Medicine>> getAllMedicines() async {
    Database db = await database;
    List<Medicine> medicines = [];
    try {
      var result = await db.rawQuery('SELECT * FROM Medicine;');
      result.forEach((medicine) => medicines.add(Medicine.fromMap(medicine)));
      return medicines;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<Medicine>> getAllMedicinesAndDoses() async {
    Database db = await database;
    List<Medicine> medicines = [];
    try {
      var result = await db.rawQuery('SELECT * FROM Medicine;');
      for(var med in result) {
        medicines.add(Medicine.fromMap(med));
        medicines[medicines.length - 1].doses = await getMedicineDoses(med['id']);
      }
      return medicines;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> deleteMedicine(int id) async {
    Database db = await database;
    try {
      if(!await deleteMedicineDoses(id)) throw 'Doses aren\'t deleted';
      await db.rawDelete(
          "DELETE FROM Medicine WHERE id = '$id'");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteAllMedicine() async {
    Database db = await database;
    try {
      await db.rawDelete("DELETE FROM Dose");
      await db.rawDelete("DELETE FROM Medicine");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> insertDose(int id, Dose dose) async {
    Database db = await this.database;
    var result;
    try {
      result = await db.rawInsert('''INSERT INTO Dose
        values(
        '$id',
        '${dose.doseTime.millisecondsSinceEpoch}',
        '${(dose.taken??false) ? 1 : 0}',
        '${(dose.snoozed??false) ? 1 : 0}')''');
      print('+++++++++++++++++++++ From InsertDose +++++++++++++++++++++');
      if(result != null) {
        print('Dose Added');
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  Future<bool> replaceDose(map) async {
    Database db = await this.database;
    var result;
    try {
      print('Replaced Dose Info');
      print(map['id']);
      print(map['doseTime']);
      print(map['taken']);
      print(map['snoozed']);
      result = await db.rawInsert('''REPLACE INTO Dose
        (id, doseTime, taken, snoozed)
        values(
        '${map['id']}',
        '${map['doseTime']}',
        '${map['taken']}',
        '${map['snoozed']}')''');
      print('+++++++++++++++++++++ From ReplaceDose +++++++++++++++++++++');
      if(result != null) {
        print('Dose Replaced');
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  Future<Dose> getMedicineDose(int id, doseTime) async {
    Database db = await database;
    try {
      var result = await db.rawQuery("SELECT * FROM Dose WHERE id = '$id' "
          "AND doseTime = '$doseTime';");
      if(result.isEmpty) return null;
      return Dose.fromMap(result[0]);
    } catch (e) {
      throw 'Dose with id = $id and time = $doseTime is not found';
    }
  }

  Future<List<Dose>> getMedicineDoses(int id) async {
    Database db = await database;
    List<Dose> doses = [];
    try {
      var result = await db.rawQuery("SELECT * FROM Dose WHERE id = '$id';");
      result.forEach((dose) => doses.add(Dose.fromMap(dose)));
      return doses;
    } catch (e) {
      throw 'Medicine ID: $id is not found to add its doses';
    }
  }

  Future<bool> deleteDose(int id, DateTime time) async {
    Database db = await database;
    try {
      await db.rawDelete(
          "DELETE FROM Dose WHERE name = '$id' "
          "AND doseTime = '${time.millisecondsSinceEpoch}'");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteMedicineDoses(int id) async {
    Database db = await database;
    try {
      await db.rawDelete("DELETE FROM Dose WHERE id = '$id';");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await deleteTables();
      return true;
    } catch (e) {
      return false;
    }
  }

  deleteTables() async {
    Database db = await database;
    await db.execute('DELETE FROM User');
    await db.execute('DELETE FROM Dose');
    await db.execute('DELETE FROM Medicine');
    await recreateDB();
  }

  recreateDB() async {
    Database db = await database;
    await db.execute('DROP TABLE User');
    await db.execute('DROP TABLE Dose');
    await db.execute('DROP TABLE Medicine');

    await db.execute('''CREATE TABLE User(
              uid TEXT PRIMARY KEY,
              email TEXT NOT NULL,
              type TEXT NOT NULL,
              speciality TEXT,
              firstname TEXT NOT NULL,
              lastname TEXT NOT NULL,
              profPicURL TEXT NOT NULL,
              phoneNumber TEXT NOT NULL,
              address TEXT NOT NULL,
              dob INT NOT NULL);''');

    await db.execute('''CREATE TABLE Medicine(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL UNIQUE,
              type TEXT NOT NULL,
              description TEXT NOT NULL,
              startDate INT NOT NULL,
              endDate INT NOT NULL,
              medAmount INT NOT NULL,
              doseAmount INT NOT NULL,
              nDoses INT NOT NULL,
              startTime INT NOT NULL,
              interval TEXT NOT NULL,
              intervalTime INT NOT NULL,
              isOn INT NOT NULL);''');

    await db.execute('''CREATE TABLE Dose(
              id INTEGER NOT NULL REFERENCES Medicine(id),
              doseTime INT NOT NULL,
              taken INT NOT NULL,
              snoozed INT NOT NULL,
              PRIMARY KEY (id, doseTime));''');
  }

  insertDummyData() async {
    var db = await database;
    await db.rawInsert('''
    REPLACE INTO Medicine(
    id, name, type, startDate, endDate, medAmount, doseAmount,
    description, nDoses, startTime, interval, intervalTime, isOn)
    VALUES('97', 'Paracetamol 500mg', 'Pills', '${DateTime(2021, 7, 20, 0, 0).millisecondsSinceEpoch}',
    '${DateTime(2021, 7, 30, 0, 0).millisecondsSinceEpoch}', '20', '2', ' ',
    '3', '${DateTime(2021, 7, 20, 8, 0).millisecondsSinceEpoch}', 'daily',
    '8', '1');
    ''');
    await db.rawInsert('''
    REPLACE INTO Medicine(
    id, name, type, startDate, endDate, medAmount, doseAmount,
    description, nDoses, startTime, interval, intervalTime, isOn)
    VALUES('98', 'Panadol', 'Pills', '${DateTime(2021, 7, 20, 8, 0).millisecondsSinceEpoch}',
    '${DateTime(2021, 7, 28, 0, 0).millisecondsSinceEpoch}', '15', '1', '',
    '4', '${DateTime(2021, 7, 20, 14, 0).millisecondsSinceEpoch}', 'weekly',
    '6', '1');
    ''');
    await db.rawInsert('''
    REPLACE INTO Medicine(
    id, name, type, startDate, endDate, medAmount, doseAmount,
    description, nDoses, startTime, interval, intervalTime, isOn)
    VALUES('99', 'Oblex', 'Syrup', '${DateTime(2021, 7, 20, 0, 0).millisecondsSinceEpoch}',
    '${DateTime(2021, 8, 20, 0, 0).millisecondsSinceEpoch}', '80', '15', '',
    '4', '${DateTime(2021, 7, 20, 20, 0).millisecondsSinceEpoch}', 'monthly',
    '6', '1');
    ''');

    await db.rawInsert('''
    REPLACE INTO Dose(id, doseTime, taken, snoozed)
    values('97', '${DateTime(2021, 7, 20, 8, 0).millisecondsSinceEpoch}', '1', '1');
    ''');
    await db.rawInsert('''
    REPLACE INTO Dose(id, doseTime, taken, snoozed)
    values('97', '${DateTime(2021, 7, 20, 16, 0).millisecondsSinceEpoch}', '1', '0');
    ''');
    await db.rawInsert('''
    REPLACE INTO Dose(id, doseTime, taken, snoozed)
    values('97', '${DateTime(2021, 7, 21, 0, 0).millisecondsSinceEpoch}', '1', '0');
    ''');
    await db.rawInsert('''
    REPLACE INTO Dose(id, doseTime, taken, snoozed)
    values('97', '${DateTime(2021, 7, 21, 8, 0).millisecondsSinceEpoch}', '1', '1');
    ''');
    await db.rawInsert('''
    REPLACE INTO Dose(id, doseTime, taken, snoozed)
    values('97', '${DateTime(2021, 7, 21, 16, 0).millisecondsSinceEpoch}', '1', '0');
    ''');
    await db.rawInsert('''
    REPLACE INTO Dose(id, doseTime, taken, snoozed)
    values('97', '${DateTime(2021, 7, 22, 0, 0).millisecondsSinceEpoch}', '0', '0');
    ''');
    await db.rawInsert('''
    REPLACE INTO Dose(id, doseTime, taken, snoozed)
    values('97', '${DateTime(2021, 7, 22, 8, 0).millisecondsSinceEpoch}', '1', '0');
    ''');
    await db.rawInsert('''
    REPLACE INTO Dose(id, doseTime, taken, snoozed)
    values('97', '${DateTime(2021, 7, 22, 16, 0).millisecondsSinceEpoch}', '1', '0');
    ''');
    await db.rawInsert('''
    REPLACE INTO Dose(id, doseTime, taken, snoozed)
    values('97', '${DateTime(2021, 7, 23, 0, 0).millisecondsSinceEpoch}', '1', '0');
    ''');
    await db.rawInsert('''
    REPLACE INTO Dose(id, doseTime, taken, snoozed)
    values('97', '${DateTime(2021, 7, 23, 8, 0).millisecondsSinceEpoch}', '1', '0');
    ''');
    await db.rawInsert('''
    REPLACE INTO Dose(id, doseTime, taken, snoozed)
    values('97', '${DateTime(2021, 7, 23, 16, 0).millisecondsSinceEpoch}', '0', '1');
    ''');
    await db.rawInsert('''
    REPLACE INTO Dose(id, doseTime, taken, snoozed)
    values('97', '${DateTime(2021, 7, 24, 0, 0).millisecondsSinceEpoch}', '1', '0');
    ''');
    await db.rawInsert('''
    REPLACE INTO Dose(id, doseTime, taken, snoozed)
    values('97', '${DateTime(2021, 7, 24, 8, 0).millisecondsSinceEpoch}', '1', '0');
    ''');
    await db.rawInsert('''
    REPLACE INTO Dose(id, doseTime, taken, snoozed)
    values('98', '${DateTime(2021, 7, 20, 14, 0).millisecondsSinceEpoch}', '1', '0');
    ''');
    await db.rawInsert('''
    REPLACE INTO Dose(id, doseTime, taken, snoozed)
    values('99', '${DateTime(2021, 7, 20, 20, 0).millisecondsSinceEpoch}', '1', '0');
    ''');

    // await insertDose(4, Dose(doseTime: DateTime(
    //   2021, 7, 20, 8, 0
    // ), taken: true, snoozed: false));
    // await insertDose(4, Dose(doseTime: DateTime(
    //   2021, 7, 20, 14, 0
    // ), taken: true, snoozed: true));
    // await insertDose(4, Dose(doseTime: DateTime(
    //   2021, 7, 20, 20, 0
    // ), taken: false, snoozed: false));
    // await insertDose(4, Dose(doseTime: DateTime(
    //   2021, 7, 21, 8, 0
    // ), taken: true, snoozed: true));
    // await insertDose(4, Dose(doseTime: DateTime(
    //   2021, 7, 21, 14, 0
    // ), taken: true, snoozed: false));
    // await insertDose(4, Dose(doseTime: DateTime(
    //   2021, 7, 22, 8, 0
    // ), snoozed: true));
  }
}
