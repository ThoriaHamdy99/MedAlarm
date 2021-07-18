import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:med_alarm/models/medicine2.dart';

class SelectedMed extends StatefulWidget {
  Medicine med;
  SelectedMed(this.med);

  @override
  _SelectedMedState createState() => _SelectedMedState(med);
}

class _SelectedMedState extends State<SelectedMed> {
  Medicine med;
  var isSwitched = true;

  DateTime _dateTime;

  var numOfTake = 1;

  var values = [1, 2, 3, 4];
  _SelectedMedState(this.med);
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
                padding: EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
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
                          initialValue: "medName",
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
                padding: EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
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
                                      title: Text("When do you need to take this medicine?"),
                                      content: Column(
                                        children: [
                                          Expanded(
                                            child: TimePickerSpinner(
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
                                          ),
                                          Text("How much/many do you take?",
                                            style: TextStyle(
                                              color: Theme.of(context).accentColor,
                                              fontSize: 20,

                                            ),
                                          ),
                                          new DropdownButton(
                                            value: numOfTake,
                                            icon: Icon(Icons.keyboard_arrow_down),
                                            items: values.map((int item) {
                                              return DropdownMenuItem(
                                                  value: item, child: Text(item.toString()));
                                            }).toList(),
                                            onChanged: (var newValue) {
                                              if (newValue != null) {
                                                setState(() {
                                                  numOfTake = newValue;
                                                });
                                              }
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
                                            onPressed: (){},
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
                                  child: Text("08:00 AM",
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Theme.of(context).accentColor,
                                    ),),
                                ),
                                Text("Take 1 pill(s)",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ],
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
