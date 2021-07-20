import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_alarm/models/medicine2.dart';
import 'package:med_alarm/screens/medicine/edit_medicine.dart';
class MedicineInfo extends StatefulWidget {
  static const id = 'MEDICINE_INFO';
  final Medicine medicine;
  MedicineInfo(this.medicine);
  @override
  _MedicineInfoState createState() => _MedicineInfoState(this.medicine);
}

class _MedicineInfoState extends State<MedicineInfo> {
  Medicine medicine;
  _MedicineInfoState(this.medicine);
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
        // iconTheme: IconThemeData(
        //   color: Colors.white,
        // ),
        title: Text('Medication Info',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => EditMedicine(medicine)
                ),
              ).whenComplete(() {
                setState(() {

                });
              });
            },
            color: Colors.white,
          ),
        ],
      ),
      body: ListView(
        children: [
          buildInfo("Medicine Name:", "${medicine.medName}"),
          buildInfo("Medicine Amount:", "${medicine.medAmount}"),
          buildInfo("Dose Amount:", "${medicine.doseAmount}"),
          buildInfo("Medicine Type:", "${medicine.medType}"),
          buildInfo("Duration:", "${medicine.interval}"),
          buildInfo("Number of Doses:", "${medicine.numOfDoses}"),
          buildInfo("Hours between each Dose:", "${medicine.intervalTime}"),
          buildInfo("Reminder Time:", "${DateFormat.Hm().format(medicine.startTime)}"),
          buildInfo("Start Date:", "${DateFormat.yMMMd().format(medicine.startDate)}"),
          buildInfo("End Date:", "${DateFormat.yMMMd().format(medicine.endDate)}"),
          Divider(thickness: 2.0,),
        ],
      ),
    );
  }

  Padding buildInfo(String label, String info) {
    return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(thickness: 2.0,),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
              SizedBox(height: 5,),
              Text(
                info,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        );
  }
}
