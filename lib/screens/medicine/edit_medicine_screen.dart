import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:med_alarm/models/medicine2.dart';
import 'package:med_alarm/service/alarm.dart';
import 'package:med_alarm/utilities/sql_helper.dart';
import 'package:validators/validators.dart';

final _formKey = new GlobalKey<FormState>();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class EditMedicineScreen extends StatefulWidget {
  final Medicine med;

  EditMedicineScreen(this.med);

  @override
  _EditMedicineScreenState createState() => _EditMedicineScreenState();
}

class _EditMedicineScreenState extends State<EditMedicineScreen> {
  Medicine medInfo;
  String dropDownValue = 'Pills';
  String durationValue = 'once';
  int dropDownValueDoses = 6;
  var doses = [6, 8, 12, 24];
  var items = ['Pills', 'Syrup', 'Solutions', 'Injections', 'Drops', 'Powder', 'Other'];
  var durationItems = ['once', 'daily', 'weekly', 'monthly'];
  bool isDaily = false;
  var dropnDoses6H = [2, 3, 4];
  var dropnDoses8H = [2, 3];
  var dropnDosesValue = 2;

  get tfBorder =>
      OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      );

  get tfFBorder =>
      OutlineInputBorder(
        borderSide: BorderSide(color: Theme
            .of(context)
            .accentColor, width: 2),
      );

  void _submit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MedReminderDetails(medInfo),
        ),
      );
    } else {
      print('form is invalid');
    }
  }

  @override
  void initState() {
    medInfo = Medicine.fromMapString(widget.med.toMapString());
    dropDownValue = medInfo.medType;
    durationValue = medInfo.interval;
    dropDownValueDoses = medInfo.intervalTime;
    isDaily = medInfo.interval == 'daily';
    dropnDosesValue = medInfo.nDoses;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          "Edit Details",
          style: TextStyle(),
        ),
        actions: [
          FlatButton(
            child: Text(
              'Delete',
              style: TextStyle(fontSize: 16, color: Theme
                  .of(context)
                  .errorColor),
            ),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  elevation: 10,
                  title: Text(
                    "Delete ${medInfo.medName}",
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
                          await SQLHelper.getInstant().deleteMedicine(medInfo.id);
                          Navigator.pop(context);
                          Navigator.pop(context);
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
            },
          ),
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  medNameTextField(),
                  medTypeDDL(),
                  medAmountTextField(),
                  doseAmountTextField(),
                  intervalDDL(),
                  dailyIntervalDDL(),
                  descriptionTextField(),
                  nextButton(context, _submit),
                ],
              ),
            ),
          )),
    );
  }

  Widget nextButton(BuildContext context, void _submit()) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: RaisedButton(
        elevation: 10,
        padding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 25,
        ),
        textColor: Colors.white,
        color: Theme
            .of(context)
            .accentColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0)),
        onPressed: () {
          _submit();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Next",
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
              ),
            ),
            Icon(Icons.arrow_forward)
          ],
        ),
      ),
    );
  }

  Widget dailyIntervalDDL() {
    return Visibility(
      visible: isDaily,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PanelTitle(
              title: "Daily interval (Hours):",
              isRequired: false,
            ),
            DropdownButton(
              value: dropDownValueDoses,
              icon: Icon(Icons.keyboard_arrow_down),
              items: doses.map((int item) {
                return DropdownMenuItem(
                    value: item, child: Text(item.toString()));
              }).toList(),
              onChanged: (var newValue) {
                // if (newValue != null) {
                setState(() {
                  dropDownValueDoses = newValue;
                  dropnDosesValue = (24 / newValue).round();
                });
                // }
                medInfo.intervalTime = dropDownValueDoses;
              },
              style: TextStyle(
                fontSize: 18,
                // fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget intervalDDL() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PanelTitle(
            title: "Alarm Type:",
            isRequired: false,
          ),
          DropdownButton(
            value: durationValue,
            icon: Icon(Icons.keyboard_arrow_down),
            items: durationItems.map((String item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
            onChanged: (var newValue) {
              if (newValue != null) {
                setState(() {
                  durationValue = newValue as String;
                  if (durationValue != 'daily') {
                    isDaily = false;
                    dropDownValueDoses = 6;
                    dropnDosesValue = 4;
                  }
                  else
                    isDaily = true;
                });
              }
              medInfo.interval = durationValue;
            },
            style: TextStyle(
              fontSize: 18,
              // fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget medTypeDDL() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PanelTitle(
            title: "Medicine Type:",
            isRequired: false,
          ),
          DropdownButton(
            value: dropDownValue,
            icon: Icon(Icons.keyboard_arrow_down),
            items: items.map((String item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
            onChanged: (var newValue) {
              if (newValue != null) {
                setState(() {
                  dropDownValue = newValue;
                });
              }
              medInfo.medType = dropDownValue;
            },
            style: TextStyle(
              fontSize: 18,
              // fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget medNameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        initialValue: medInfo.medName,
        validator: (value) {
          if (value.isEmpty) return "Medicine name can't be empty";
          return null;
        },
        onChanged: (String value) {
          medInfo.medName = value;
        },
        decoration: InputDecoration(
          border: tfBorder,
          focusedBorder: tfFBorder,
          labelText: "Medicine Name",
          hintText: "Medicine Name",
        ),
      ),
    );
  }

  Widget medAmountTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        initialValue: '${medInfo.medAmount}',
        validator: (value) {
          if (!isNumeric(value)) return "Enter numbers only";
          if (value.isEmpty) return "Available Medicine amount can't be empty";
          return null;
        },
        onChanged: (String value) {
          medInfo.medAmount = int.parse(value);
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: tfBorder,
          focusedBorder: tfFBorder,
          labelText: "Medicine Amount",
          hintText: "Medicine Amount",
        ),
      ),
    );
  }

  Widget doseAmountTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        initialValue: '${medInfo.doseAmount}',
        validator: (value) {
          if (!isNumeric(value)) return "Enter numbers only";
          if (value.isEmpty) return "Dose amount can't be empty";
          return null;
        },
        onChanged: (String value) {
          medInfo.doseAmount = int.parse(value);
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: tfBorder,
          focusedBorder: tfFBorder,
          labelText: "Dose Amount",
          hintText: "Dose Amount",
        ),
      ),
    );
  }

  Widget descriptionTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        onChanged: (String value) {
          medInfo.description = value;
        },
        decoration: InputDecoration(
          border: tfBorder,
          focusedBorder: tfFBorder,
          labelText: "Notes (Optional)",
          hintText: "Notes (Optional)",
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
          "Would you like to delete medicine?",
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
            onPressed: () async {},
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
}

class PanelTitle extends StatelessWidget {
  final String title;
  final bool isRequired;

  PanelTitle({
    Key key,
    @required this.title,
    @required this.isRequired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: 4),
      child: Text.rich(
        TextSpan(children: <TextSpan>[
          TextSpan(
            text: title,
            style: TextStyle(
                fontSize: 24, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: isRequired ? "*" : "",
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        ]),
      ),
    );
  }
}

class MedReminderDetails extends StatefulWidget {
  final Medicine medInfo;

  MedReminderDetails(this.medInfo);

  @override
  _MedReminderDetailsState createState() => _MedReminderDetailsState();
}

class _MedReminderDetailsState extends State<MedReminderDetails> {
  SQLHelper _sqlHelper = SQLHelper();
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
        elevation: 5,
        centerTitle: true,
        title: Text("Edit Medicine",),
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: PanelTitle(
                    title: "Pick up Start date",
                    isRequired: false,
                  ),
                ),
                Text(
                  DateFormat.yMMMd().format(widget.medInfo.startDate),
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
                  child: Icon(Icons.date_range),
                  onPressed: () =>
                      showRoundedDatePicker(
                        context: context,
                        theme: Theme.of(context),
                        initialDate: widget.medInfo.startDate,
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
                            widget.medInfo.startDate = dateTime;
                            if (widget.medInfo.startDate.toIso8601String().substring(0 ,10).compareTo(
                                widget.medInfo.endDate.toIso8601String().substring(0 ,10)) >= 0)
                              widget.medInfo.endDate = widget.medInfo.startDate.add(Duration(days: 1));
                          });
                          return available;
                        },
                      ),
                ),
                if(widget.medInfo.interval != 'once')
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: PanelTitle(
                      title: "Pick up end date",
                      isRequired: false,
                    ),
                  ),
                if(widget.medInfo.interval != 'once')
                  Text(
                    DateFormat.yMMMd().format(widget.medInfo.endDate),
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                if(widget.medInfo.interval != 'once')
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
                          initialDate: widget.medInfo.endDate,
                          firstDate: widget.medInfo.startDate.add(Duration(days: 1)),
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
                              widget.medInfo.endDate = dateTime.add(Duration(seconds: 60*60*24-1));
                            });
                            return available;
                          },
                        ),
                  ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: PanelTitle(
                      title: "Pick up time for first reminder",
                      isRequired: false,
                    )),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TimePickerSpinner(
                    time: widget.medInfo.startTime,
                    is24HourMode: false,
                    normalTextStyle: TextStyle(
                      fontSize: 22,
                      color: Colors.grey,
                    ),
                    highlightedTextStyle:
                    TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                    spacing: 45,
                    itemHeight: 40,
                    isForce2Digits: true,
                    onTimeChange: (time) {
                      widget.medInfo.startTime = time;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RaisedButton(
                    elevation: 10,
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 130,
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    onPressed: () async {
                      try {
                        await _sqlHelper.deleteMedicineUpcomingDoses(widget.medInfo.id);
                        await _sqlHelper.updateMedicine(widget.medInfo);
                        await _sqlHelper.insertDosesAfterDate(widget.medInfo, DateTime.now());
                        if(widget.medInfo.isOn)
                          await Alarm.updateAlarm(widget.medInfo);
                        Navigator.pop(context);
                        Navigator.pop(context, widget.medInfo);
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                          duration: Duration(seconds: 3),
                          backgroundColor: Theme.of(context).errorColor,
                        ));
                      }
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(
                        fontFamily: "Angel",
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
