import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';
import 'package:med_alarm/models/medicine2.dart';

class SelectedMed extends StatefulWidget {
  static const id = 'SELECTED_MED';
  Medicine sMedicine;
  SelectedMed(this.sMedicine);

  @override
  _SelectedMedState createState() => _SelectedMedState(this.sMedicine);
}

class _SelectedMedState extends State<SelectedMed> {
  Medicine sMedicine;
  _SelectedMedState(this.sMedicine);
  var isSwitched = true;
  DateTime _dateTime;
  var dropDosesInterval = [6, 8, 12, 24];
  var dropType = ['Pill', 'Solution', 'Injection', 'Drops', 'Powder', 'other'];
  var dropDurationItems = ['daily', 'weekly', 'monthly'];
  bool isDaily = true;
  var dropNDoses = [1, 2, 3, 4];
  var dropAmountDose = [1,2,3,4];

  String getTime(DateTime dateTime){
    var hours = dateTime.hour >= 0 && dateTime.hour <= 9 ? "0" + "${dateTime.hour}" : "${dateTime.hour}";
    var min = dateTime.minute >= 0 && dateTime.minute <= 9 ? "0" + "${dateTime.minute}" : "${dateTime.minute}";
    return hours + ":" + min;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .accentColor,
        iconTheme: IconThemeData(
          color: Color(0xFFF8F4F4),
        ),
        title: Text(
          "Edit Medication",
          style: TextStyle(
            fontFamily: "Angel",
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        height: double.infinity,
        color: Color.fromRGBO(224, 240, 228, 0.5),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 3.0, left: 10.0, right: 10.0),
                child: Card(
                  elevation: 3,
                  shadowColor: Colors.green,
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Medication Name",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor,
                        ),),
                        SizedBox(height: 8,),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty)
                              return "please enter name of medicine!!";
                            return null;
                          },
                          initialValue: "${sMedicine.medName}",
                          onSaved: (String value) {
                          },
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.0, left: 10.0, right: 10.0),
                child: Card(
                  elevation: 3,
                  shadowColor: Colors.green,
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Medication Type",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor,
                          ),),
                        SizedBox(height: 8,),
                        new DropdownButton(
                          value: sMedicine.medType,
                          icon: Icon(Icons.keyboard_arrow_down),
                          items: dropType.map((String item) {
                            return DropdownMenuItem(value: item, child: Text(item));
                          }).toList(),
                          onChanged: (var newValue) {
                            if (newValue != null) {
                              setState(() {
                                sMedicine.medType = newValue as String;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.0, left: 10.0, right: 10.0),
                child: Card(
                  elevation: 3,
                  shadowColor: Colors.green,
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Amount of Medicine",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor,
                          ),),
                        SizedBox(height: 8,),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty)
                              return "please enter amount of medicine!!";
                            return null;
                          },
                          initialValue: "${sMedicine.medAmount}",
                          onSaved: (value) {
                            setState(() {
                              sMedicine.medAmount = value as int;
                            });

                          },
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.0, left: 10.0, right: 10.0),
                child: Card(
                  elevation: 3,
                  shadowColor: Colors.green,
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Amount of each Dose",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor,
                          ),),
                        SizedBox(height: 8,),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty)
                              return "please enter amount of each dose!!";
                            return null;
                          },
                          initialValue: "${sMedicine.doseAmount}",
                          onSaved: (value) {
                            sMedicine.doseAmount = value as int;
                          },
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.0, left: 10.0, right: 10.0),
                child: Card(
                  elevation: 3,
                  shadowColor: Colors.green,
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Duration",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor,
                          ),),
                        SizedBox(height: 8,),
                        new DropdownButton(
                          value: sMedicine.interval,
                          icon: Icon(Icons.keyboard_arrow_down),
                          items: dropDurationItems.map((String item) {
                            return DropdownMenuItem(value: item, child: Text(item));
                          }).toList(),
                          onChanged: (var newValue) {
                            if (newValue != null) {
                              setState(() {
                                sMedicine.interval = newValue as String;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.0, left: 10.0, right: 10.0),
                child: Card(
                  elevation: 3,
                  shadowColor: Colors.green,
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Number of Doses",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor,
                          ),),
                        SizedBox(height: 8,),
                        new DropdownButton(
                          value: sMedicine.numOfDoses,
                          icon: Icon(Icons.keyboard_arrow_down),
                          items: dropNDoses.map((item) {
                            return DropdownMenuItem(value: item, child: Text("$item"));
                          }).toList(),
                          onChanged: (var newValue) {
                            if (newValue != null) {
                              setState(() {
                                sMedicine.numOfDoses = newValue;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.0, left: 10.0, right: 10.0),
                child: Card(
                  elevation: 3,
                  shadowColor: Colors.green,
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hours between each Dose",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor,
                          ),),
                        SizedBox(height: 8,),
                        new DropdownButton(
                          value: sMedicine.intervalTime,
                          icon: Icon(Icons.keyboard_arrow_down),
                          items: dropDosesInterval.map((item) {
                            return DropdownMenuItem(value: item, child: Text("$item"));
                          }).toList(),
                          onChanged: (var newValue) {
                            if (newValue != null) {
                              setState(() {
                                sMedicine.intervalTime = newValue;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.0, left: 10.0, right: 10.0),
                child: Card(
                  elevation: 3,
                  shadowColor: Colors.green,
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text("Reminder Times",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).accentColor,
                                ),),
                            ),
                            Switch(
                              value: isSwitched,
                              onChanged: (value){
                                setState(() {
                                  isSwitched = value;
                                });
                              },
                              activeColor: Theme.of(context).accentColor,
                              inactiveThumbColor: Colors.white12,

                            ),
                          ],
                        ),
                        SizedBox(height: 8,),
                        FlatButton(
                            onPressed: (){
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      elevation: 10,
                                      title: Text("When do you need to take this medicine?",
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor
                                      ),),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TimePickerSpinner(
                                            is24HourMode: false,
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
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        FlatButton(
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                            child: Text("Cancel")
                                        ),
                                        FlatButton(
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                            child: Text("Done")
                                        ),
                                      ],
                                    );
                                  }
                                  );
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text("${getTime(sMedicine.startTime)}",
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Theme.of(context).accentColor,
                                    ),),
                                ),
                              ],
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.0, left: 10.0, right: 10.0),
                child: Text(
                  "Start date",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),
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
                  Theme
                      .of(context)
                      .accentColor, // background
                  onPrimary: Colors.white, // foreground
                ),
                child: new Icon(Icons.date_range),
                onPressed: () =>
                    showRoundedDatePicker(
                      context: context,
                      theme: Theme.of(context),
                      initialDate: sMedicine.startDate,
                      firstDate: DateTime.now().subtract(Duration(days: 1)),
                      lastDate: DateTime(DateTime.now().year + 10),
                      borderRadius: 16,
                      onTapDay: (DateTime dateTime, bool available) {
                        if (!available) {
                          showDialog(
                            context: context,
                            builder: (c) => AlertDialog(
                              title: Text("This date cannot be selected."),
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
                          if (sMedicine.startDate.toIso8601String().substring(0 ,10).compareTo(
                              sMedicine.endDate.toIso8601String().substring(0 ,10)) >= 0)
                            sMedicine.endDate = sMedicine.startDate.add(Duration(days: 1));
                        });
                        return available;
                      },
                    ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.0, left: 10.0, right: 10.0),
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
                onPressed: () =>
                    showRoundedDatePicker(
                      context: context,
                      theme: Theme.of(context),
                      initialDate: sMedicine.endDate,
                      firstDate: sMedicine.startDate.add(Duration(days: 1)),
                      lastDate: DateTime(DateTime.now().year + 10),
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
              RaisedButton(
                padding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: 110),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  print(sMedicine.medName);
                  print(sMedicine.medType);
                  print(sMedicine.medAmount);
                  print(sMedicine.doseAmount);
                  print(sMedicine.intervalTime);
                  print(sMedicine.interval);
                  print(sMedicine.numOfDoses);
                  print(sMedicine.startTime);
                  print(sMedicine.startDate);
                  print(sMedicine.endDate);
                },
                child: Text(
                  "Update Medicine",
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
      ),
    );
  }
}
