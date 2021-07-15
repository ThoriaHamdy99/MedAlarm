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
        child: Column(
          children: [
            Container(
              color: Theme.of(context).accentColor,

              // height: 200,
              /*child:Padding(
                  padding: EdgeInsets.only(
                    bottom: 10,
                    top: 10,
                  ),
                child:SizedBox(
                  height: 50,
                ) ,
                ),*/
            ),
            Flexible(
              flex: 3,
              child: _BottomContainer(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _BottomContainer extends StatefulWidget {
  @override
  _BottomContainerState createState() => _BottomContainerState();
}

class _BottomContainerState extends State<_BottomContainer> {
  String dropDownValue = 'Pill';
  int dropDownValueDoses = 6;
  var doses = [6, 8, 12, 24];
  var items = ['Pill', 'Solution', 'Injection', 'Drops', 'Powder', 'other'];

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 800,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.elliptical(50, 27),
            topRight: Radius.elliptical(50, 27),
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
                  /* Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: StreamBuilder<MedicineType>(
              stream: _newEntryBloc.selectedMedicineType,
              builder: (context, snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MedicineTypeColumn(
                        type: MedicineType.Bottle,
                        name: "Bottle",
                        iconValue: 0xe900,
                        isSelected: snapshot.data == MedicineType.Bottle
                            ? true
                            : false),
                    MedicineTypeColumn(
                        type: MedicineType.Pill,
                        name: "Pill",
                        iconValue: 0xe901,
                        isSelected: snapshot.data == MedicineType.Pill
                            ? true
                            : false),
                    MedicineTypeColumn(
                        type: MedicineType.Syringe,
                        name: "Syringe",
                        iconValue: 0xe902,
                        isSelected: snapshot.data == MedicineType.Syringe
                            ? true
                            : false),
                    MedicineTypeColumn(
                        type: MedicineType.Tablet,
                        name: "Tablet",
                        iconValue: 0xe903,
                        isSelected: snapshot.data == MedicineType.Tablet
                            ? true
                            : false),
                  ],
                );
              },
            )),*/
                  new DropdownButton(
                    value: dropDownValue,
                    icon: Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(value: items, child: Text(items));
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
                    title: "amount of med in one dose",
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
                    title: "hours between each dose",
                    isRequired: true,
                  ),
                  new DropdownButton(
                    value: dropDownValueDoses,
                    icon: Icon(Icons.keyboard_arrow_down),
                    items: doses.map((int items) {
                      return DropdownMenuItem(
                          value: items, child: Text(items.toString()));
                    }).toList(),
                    onChanged: (var newValue) {
                      if (newValue != null) {
                        setState(() {
                          dropDownValue = newValue as String;
                        });
                      } else {}
                    },
                  ),
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
            text: isRequired ? " *" : "",
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
        child: Flexible(
          flex: 3,
          child: _ReminderDetailsContainer(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
          const Locale('en', 'US'), // English
          // const Locale('th', 'TH'), // Thai
        ],
        home: Scaffold(
            backgroundColor: Theme.of(context).accentColor,
            body: Container(
                // height: 800,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: Colors.white,
                ),
                width: double.infinity,
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
                            borderRadius: new BorderRadius.circular(60.0),
                          ),
                          primary: Theme.of(context).accentColor, // background
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
                            borderRadius: new BorderRadius.circular(60.0),
                          ),
                          primary: Theme.of(context).accentColor, // background
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
                            fontSize: 24, color: Theme.of(context).accentColor),
                        highlightedTextStyle:
                            TextStyle(fontSize: 24, color: Colors.amber),
                        spacing: 50,
                        itemHeight: 80,
                        isForce2Digits: true,
                        onTimeChange: (time) {
                          setState(() {
                            _dateTime = time;
                          });
                        },
                      )
                    ]))));
  }
}
