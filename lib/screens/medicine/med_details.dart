import 'package:flutter/material.dart';

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
        /*title: Text(
            "Add New Medicine",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),*/
        elevation: 0.0,
      ),
      body: Container(
        // padding: EdgeInsets.all(10),
        color: Theme.of(context).accentColor,
        child: Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).accentColor,

              // height: 200,
              child: Padding(
                padding: EdgeInsets.only(
                    //bottom: 10,
                    //top: 10,
                    ),
                child: Text(
                  "Medicine Details",
                  style: TextStyle(
                    fontFamily: "Angel",
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: _BottomContainer(),
            ),
          ],
        ),
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
  int dropDownValueDoses = 6;
  var doses = [6, 8, 12, 24];
  var items = ['Pill', 'Solution', 'Injection', 'Drops', 'Powder', 'other'];

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 800,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          color: Colors.white,
        ),
        width: double.infinity,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PanelTitle(
                    title: "Medicine Name",
                    isRequired: true,
                  ),
                  TextFormField(
                    maxLength: 1,
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
                    title:
                        "Dose (The amount of medicine in one dose)",
                    isRequired: true,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    maxLength: 1,
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
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: isRequired ? " *" : "",
            style: TextStyle(fontSize: 14, color: Colors.red),
          ),
        ]),
      ),
    );
  }
}
