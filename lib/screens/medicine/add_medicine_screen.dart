import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:med_alarm/models/medicine2.dart';
import 'package:med_alarm/screens/home_screen.dart';
import 'package:med_alarm/service/alarm.dart';
import 'package:med_alarm/utilities/sql_helper.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:validators/validators.dart';

final _formKey = new GlobalKey<FormState>();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class AddMedicineScreen extends StatefulWidget {
  static const id = 'MED_DETAILS_SCREEN';

  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  SQLHelper _sqlHelper = SQLHelper.getInstant();
  Medicine medInfo = Medicine();
  String dropDownValue = 'Pills';
  String durationValue = 'once';
  int dropDownValueDoses = 6;
  var doses = [6, 8, 12, 24];
  var items = ['Pills', 'Syrup', 'Solutions', 'Injections', 'Drops', 'Powder', 'Other'];
  var durationItems = ['once', 'daily', 'weekly', 'monthly'];
  bool isDaily = false;
  DateTime _startTime = DateTime.now();

  get tfBorder => OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.circular(10),
  );

  get tfFBorder => OutlineInputBorder(
    borderSide: BorderSide(color: Theme.of(context).accentColor,width: 2),
  );

  @override
  void initState() {
    medInfo.medType = dropDownValue;
    medInfo.interval = durationValue;
    medInfo.intervalTime = dropDownValueDoses;
    medInfo.nDoses = 4;
    medInfo.description = '';
    medInfo.isOn = true;
    medInfo.startDate =
        DateTime.parse(DateTime.now().toIso8601String().substring(0,10));
    medInfo.endDate =
        medInfo.startDate.add(Duration(days: 1, seconds: -1));
    medInfo.startTime = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
          "Medicine Details",
          style: TextStyle(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                medNameTextField(),
                medTypeDDL(),
                medAmountTextField(),
                doseAmountTextField(),
                intervalDDL(),
                dailyIntervalDDL(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    startDatePicker(),
                    if(medInfo.interval != 'once')
                      Container(
                        height: 70,
                        width: 0.7,
                        color: Colors.grey,
                      ),
                    if(medInfo.interval != 'once')
                      endDatePicker(),
                  ],
                ),
                startTimePicker(context),
                descriptionTextField(),
                submitButton(),
              ],
            ),
          ),
        )
      ),
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
                setState(() {
                  dropDownValueDoses = newValue;
                  medInfo.nDoses = (24 / newValue).round();
                });
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
                    medInfo.nDoses = 4;
                  }
                  else isDaily = true;
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

  Widget startDatePicker() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: PanelTitle(
            title: "Start date",
            isRequired: false,
          ),
        ),
        Text(
          DateFormat.yMMMd().format(medInfo.startDate),
          style: TextStyle(
            fontSize: 15,
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
          onPressed: () =>
              showRoundedDatePicker(
                context: context,
                theme: Theme.of(context),
                initialDate: medInfo.startDate,
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
                            onPressed: () {
                              setState(() {medInfo.startDate = medInfo.startDate;});
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  setState(() {
                    medInfo.startDate = dateTime;
                    if (medInfo.startDate.toIso8601String().substring(0 ,10).compareTo(
                        medInfo.startDate.toIso8601String().substring(0 ,10)) >= 0)
                      medInfo.endDate = medInfo.startDate.add(Duration(days: 1, seconds: -1));
                  });
                  return available;
                },
              ),
        ),
      ],
    );
  }

  Widget endDatePicker() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: PanelTitle(
            title: "End date",
            isRequired: false,
          ),
        ),
        Text(
          DateFormat.yMMMd().format(medInfo.endDate),
          style: TextStyle(
            fontSize: 15,
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
          onPressed: () =>
              showRoundedDatePicker(
                context: context,
                theme: Theme.of(context),
                initialDate: medInfo.endDate,
                firstDate: medInfo.startDate,
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
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  setState(() {
                    medInfo.endDate = DateTime.parse(dateTime.toIso8601String().substring(0, 10));
                    medInfo.endDate = medInfo.endDate.add(Duration(days: 1, seconds: -1));
                    print(medInfo.endDate);
                  });
                  return available;
                },
              ),
        ),
      ],
    );
  }

  Padding startTimePicker(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.0, left: 10.0, right: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PanelTitle(
            title: "Reminder Time",
            isRequired: false,
          ),
          Text(
            DateFormat.jm().format(medInfo.startTime),
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
                        "When to take this medicine?",
                        style: TextStyle(
                            color:
                            Theme.of(context).accentColor),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TimePickerSpinner(
                            is24HourMode: false,
                            time: medInfo.startTime,
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
                                _startTime = time;
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
                              setState(() {medInfo.startTime = _startTime;});
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

  Widget submitButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: RaisedButton(
        elevation: 5,
        padding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 130,
        ),
        textColor: Colors.white,
        color: Theme.of(context).accentColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0)),
        onPressed: () async {
          await _submit();
        },
        child: Text(
          "Add",
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _submit() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      try {
        if (isSameDay(medInfo.startDate, medInfo.startTime)) {
          print(medInfo.startTime);
          print(DateTime.now());
          if(medInfo.startTime.difference(
              DateTime.now()
          ).inSeconds < 0) {
            throw 'Choose time after now';
          }
        }
        // await _sqlHelper.insertDummyData();
        await _sqlHelper.insertMedicine(medInfo);
        await _sqlHelper.insertDosesAfterDate(medInfo, medInfo.startDate);
        await Alarm.setAlarm(await _sqlHelper
            .getMedicine(medInfo.medName));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Medicine added successfully'),
          duration: Duration(seconds: 3),
          backgroundColor: Theme.of(context).accentColor,
        ));
        while (Navigator.of(context).canPop())
          Navigator.pop(context);
        Navigator.pushReplacementNamed(
            context, HomeScreen.id);
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 3),
          backgroundColor: Theme.of(context).errorColor,
        ));
      }
    } else {
      print('form is invalid');
    }
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

// class MedReminderDetails extends StatefulWidget {
//   final Medicine medInfo;
//
//   MedReminderDetails(this.medInfo);
//
//   @override
//   _MedReminderDetailsState createState() => _MedReminderDetailsState();
// }
//
// class _MedReminderDetailsState extends State<MedReminderDetails> {
//   SQLHelper _sqlHelper = SQLHelper();
//   bool beforeNow = true;
//
//   @override
//   void initState() {
//     setState(() {
//       medInfo.startDate =
//           DateTime.parse(DateTime.now().toIso8601String().substring(0,10));
//       medInfo.endDate =
//           medInfo.startDate.add(Duration(days: 1, seconds: -1));
//       medInfo.startTime = DateTime.now();
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(20),
//             bottomRight: Radius.circular(20),
//           ),
//         ),
//         elevation: 5,
//         centerTitle: true,
//         title: Text("Medicine Details",),
//       ),
//       body: Center(
//         child: Container(
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: PanelTitle(
//                     title: "Pick up Start date",
//                     isRequired: false,
//                   ),
//                 ),
//                 Text(
//                   DateFormat.yMMMd().format(medInfo.startDate),
//                   style: TextStyle(
//                     fontSize: 15,
//                   ),
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     shape: new RoundedRectangleBorder(
//                       borderRadius: new BorderRadius.circular(50.0),
//                     ),
//                     primary:
//                     Theme
//                         .of(context)
//                         .accentColor, // background
//                     onPrimary: Colors.white, // foreground
//                   ),
//                   child: new Icon(Icons.date_range),
//                   onPressed: () =>
//                     showRoundedDatePicker(
//                       context: context,
//                       theme: Theme.of(context),
//                       initialDate: medInfo.startDate,
//                       firstDate: DateTime.now().subtract(Duration(days: 1)),
//                       lastDate: DateTime(DateTime.now().year + 10),
//                       borderRadius: 16,
//                       onTapDay: (DateTime dateTime, bool available) {
//                         if (!available) {
//                           showDialog(
//                             context: context,
//                             builder: (c) => AlertDialog(
//                               title: Text("This date cannot be selected."),
//                               actions: <Widget>[
//                                 CupertinoDialogAction(
//                                   child: Text("OK"),
//                                   onPressed: () => Navigator.pop(context),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }
//                         setState(() {
//                           medInfo.startDate = dateTime;
//                           if (medInfo.startDate.toIso8601String().substring(0 ,10).compareTo(
//                               medInfo.endDate.toIso8601String().substring(0 ,10)) >= 0)
//                             medInfo.endDate = medInfo.startDate.add(Duration(days: 1));
//                         });
//                         return available;
//                       },
//                     ),
//                 ),
//                 if(medInfo.interval != 'once')
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: PanelTitle(
//                     title: "Pick up end date",
//                     isRequired: false,
//                   ),
//                 ),
//                 if(medInfo.interval != 'once')
//                 Text(
//                   DateFormat.yMMMd().format(medInfo.endDate),
//                   style: TextStyle(
//                     fontSize: 15,
//                   ),
//                 ),
//                 if(medInfo.interval != 'once')
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     shape: new RoundedRectangleBorder(
//                       borderRadius: new BorderRadius.circular(50.0),
//                     ),
//                     primary: Theme.of(context).accentColor,
//                     onPrimary: Colors.white,
//                   ),
//                   child: new Icon(Icons.date_range),
//                   onPressed: () =>
//                     showRoundedDatePicker(
//                       context: context,
//                       theme: Theme.of(context),
//                       initialDate: medInfo.endDate,
//                       firstDate: medInfo.startDate.add(Duration(days: 1)),
//                       lastDate: DateTime(DateTime.now().year + 10),
//                       borderRadius: 16,
//                       onTapDay: (DateTime dateTime, bool available) {
//                         if (!available) {
//                           showDialog(
//                             context: context,
//                             builder: (_) => AlertDialog(
//                               title: Text("This date cannot be selected."),
//                               actions: <Widget>[
//                                 CupertinoDialogAction(
//                                   child: Text("OK"),
//                                   onPressed: () => Navigator.pop(context),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }
//                         setState(() {
//                           medInfo.endDate = dateTime.add(Duration(seconds: 60*60*24-1));
//                         });
//                         return available;
//                       },
//                     ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 10, vertical: 10),
//                   child: PanelTitle(
//                     title: "Pick up time for first reminder",
//                     isRequired: false,
//                   )),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: TimePickerSpinner(
//                     is24HourMode: false,
//                     normalTextStyle: TextStyle(
//                         fontSize: 22,
//                         color: Colors.grey,
//                     ),
//                     highlightedTextStyle:
//                     TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).accentColor,
//                     ),
//                     spacing: 45,
//                     itemHeight: 40,
//                     isForce2Digits: true,
//                     onTimeChange: (time) {
//                         medInfo.startTime = time;
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: RaisedButton(
//                     elevation: 10,
//                     padding: EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 130,
//                     ),
//                     textColor: Colors.white,
//                     color: Theme.of(context).accentColor,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(50.0)),
//                     onPressed: () async {
//                       try {
//                         if (isSameDay(medInfo.startDate, medInfo.startTime)) {
//                           print(medInfo.startTime);
//                           print(DateTime.now());
//                           if(medInfo.startTime.difference(
//                               DateTime.now()
//                           ).inSeconds < 0) {
//                             throw 'Choose time after now';
//                           }
//                         }
//                         // await _sqlHelper.insertDummyData();
//                         await _sqlHelper.insertMedicine(medInfo);
//                         await _sqlHelper.insertDosesAfterDate(medInfo, medInfo.startDate);
//                         await Alarm.setAlarm(await _sqlHelper
//                             .getMedicine(medInfo.medName));
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text('Medicine added successfully'),
//                           duration: Duration(seconds: 3),
//                           backgroundColor: Theme.of(context).accentColor,
//                         ));
//                         while (Navigator.of(context).canPop())
//                           Navigator.pop(context);
//                         Navigator.pushReplacementNamed(
//                             context, HomeScreen.id);
//                       } catch (e) {
//                         print(e);
//                         Navigator.pop(context);
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text(e.toString()),
//                           duration: Duration(seconds: 3),
//                           backgroundColor: Theme.of(context).errorColor,
//                         ));
//                       }
//                     },
//                     child: Text(
//                       "Done",
//                       style: TextStyle(
//                         fontFamily: "Angel",
//                         fontSize: 28,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
