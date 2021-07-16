import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

TextEditingController medNameController = new TextEditingController();

class MedDetails extends StatefulWidget {
  static const id = 'MED_DETAILS_SCREEN';

  @override
  _MedDetailsState createState() => _MedDetailsState();
}

class _MedDetailsState extends State<MedDetails> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
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
        color: Theme.of(context).accentColor,
        child: _BottomContainer(),
      ),
      /*floatingActionButton: FloatingActionButton.extended(
        elevation: 10,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).accentColor,
        label: Row(
          children: <Widget>[
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MedReminderDetails(),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,*/
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
  var durationItems = ['daily', 'weakly', 'monthly'];
  bool isDaily = false;

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PanelTitle(
                    title: "Medicine Name",
                    isRequired: true,
                  ),
                  TextFormField(
                    controller: medNameController,
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
                      } else {}
                    },
                  ),
                  PanelTitle(
                    title: "amount of med",
                    isRequired: true,
                  ),
                  TextFormField(
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
                          if(durationValue == "daily") isDaily = true;
                        });
                      } else {}
                    },
                  ),

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
                      if (newValue != null) {
                        setState(() {
                          dropDownValueDoses = newValue;
                        });
                      } else {}
                    },
                  ),
                  RaisedButton(
                    elevation: 10,
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 25,
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedReminderDetails(),
                        ),
                      );
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
                  /*TextFormField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter number',
                    ),
                  ),*/
                ],
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
  String medname = medNameController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: IconThemeData(
          color: Color(0xFFF8F4F4),
        ),
        centerTitle: true,
        title: Text(
          "$medname Details",
          style: TextStyle(
            fontFamily: "Angel",
            fontSize: 32,
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        color: Theme.of(context).accentColor,
        child: Container(
          child: _ReminderDetailsContainer(),
        ),
      ),
      /*floatingActionButton: FloatingActionButton.extended(
        elevation: 10,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).accentColor,
        label: Text(
          " Done ",
          style: TextStyle(
            fontFamily: "Angel",
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MedReminderDetails(),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,*/
    );
  }
}

class _ReminderDetailsContainer extends StatefulWidget {
  @override
  _ReminderDetailsContainerState createState() =>
      _ReminderDetailsContainerState();
}

class _ReminderDetailsContainerState extends State<_ReminderDetailsContainer> {
  var _dateTime;

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
            backgroundColor: Theme.of(context).accentColor,
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: PanelTitle(
                              title: "Pick up Start date",
                              isRequired: true,
                            )),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(50.0),
                            ),
                            primary:
                                Theme.of(context).accentColor, // background
                            onPrimary: Colors.amber, // foreground
                          ),
                          child: new Icon(Icons.date_range),
                          onPressed: () => showRoundedDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year),
                            lastDate: DateTime(DateTime.now().year + 2),
                            borderRadius: 16,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: PanelTitle(
                              title: "Pick up end date",
                              isRequired: true,
                            )),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(50.0),
                            ),
                            primary:
                                Theme.of(context).accentColor, // background
                            onPrimary: Colors.amber, // foreground
                          ),
                          child: new Icon(Icons.date_range),
                          onPressed: () => showRoundedDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year),
                            lastDate: DateTime(DateTime.now().year + 2),
                            borderRadius: 16,
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
                              fontSize: 24,
                              color: Theme.of(context).accentColor),
                          highlightedTextStyle:
                              TextStyle(fontSize: 24, color: Colors.amber),
                          spacing: 45,
                          itemHeight: 40,
                          isForce2Digits: true,
                          onTimeChange: (time) {
                            setState(() {
                              _dateTime = time;
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
                            horizontal: 25,
                          ),
                          textColor: Colors.white,
                          color: Theme.of(context).accentColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedReminderDetails(),
                              ),
                            );
                          },
                          child: Text(
                            " Done ",
                            style: TextStyle(
                              fontFamily: "Angel",
                              fontSize: 28,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                ))));
  }
}
