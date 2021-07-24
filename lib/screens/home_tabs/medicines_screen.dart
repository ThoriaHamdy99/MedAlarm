import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:med_alarm/models/medicine2.dart';
import 'package:med_alarm/screens/medicine/view_medicine_screen.dart';
import 'package:med_alarm/service/alarm.dart';
import 'package:med_alarm/utilities/sql_helper.dart';

import '../medicine/add_medicine_screen.dart';

class MedicineScreen extends StatefulWidget {
  static const id = 'EMPTY_SCREEN';

  @override
  _MedicineScreenState createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  SQLHelper _sqlHelper = SQLHelper();
  ValueNotifier<List<Medicine>> medicines = ValueNotifier([]);
  List<int> isDeleted = [];
  bool isSwitched = true;

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
          'Your Medicines',
          style: TextStyle(
            // fontFamily: "Angel",
            // fontSize: 32,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              Navigator.of(context).pushNamed(AddMedicineScreen.id).whenComplete(() async {
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Medicine>>(
        future: _sqlHelper.getAllMedicines(),
        builder: (ctx, snapShot) {
          if (snapShot.hasData) {
            if (snapShot.data.isEmpty) {
              return Container(
                color: Color.fromRGBO(224, 240, 228, 0.5),
                width: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No medicine added until now",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      RaisedButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 110),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(AddMedicineScreen.id).whenComplete((){
                                setState(() {});
                          });
                        },
                        child: Text(
                          "Add Medicine",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        color: Theme.of(context).accentColor,
                      )
                    ],
                  ),
                ),
              );
            }else{
              medicines.value = snapShot.data;
              return ValueListenableBuilder<List<Medicine>>(
                valueListenable: medicines,
                builder: (context, value, _) {
                  return Container(
                    width: double.infinity,
                    color: Color.fromRGBO(224, 240, 228, 0.5),
                    child: ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return medCard(medicines.value[index], context);
                      },
                    ),
                  );
                },
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget medCard(Medicine med, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      child: FocusedMenuHolder(
        onPressed: () {},
        blurSize: 0,
        blurBackgroundColor: Colors.white,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 15),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset('./assets/meds_icons/${med.medType}.jpg'),
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${med.medName}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                med.interval,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(width: 10),
              Switch(
                value: med.isOn,
                activeColor: Theme.of(context).accentColor,
                inactiveThumbColor: Colors.white12,
                onChanged: (value) async {
                  setState(() {
                    med.isOn = value;
                    print(value.toString());
                    print('Switch');
                  });
                  await _sqlHelper.updateMedicine(med);
                  value ? await Alarm.setAlarm(med) : await Alarm.pauseAlarm(med);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Alarm is now ' + (value ? 'ON' : 'OFF')),
                    duration: Duration(seconds: 1),
                    backgroundColor: Theme.of(context).accentColor,
                  ));
                },
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => ViewMedicineScreen(med)
              ),
            ).whenComplete((){setState(() {});});
          },
        ),
        menuItems: [
          FocusedMenuItem(
            onPressed: () async {
              await confirmDeleteMed(context, med);
              setState(() {});
            },
            title: Text('Delete', style: TextStyle(color: Colors.black)),
            trailingIcon: Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }

  confirmDeleteMed(BuildContext context, Medicine med) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 10,
        title: Text(
          "Delete ${med.medName}",
          style: TextStyle(
            // color: Theme.of(context).errorColor,
            fontSize: 22,
          ),
        ),
        content: Text(
          "Are you sure?",
          style: TextStyle(color: Colors.black54, fontSize: 20),
        ),
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              )),
          FlatButton(
            child: Text(
              "Ok",
              style: TextStyle(
                color: Theme.of(context).errorColor,
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              String msg = 'Medicine deleted successfully';
              try {
                await SQLHelper.getInstant().deleteMedicine(med.id);
                setState(() {});
              } catch (e) {
                msg = 'Medicine hasn\'t deleted';
              }
              try {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(msg),
                  duration: Duration(seconds: 3),
                  backgroundColor: Theme
                      .of(context)
                      .accentColor,
                ));
              } catch (e) {}
            },
          ),
        ],
      ),
    );
  }
}
