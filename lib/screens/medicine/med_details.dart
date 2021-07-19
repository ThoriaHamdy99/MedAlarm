import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:med_alarm/models/medicine2.dart';
import 'package:med_alarm/screens/home_screen.dart';
import 'package:med_alarm/utilities/sql_helper.dart';
import 'package:validators/validators.dart';

Medicine medInfo = new Medicine();
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
        backgroundColor: Theme
            .of(context)
            .accentColor,
        iconTheme: IconThemeData(
          color: Color(0xFFF8F4F4),
        ),
        centerTitle: true,
        title: Text(
          "Medicine Details",
          style: TextStyle(
            fontFamily: "Angel",
            fontSize: 32,
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        color: Theme
            .of(context)
            .accentColor,
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
  String dropDownValue = 'Pill';
  String durationValue = 'daily';
  int dropDownValueDoses = 6;
  var doses = [6, 8, 12, 24];
  var items = ['Pill', 'Solution', 'Injection', 'Drops', 'Powder', 'other'];
  var durationItems = ['daily', 'weekly', 'monthly'];
  bool isDaily = true;

  @override
  void initState() {
    medInfo.medType = dropDownValue;
    medInfo.interval = durationValue;
    medInfo.intervalTime = dropDownValueDoses;
    medInfo.numOfDoses = (24 / dropDownValueDoses).round();
    medInfo.doseAmount = 2;
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
            builder: (context) => MedReminderDetails(),
          ),
        );
      } else {
        print('form is invalid');
      }
    }
    return Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          color: Colors.white,
        ),
        width: double.infinity,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
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
                      title: "amount of medicine",
                      isRequired: true,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (!isNumeric(value))
                          return "please enter amount of medicine as a number!!";
                        else if (value.isEmpty)
                          return "please enter amount of medicine!!";
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
                        labelText: 'Enter number',
                      ),
                    ),

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
                            if (durationValue != "daily") isDaily = false;
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
                            title: "hours between each dose",
                            isRequired: true,
                          ),
                          new DropdownButton(
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
                              medInfo.numOfDoses = (24 / dropDownValueDoses).round();
                            },
                          ),
                        ],
                      ),
                    ),

                    RaisedButton(
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
                  ],
                ),
              ),
            )));
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
  @override
  _MedReminderDetailsState createState() => _MedReminderDetailsState();
}

class _MedReminderDetailsState extends State<MedReminderDetails> {
 // String medname = medNameController.text;

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
        centerTitle: true,
        title: Text(
          "Medicine Details",
          style: TextStyle(
            fontFamily: "Angel",
            fontSize: 32,
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        color: Theme
            .of(context)
            .accentColor,
        child: Container(
          child: _ReminderDetailsContainer(),
        ),
      ),
    );
  }
}

class _ReminderDetailsContainer extends StatefulWidget {
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
    medInfo.startDate = DateTime.now();
    medInfo.endDate = DateTime.now().add(Duration(days: 1));
    medInfo.startTime = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
        ],
        home: Scaffold(
            backgroundColor: Theme
                .of(context)
                .accentColor,
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
                          isRequired: true,
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
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              setState(() {
                                medInfo.startDate = dateTime;
                                if (medInfo.startDate.toIso8601String().substring(0 ,10).compareTo(
                                    medInfo.endDate.toIso8601String().substring(0 ,10)) >= 0)
                                  medInfo.endDate = medInfo.startDate.add(Duration(days: 1));
                                if (medInfo.startDate.toIso8601String().substring(0 ,10)
                                    == DateTime.now().toIso8601String().substring(0 ,10)) {
                                  if (medInfo.startTime
                                      .difference(DateTime.now()
                                      .subtract(Duration(minutes: 1)))
                                      .inMilliseconds <= 0) {
                                    beforeNow = true;
                                  } else beforeNow = false;
                                } else beforeNow = false;
                              });
                              return available;
                            },
                          ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: PanelTitle(
                          title: "Pick up end date",
                          isRequired: true,
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
                          primary: Theme.of(context).accentColor,
                          onPrimary: Colors.white,
                        ),
                        child: new Icon(Icons.date_range),
                        onPressed: () =>
                          showRoundedDatePicker(
                            context: context,
                            theme: Theme.of(context),
                            initialDate: medInfo.endDate,
                            firstDate: medInfo.startDate.add(Duration(days: 1)),
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
                                medInfo.endDate = dateTime;
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
                          isRequired: true,
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
                          setState(() {
                            if(medInfo.startDate.difference(time).inDays == 0) {
                              time = time.subtract(Duration(minutes: 1));
                              medInfo.startDate = DateTime.now();
                              if (medInfo.startTime.difference(time)
                                  .inMilliseconds <= 0) {
                                medInfo.startTime = time;
                                beforeNow = false;
                              } else beforeNow = true;
                            }
                            else {
                              medInfo.startTime = time;
                              beforeNow = false;
                            }
                          });
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
                            if(beforeNow) throw 'Choose time after now';
                            if (!await _sqlHelper.insertMedicine(medInfo)) {
                              print('Med Not Inserted');
                              return;
                            }
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(
                                context, HomeScreen.id);
                          } catch (e) {
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
