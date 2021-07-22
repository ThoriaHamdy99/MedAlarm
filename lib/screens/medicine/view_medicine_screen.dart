import 'package:flutter/material.dart';
import 'package:med_alarm/models/medicine2.dart';
import 'package:intl/intl.dart';

import 'edit_medicine_screen.dart';

class ViewMedicineScreen extends StatefulWidget {
  Medicine med;

  ViewMedicineScreen(this.med);

  @override
  _ViewMedicineScreenState createState() => _ViewMedicineScreenState();
}

class _ViewMedicineScreenState extends State<ViewMedicineScreen> {

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
        title: const Text('Medicine Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return EditMedicine(widget.med);
                })
              ).then((newMed) {
                if(newMed != null) {
                  widget.med = newMed;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Medicine updated successfully'),
                    duration: Duration(seconds: 3),
                    backgroundColor: Theme.of(context).accentColor,
                  ));
                }
              }).whenComplete(() => setState(() {}));
            },
            // color: Colors.black,
          ),
        ],
      ),
      body: ListView(
        children: [
          head(),
          otherDetails("Medicine name", widget.med.medName),
          otherDetails("Medicine type", widget.med.medType),
          otherDetails("Notes", widget.med.description),
          otherDetails("Remaining amount", '${widget.med.medAmount}'),
          otherDetails("Dose amount", '${widget.med.doseAmount}'),
          otherDetails("Alarm starts at", parseTime(widget.med.startTime)),
          otherDetails("Alarm type", widget.med.interval),
          otherDetails("Daily interval (Hours)", '${widget.med.intervalTime}'),
          otherDetails("Doses per day", '${widget.med.nDoses}'),
          otherDetails("Start date", parseDate(widget.med.startDate)),
          otherDetails("End date", parseDate(widget.med.endDate)),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  String parseDate(DateTime dateTime) {
    return DateFormat().add_yMMMd().format(dateTime);
  }

  String parseTime(DateTime dateTime) {
    return DateFormat().add_jm().format(dateTime);
  }

  Widget head() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CircleAvatar(
              radius: 70.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  image: DecorationImage(
                    image: AssetImage('./assets/medicine_icons/other.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              // backgroundImage: NetworkImage(currentUser.profPicURL),
            ),
          ),
        ],
      ),
    );
  }

  Widget otherDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(height: 0),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "$label :",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value.isEmpty ? 'None' : value,
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

