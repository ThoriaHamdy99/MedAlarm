
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med_alarm/models/doctor.dart';
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
    String path = dir.path + "med_alarm.db";
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  void _createDatabase(Database db, int version) async {
    print('///////////////////////////////////////////');
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
              dob INT NOT NULL)''');

    await db.execute('''CREATE TABLE Medicine(
              name TEXT PRIMARY KEY,
              type TEXT NOT NULL,
              startDate INT NOT NULL,
              endDate INT NOT NULL,
              amount INT NOT NULL,
              nDoses INT NOT NULL,
              startTime INT NOT NULL,
              interval TEXT NOT NULL,
              intervalTime INT)''');
  }

  // Future<List<Map<String, dynamic>>> getStudentMapList() async {
  //   Database db = await this.database;
  //
  //   // var result = await db.query(_tableName, orderBy: "$_id ASc");
  //   var result = await db.rawQuery('''select * from $_tableName
  //                                   order by $_id asc''');
  //
  //   return result;
  // }

  Future<int> insertUser() async {
    Database db = await this.database;

    await db.execute('DELETE FROM User');
    await db.execute('DROP TABLE User');
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
              dob INT NOT NULL)''');
    User user = UserProvider.instance.currentUser;
    print('+++++++++++++++++++++++ From InsertUser +++++++++++++++++++++++');
    print(user.uid);
    print(user.email);
    print(user.type);
    print(user.firstname);
    print(user.lastname);
    print(user.profPicURL);
    print(user.phoneNumber);
    print(user.address);
    print(user.dob);
    print('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    var result;
    if(UserProvider.instance.currentUser.type == 'Patient')
      result = await db.rawInsert('''insert into User(
        uid, email, type, speciality, firstname,
        lastname, profPicURL, phoneNumber, address, dob)
        values(
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
      result = await db.rawInsert('''insert into User(
        uid, email, type, speciality, firstname,
        lastname, profPicURL, phoneNumber, address, dob)
        values(
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

    List<Map<String, dynamic>> result = await db.rawQuery('''SELECT * FROM User;''');
    print('+++++++++++++++++++++++ From GetUser +++++++++++++++++++++++');
    print(result[0]['uid']);
    print(result[0]['email']);
    print(result[0]['username']);
    print(result[0]['type']);
    print(result[0]['firstname']);
    print(result[0]['lastname']);
    print(result[0]['profPicURL']);
    print(result[0]['phoneNumber']);
    print(result[0]['address']);
    print(Timestamp.fromMillisecondsSinceEpoch(result[0]['dob']));
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');

    if(result[0]['type'] == 'Patient')
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
    else if(result[0]['type'] == 'Doctor')
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
    print('Function getUser is not fine');
    return null;
  }

  Future<int> deleteUser() async {
    Database db = await database;

    int result = await db.rawDelete("DELETE FROM User");

    return result;
  }

  Future<bool> insertMedicine(Medicine med) async {
    Database db = await this.database;
    var result;
    try {
      if (UserProvider.instance.currentUser.type == 'Patient')
        result = await db.rawInsert('''insert into Medicine(
        name, type, startDate, endDate, amount,
        nDoses, startTime, interval, intervalTime)
        values(
        '${med.medName}',
        '${med.medType}',
        '${med.startDate}',
        '${med.endDate}',
        '${med.amountOfMed}',
        '${med.numOfDoses}',
        '${med.startTime}',
        '${med.interval}',
        '${med.intervalTime}')''');
      if(result > 0) {
        print('+++++++++++++++++++++ From InsertMedicine +++++++++++++++++++++');
        print(med.medName);
        print(med.medType);
        print(med.startDate);
        print(med.endDate);
        print(med.amountOfMed);
        print(med.numOfDoses);
        print(med.startTime);
        print(med.interval);
        print(med.intervalTime);
        print('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
        return true;
      }
      return false;
    } catch (e) {return false;}
  }

  Future<Medicine> getMedicine(String medName) async {
    Database db = await database;

    var result = await db.rawQuery('SELECT * FROM Medicine WHERE name = $medName;');
    if(result.isEmpty) return null;
    print('+++++++++++++++++++++ From GetMedicine +++++++++++++++++++++');
    print(result[0]['name']);
    print(result[0]['type']);
    print(result[0]['startDate']);
    print(result[0]['endDate']);
    print(result[0]['amount']);
    print(result[0]['nDoses']);
    print(result[0]['startTime']);
    print(result[0]['interval']);
    print(result[0]['intervalTime']);
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    return Medicine.fromMap(result[0]);
    // return Medicine(
    //   medName: result[0]['name'],
    //   medType: result[0]['type'],
    //   startDate: result[0]['startDate'],
    //   endDate: result[0]['endDate'],
    //   amountOfMed: result[0]['amount'],
    //   numOfDoses: result[0]['nDoses'],
    //   startTime: result[0]['startTime'],
    //   interval: result[0]['interval'],
    //   intervalTime: result[0]['intervalTime'],
    // );
  }

  Future<List<Medicine>> getAllMedicines() async {
    Database db = await database;
    List<Medicine> medicines = [];
    var result = await db.rawQuery('SELECT * FROM Medicine;');
    result.forEach((medicine) => medicines.add(Medicine.fromMap(medicine)));
    return medicines;
  }

  Future<int> deleteMedicine(String medName) async {
    Database db = await database;

    int result = await db.rawDelete("DELETE FROM Medicine WHERE name = $medName");

    return result;
  }

// Future<int> updateStudent(Student student) async {
//   Database db = await this.database;
//
//   int result = await db.rawUpdate('''update $_tableName
//                                       set $_name = '${student.name}',
//                                           $_description = '${student.description}',
//                                           $_date = '${student.date}',
//                                           $_pass = ${student.pass}
//                                        where $_id = ${student.id}''');
//
//   return result;
// }

  // Future<int> getCount() async {
  //   Database db = await this.database;
  //
  //   List<Map<String, dynamic>> all =
  //       await db.rawQuery("SELECT COUNT (*) FROM $_tableName");
  //
  //   int result = Sqflite.firstIntValue(all);
  //
  //   return result;
  // }

  // Future<List<Student>> getStudentList() async {
  //   var studentMapList = await getStudentMapList();
  //   int count = studentMapList.length;
  //   var students = List<Student>();
  //   for (var i = 0; i < count; i++) {
  //     students.add(Student.fromMap(studentMapList[i]));
  //   }
  //   return students;
  // }
}
