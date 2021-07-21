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
class MedDetails extends StatefulWidget {
  static const id = 'MED_DETAILS_SCREEN';

  @override
  _MedDetailsState createState() => _MedDetailsState();
}

class _MedDetailsState extends State<MedDetails> {


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
        // backgroundColor: Theme
        //     .of(context)
        //     .accentColor,
        // iconTheme: IconThemeData(
        //   color: Color(0xFFF8F4F4),
        // ),
        title: Text(
          "Medicine Details",
          style: TextStyle(
            // fontFamily: "Angel",
            // fontSize: 32,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        // color: Theme
        //     .of(context)
        //     .accentColor,
        child: _BottomContainer(),
      ),
    );
  }
}

class _BottomContainer extends StatefulWidget {
  @override
  _BottomContainerState createState() => _BottomContainerState();
}

class _BottomContainerState extends State<_BottomContainer> {
  Medicine medInfo = new Medicine();
  String dropDownValue = 'Pills';
  String durationValue = 'once';
  int dropDownValueDoses = 6;
  var doses = [6, 8, 12, 24];
  var items = ['Pills', 'Solutions', 'Injections', 'Drops', 'Powder', 'other'];
  var durationItems = ['once', 'daily', 'weekly', 'monthly'];
  bool isDaily = false;
  var dropnDoses6H = [2, 3, 4];
  var dropnDoses8H = [2, 3];
  var dropnDosesValue = 2;

  @override
  void initState() {
    medInfo.medType = dropDownValue;
    medInfo.interval = durationValue;
    medInfo.intervalTime = dropDownValueDoses;
    medInfo.numOfDoses = dropnDosesValue;
    medInfo.description = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PanelTitle(
                  title: "Medicine Name",
                  isRequired: true,
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty)
                      return "please enter name of medicine!!";
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                    medInfo.medName = value;

                    });
                  },
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter name of medicine',
                  ),
                ),
                PanelTitle(
                  title: "Medicine Type:",
                  isRequired: true,
                ),
                new DropdownButton(
                  value: dropDownValue,
                  icon: Icon(Icons.keyboard_arrow_down),
                  items: items.map((String item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  }).toList(),
                  onChanged: (var newValue) {
                    if (newValue != null) {
                      setState(() {
                        dropDownValue = newValue as String;
                      });
                    }
                    medInfo.medType = dropDownValue;
                  },
                ),
                PanelTitle(
                  title: "Amount of medicine",
                  isRequired: true,
                ),
                TextFormField(
                  validator: (value) {
                    if (!isNumeric(value))
                      return "please enter amount of medicine as a number";
                    else if (value.isEmpty)
                      return "please enter amount of medicine";
                    return null;
                  },
                  onChanged: (value) {
                    medInfo.medAmount = int.parse(value);
                  },
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter medicine amount',
                  ),
                ),
                PanelTitle(
                  title: "Amount of each dose",
                  isRequired: true,
                ),
                TextFormField(
                  validator: (value) {
                    if (!isNumeric(value))
                      return "please enter amount of dose as a number";
                    else if (value.isEmpty)
                      return "please enter amount of each dose";
                    else if (int.parse(value) > medInfo.medAmount)
                      return "Current med amount is not enough for next dose";
                    return null;
                  },
                  onChanged: (value) {
                    medInfo.doseAmount = int.parse(value);
                  },
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter dose amount',
                  ),
                ),
                // PanelTitle(
                //   title: "Amount of each dose",
                //   isRequired: true,
                // ),
                // new DropdownButton(
                //   value: dropAmountDoseValue,
                //   icon: Icon(Icons.keyboard_arrow_down),
                //   items: dropAmountDose.map((int item) {
                //     return DropdownMenuItem(
                //         value: item, child: Text(item.toString()));
                //   }).toList(),
                //   onChanged: (var newValue) {
                //     // if (newValue != null) {
                //     setState(() {
                //       dropAmountDoseValue = newValue;
                //     });
                //     // }
                //     medInfo.doseAmount = dropAmountDoseValue;
                //   },
                // ),
                PanelTitle(
                  title: "Duration",
                  isRequired: true,
                ),
                new DropdownButton(
                  value: durationValue,
                  icon: Icon(Icons.keyboard_arrow_down),
                  items: durationItems.map((String item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  }).toList(),
                  onChanged: (var newValue) {
                    if (newValue != null) {
                      setState(() {
                        durationValue = newValue as String;
                        if (durationValue != 'daily')
                          isDaily = false;
                        else isDaily = true;
                      });
                    }
                    medInfo.interval = durationValue;
                  },
                ),
                Visibility(
                  visible: isDaily,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PanelTitle(
                        title: "Hours between each dose",
                        isRequired: true,
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
                          });
                          // }
                          medInfo.intervalTime = dropDownValueDoses;
                        },
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: isDaily,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(medInfo.intervalTime == 6 || medInfo.intervalTime == 8)
                      PanelTitle(
                        title: "Number of doses per day",
                        isRequired: true,
                      ),
                      if(medInfo.intervalTime == 6)
                      DropdownButton(
                        value: dropnDosesValue,
                        icon: Icon(Icons.keyboard_arrow_down),
                        items: dropnDoses6H.map((int item) {
                          return DropdownMenuItem(
                              value: item, child: Text(item.toString()));
                        }).toList(),
                        onChanged: (newValue) {
                          // if (newValue != null) {
                          setState(() {
                            dropnDosesValue = newValue;
                          });
                          // }
                          medInfo.numOfDoses = dropnDosesValue;
                        },
                      ),
                      if(medInfo.intervalTime == 8)
                      DropdownButton(
                        value: dropnDosesValue,
                        icon: Icon(Icons.keyboard_arrow_down),
                        items: dropnDoses8H.map((int item) {
                          return DropdownMenuItem(
                              value: item, child: Text(item.toString()));
                        }).toList(),
                        onChanged: (newValue) {
                          // if (newValue != null) {
                          setState(() {
                            dropnDosesValue = newValue;
                          });
                          // }
                          medInfo.numOfDoses = dropnDosesValue;
                        },
                      ),
                    ],
                  ),
                ),

                Container(
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
                          " Next ",
                          style: TextStyle(
                            fontFamily: "Angel",
                            fontSize: 28,
                            color: Colors.white,
                          ),
                        ),
                        Icon(Icons.arrow_forward)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
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
 // String medname = medNameController.text;

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
        // backgroundColor: Theme
        //     .of(context)
        //     .accentColor,
        // iconTheme: IconThemeData(
        //   color: Color(0xFFF8F4F4),
        // ),
        centerTitle: true,
        title: Text(
          "Medicine Details",
          // style: TextStyle(
          //   fontFamily: "Angel",
          //   fontSize: 32,
          //   color: Colors.white,
          // ),
        ),
      ),
      body: Container(
        // color: Theme
        //     .of(context)
        //     .accentColor,
        child: Container(
          child: _ReminderDetailsContainer(widget.medInfo),
        ),
      ),
    );
  }
}

class _ReminderDetailsContainer extends StatefulWidget {
  final Medicine medInfo;

  _ReminderDetailsContainer(this.medInfo);

  @override
  _ReminderDetailsContainerState createState() =>
      _ReminderDetailsContainerState();
}

class _ReminderDetailsContainerState extends State<_ReminderDetailsContainer> {
  SQLHelper _sqlHelper = SQLHelper();
  // DateTime startDate = DateTime.now();
  // DateTime endDate = DateTime.now();
  bool beforeNow = true;

  @override
  void initState() {
    /*
    initialDate: medInfo.endDate,
    firstDate: medInfo.startDate.add(Duration(days: 1)),
    */
    setState(() {
    widget.medInfo.startDate = DateTime.parse(DateTime.now().toIso8601String().substring(0,10));
    widget.medInfo.endDate = widget.medInfo.startDate.add(Duration(days: 1, hours: 1));
    // print(widget.medInfo.startDate.add(Duration(days: 1)));
    // print(widget.medInfo.endDate);
    widget.medInfo.startTime = DateTime.now();

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // localizationsDelegates: [
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        // ],
        supportedLocales: [
          const Locale('en', 'US'),
        ],
        home: Scaffold(
            // backgroundColor: Theme
            //     .of(context)
            //     .accentColor,
            body: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: Colors.white,
                ),
                height: double.infinity,
                width: double.infinity,
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
                        child: new Icon(Icons.date_range),
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: PanelTitle(
                          title: "Pick up end date",
                          isRequired: false,
                        ),
                      ),
                      Text(
                        DateFormat.yMMMd().format(widget.medInfo.endDate),
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
                                widget.medInfo.endDate = dateTime;
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
                      TimePickerSpinner(
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
                            widget.medInfo.startTime = time.subtract(Duration(minutes: 1));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        elevation: 10,
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 130,
                        ),
                        textColor: Colors.white,
                        color: Theme
                            .of(context)
                            .accentColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        onPressed: () async {
                          try {
                            if (isSameDay(widget.medInfo.startDate, widget.medInfo.startTime)) {
                              print(widget.medInfo.startTime);
                              print(DateTime.now());
                              if(widget.medInfo.startTime.difference(
                                  DateTime.now()
                              ).inSeconds < 0) {
                                throw 'Choose time after now';
                              }
                            }
                            if (!await _sqlHelper.insertMedicine(widget.medInfo)) {
                              print('Med Not Inserted');
                              return;
                            }
                            await Alarm.setAlarm(await _sqlHelper.getMedicine(widget.medInfo.medName));
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
                    ],
                  ),
                ),
            ),
        ),
    );
  }
}
