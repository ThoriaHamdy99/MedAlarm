import 'package:flutter/material.dart';
import 'package:med_alarm/models/medicine2.dart';
import 'package:med_alarm/screens/medicine/edit_medicine.dart';
import 'package:med_alarm/screens/medicine/medicine%20_info.dart';
import 'package:med_alarm/service/chatbot.dart';
import 'package:med_alarm/utilities/sql_helper.dart';

import 'medicine/med_details.dart';

class MedicineScreen extends StatefulWidget {
  static const id = 'EMPTY_SCREEN';

  @override
  _MedicineScreenState createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  SQLHelper _sqlHelper = SQLHelper();
  ValueNotifier<List<Medicine>> medicines = ValueNotifier([]);
  List<int> isDeleted = [];
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Medicine>>(
        future: _sqlHelper.getAllMedicines(),
        builder: (ctx, snapShot) {
          if (snapShot.hasData) {
            if (snapShot.data.isEmpty) {
              return Container(
                color: Color.fromRGBO(224, 240, 228, 0.5),
                width: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No medicine added until now",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      RaisedButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 110),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(MedDetails.id);
                        },
                        child: Text(
                          "Add Medicine",
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
              );
            }else{
              medicines.value = snapShot.data;
              return ValueListenableBuilder<List<Medicine>>(
                valueListenable: medicines,
                builder: (context, value, _) {
                  return Container(
                    width: double.infinity,
                    color: Color.fromRGBO(224, 240, 228, 0.5),
                    child: ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => MedicineInfo(value[index])
                                  ),
                                ).whenComplete(() {
                                  setState(() {

                                  });
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 8.0, left: 5.0, right: 5.0),
                                child: Card(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 12.0),
                                  elevation: 5,
                                  shadowColor: Colors.green,
                                  clipBehavior: Clip.antiAlias,
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.0, top: 10.0),
                                          child: Text(
                                            '${value[index].medName}',
                                            style: TextStyle(
                                              fontSize: 22,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                                          child: Text('take ${value[index].doseAmount} ${value[index].medType}',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
