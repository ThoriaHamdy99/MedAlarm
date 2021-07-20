import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';
import 'package:med_alarm/models/medicine2.dart';
import 'package:med_alarm/screens/medicine/medicine_info.dart';
import 'package:med_alarm/utilities/sql_helper.dart';

class EditMedicine extends StatefulWidget {
  static const id = 'EDIT_MEDICINE_SCREEN';
  final Medicine sMedicine;

  EditMedicine(this.sMedicine);

  @override
  _EditMedicineState createState() => _EditMedicineState(this.sMedicine);
}

class _EditMedicineState extends State<EditMedicine> {
  Medicine sMedicine;

  _EditMedicineState(this.sMedicine);

  String oldMedName;
  var medNameController;
  var medAmountController;
  var doseAmountController;

  SQLHelper _sqlHelper = SQLHelper();
  final _globalKey = GlobalKey<FormState>();
  var isSwitched = true;
  DateTime _dateTime;

  bool isDaily = true;
  bool circular = false;

  get tfBorder => OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      );

  get tfFBorder => OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2),
      );

  @override
  void initState() {
    oldMedName = sMedicine.medName;
    medNameController = TextEditingController(text: sMedicine.medName);
    medAmountController = TextEditingController(text: "${sMedicine.medAmount}");
    doseAmountController = TextEditingController(text: "${sMedicine.doseAmount}");
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
        title: Text(
          "Edit Medication",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              child: Text(
                "Delete",
                style: TextStyle(fontSize: 20, color: Colors.redAccent),
              ),
              onPressed: () async {
                await confirmDeleteMed(context);
              },
            ),
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        color: Color.fromRGBO(224, 240, 228, 0.5),
        width: double.infinity,
        child: Form(
          key: _globalKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                medNameTextFormField(),
                SizedBox(height: 20,),
                medAmountTextFormField(),
                SizedBox(height: 20,),
                doseAmountTextFormField(),
                SizedBox(height: 20,),
                medTypeDropdown(),
                durationDropdown(),
                numDosesDropdown(),
                intervalTimeDropdown(),
                //------------------
                startTimePicker(context),
                //--------------------
                startDatePicker(context),
                endDatePicker(context),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () async{
                    if (_globalKey.currentState.validate()){
                      sMedicine.medName = medNameController.text;
                      sMedicine.medAmount =  int.parse(medAmountController.text);
                      sMedicine.doseAmount = int.parse(doseAmountController.text);
                      await _sqlHelper.updateMedicine(sMedicine, oldMedName);
                      setState(() {
                        circular = true;
                      });
                      Navigator.of(context).pop();
                      // Navigator.of(context).pushReplacementNamed(MedicineInfo.id);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: 50,
                    child: Center(
                      child: circular
                          ? CircularProgressIndicator(color: Colors.white,)
                          : Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  color: Theme.of(context).accentColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  confirmDeleteMed(BuildContext context) async {
    showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      elevation: 10,
                      title: Text(
                        "Delete medicine!",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 23,
                        ),
                      ),
                      content: Text(
                        "Would you like to delete ${sMedicine.medName} medicine?",
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
                                color: Colors.redAccent,
                              ),
                            )),
                        FlatButton(
                            onPressed: () async {
                              try {
                                await _sqlHelper
                                    .deleteMedicine(sMedicine.medName);
                                //await _sqlHelper.getMedicine(sMedicine.medName);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                setState(() {});
                              } catch (e) {}
                            },
                            child: Text(
                              "Ok",
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            )),
                      ],
                    );
                  });
  }

  //--------------------------------------------------
  Padding startTimePicker(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.0, left: 10.0, right: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Reminder Time",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            DateFormat.Hm().format(sMedicine.startTime),
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          SizedBox(width: 20,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(50.0),
              ),
              primary: Theme.of(context).accentColor,
              onPrimary: Colors.white,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      elevation: 10,
                      title: Text(
                        "When do you need to take this medicine?",
                        style: TextStyle(
                            color:
                            Theme.of(context).accentColor),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TimePickerSpinner(
                            is24HourMode: false,
                            time: sMedicine.startTime,
                            normalTextStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.black26),
                            highlightedTextStyle:
                            TextStyle(fontSize: 25),
                            spacing: 40,
                            itemHeight: 40,
                            isForce2Digits: true,
                            onTimeChange: (time) {
                              setState(() {
                                _dateTime = time;
                                sMedicine.startTime = _dateTime;
                              });
                            },
                          ),
                        ],
                      ),
                      actions: [
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel")),
                        FlatButton(
                            onPressed: () {
                              sMedicine.startTime = _dateTime;
                              Navigator.pop(context);
                            },
                            child: Text("Done")),
                      ],
                    );
                  });
            },
            child: Icon(
                Icons.timer_outlined
            ),
          ),
        ],
      ),
    );
  }
  //--------------------------------------------------
  Padding endDatePicker(BuildContext context) {
    return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 3.0, left: 10.0, right: 10.0),
                        child: Text(
                          "End date",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        DateFormat.yMMMd().format(sMedicine.endDate),
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50.0),
                          ),
                          primary: Theme.of(context).accentColor,
                          onPrimary: Colors.white,
                        ),
                        child: new Icon(Icons.date_range),
                        onPressed: () => showRoundedDatePicker(
                          context: context,
                          theme: Theme.of(context),
                          initialDate: sMedicine.endDate,
                          firstDate:
                              sMedicine.startDate.add(Duration(days: 1)),
                          lastDate: DateTime(DateTime.now().year + 10),
                          borderRadius: 16,
                          onTapDay: (DateTime dateTime, bool available) {
                            if (!available) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title:
                                      Text("This date cannot be selected."),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text("OK"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              );
                            }
                            setState(() {
                              sMedicine.endDate = dateTime;
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
  //--------------------------------------------------
  Padding startDatePicker(BuildContext context) {
    return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 3.0, left: 10.0, right: 10.0),
                        child: Text(
                          "Start date",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        DateFormat.yMMMd().format(sMedicine.startDate),
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50.0),
                          ),
                          primary:
                              Theme.of(context).accentColor, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        child: new Icon(Icons.date_range),
                        onPressed: () => showRoundedDatePicker(
                          context: context,
                          theme: Theme.of(context),
                          initialDate: sMedicine.startDate,
                          firstDate:
                              DateTime.now().subtract(Duration(days: 1)),
                          lastDate: DateTime(DateTime.now().year + 10),
                          borderRadius: 16,
                          onTapDay: (DateTime dateTime, bool available) {
                            if (!available) {
                              showDialog(
                                context: context,
                                builder: (c) => AlertDialog(
                                  title:
                                      Text("This date cannot be selected."),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text("OK"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              );
                            }
                            setState(() {
                              sMedicine.startDate = dateTime;
                              if (sMedicine.startDate
                                      .toIso8601String()
                                      .substring(0, 10)
                                      .compareTo(sMedicine.endDate
                                          .toIso8601String()
                                          .substring(0, 10)) >=
                                  0)
                                sMedicine.endDate = sMedicine.startDate
                                    .add(Duration(days: 1));
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
  //--------------------------------------------------

  Padding intervalTimeDropdown(){
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Hours between each Dose       ', style: TextStyle(fontSize: 18,)),
          DropdownButton(
            value: sMedicine.intervalTime,
            items: <int>[6, 8, 12, 24,
            ].map((int value) {
              return DropdownMenuItem(
                  value: value, child: Text("${value}"));
            }).toList(),
            onChanged: (val) {
              setState(() {
                sMedicine.intervalTime = val;
              });
            },
          )
        ],
      ),
    );
  }
  //--------------------------------------------------
  Padding numDosesDropdown(){
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Number of Doses        ', style: TextStyle(fontSize: 18,)),
          DropdownButton(
            value: sMedicine.numOfDoses,
            items: <int>[1, 2, 3, 4,
            ].map((int value) {
              return DropdownMenuItem(
                  value: value, child: Text("${value}"));
            }).toList(),
            onChanged: (val) {
              setState(() {
                sMedicine.numOfDoses = val;
              });
            },
          )
        ],
      ),
    );
  }
  //--------------------------------------------------
  Padding durationDropdown(){
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Duration        ', style: TextStyle(fontSize: 18,)),
          DropdownButton(
            value: sMedicine.interval,
            items: <String>['daily', 'weekly', 'monthly',
            ].map((String value) {
              return DropdownMenuItem(
                  value: value, child: Text(value));
            }).toList(),
            onChanged: (val) {
              setState(() {
                sMedicine.interval = val;
              });
            },
          )
        ],
      ),
    );
  }
  //--------------------------------------------------
  Padding medTypeDropdown() {
    return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Medication Type        ', style: TextStyle(fontSize: 18,)),
                    DropdownButton(
                      value: sMedicine.medType,
                      items: <String>[
                        'Pill',
                        'Solution',
                        'Injection',
                        'Drops',
                        'Powder',
                        'other'
                      ].map((String value) {
                        return DropdownMenuItem(
                            value: value, child: Text(value));
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          sMedicine.medType = val;
                        });
                      },
                    )
                  ],
                ),
              );
  }
  //--------------------------------------------------

  TextFormField doseAmountTextFormField() {
    return TextFormField(
                controller: doseAmountController,
                validator: (value) {
                  if (value.isEmpty) return "Dose amount can't be empty";
                  return null;
                },
                decoration: InputDecoration(
                  border: tfBorder,
                  focusedBorder: tfFBorder,
                  labelText: "Dose Amount",
                  hintText: "Dose Amount",
                  labelStyle: TextStyle(
                      fontSize: 23,
                    color: Colors.black,
                  ),
                ),
              );
  }
  //--------------------------------------------------
  TextFormField medAmountTextFormField() {
    return TextFormField(
                controller: medAmountController,
                validator: (value) {
                  if (value.isEmpty) return "Medicine amount can't be empty";
                  return null;
                },
                decoration: InputDecoration(
                  border: tfBorder,
                  focusedBorder: tfFBorder,
                  labelText: "Medicine Amount",
                  hintText: "Medicine Amount",
                  labelStyle: TextStyle(
                      fontSize: 23,
                    color: Colors.black,
                  ),
                ),
              );
  }
  //--------------------------------------------------
  TextFormField medNameTextFormField() {
    return TextFormField(
                controller: medNameController,
                validator: (value) {
                  if (value.isEmpty) return "Medicine name can't be empty";
                  return null;
                },
                decoration: InputDecoration(
                  border: tfBorder,
                  focusedBorder: tfFBorder,
                  labelText: "Medicine Name",
                  hintText: "Medicine Name",
                  labelStyle: TextStyle(
                    fontSize: 23,
                    color: Colors.black,
                  ),
                ),
              );
  }
  //--------------------------------------------------
}
