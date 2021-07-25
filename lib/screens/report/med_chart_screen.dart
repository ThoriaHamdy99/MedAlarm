import 'dart:collection';

import 'package:med_alarm/models/dose.dart';
import 'package:med_alarm/models/medicine2.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:med_alarm/utilities/sql_helper.dart';

class MedChart extends StatelessWidget {
  List<List<charts.Series<Medicine, String>>> seriesList = [];
  bool animate;
  SQLHelper _sqlHelper = SQLHelper();

  Future<List<List<charts.Series<Medicine, String>>>> withSampleData()async {
    return allMedChart();
  }

  Future<Map<String, List<Medicine>>> draw(int id) async {
    List<Dose> dose = [];
    List<Medicine> taken = [];
    List<Medicine> snoozed = [];
    List<Medicine> canceled = [];
    LinkedHashMap<DateTime, List<Dose>> map;
      map = await _sqlHelper.getLastWeekDoses(id);
      print('/////////////////////////////////////////////////////');
      print(id);
      map.forEach((key, value) {
        print(key);
        int numOfTaken = 0;
        int numOfSnoozed = 0;
        int numOfCanceled = 0;
        for (Dose d in value) {
          if (d.snoozed) {
            numOfSnoozed += 1;
          }
          if (d.taken) {
            numOfTaken += 1;
          } else {
            numOfCanceled += 1;
          }
        }
        DateTime time = key;
        taken.add(new Medicine(startDate: time, doseAmount: numOfTaken));
        snoozed.add(new Medicine(startDate: time, doseAmount: numOfSnoozed));
        canceled.add(new Medicine(startDate: time, doseAmount: numOfCanceled));
      }
      );
    print(taken);
    print(snoozed);
    print(canceled);
    print('__________________________________________________________');
    return {
      'taken': taken,
      'snoozed': snoozed,
      'canceled': canceled,
    };
    // if(returned==1) return taken;
    // else if (returned == 2){
    //   return snoozed;
    // }
    // else if(returned == 0) return canceled;
  }

  // double fun() {
  //   final num1 = seriesList[0].data.fold(0, (t, e) => (t as int) + e.numOfMed);
  //   final num2 = seriesList[1].data.fold(0, (t, e) => (t as int) + e.numOfMed);
  //   final num3 = seriesList[2].data.fold(0, (t, e) => (t as int) + e.numOfMed);
  //   final totals = num1 + num2 + num3;
  //
  //   final double percentage =
  //       double.parse(((num1 / totals) * 100).toStringAsFixed(2));
  //
  //   return percentage;
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: withSampleData(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) => Container(
                  padding: EdgeInsets.all(20.0),
                  height: 400,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "The Regularity of Patient percentage is {fun()}%",
                            style: TextStyle(fontSize: 25),
                          ),
                          Expanded(
                            child: new charts.BarChart(
                              snapshot.data[index],
                              animate: animate,

                              domainAxis: new charts.OrdinalAxisSpec(
                                renderSpec: charts.SmallTickRendererSpec(
                                  labelRotation: 45,
                                ),
                              ),
                              primaryMeasureAxis: charts.NumericAxisSpec(
                                showAxisLine: true,
                              ),

                              // Configure a stroke width to enable borders on the bars.
                              defaultRenderer: new charts.BarRendererConfig(
                                  groupingType: charts.BarGroupingType.grouped,
                                  strokeWidthPx: 2.0),
                              behaviors: [
                                charts.SeriesLegend(
                                  position: charts.BehaviorPosition.top,
                                  horizontalFirst: true,
                                  cellPadding: new EdgeInsets.only(
                                    top: 4.0,
                                    right: 15.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

            );
          } else return Text('No Charts');
        }
        return CircularProgressIndicator();
      }
    );
  }

  /// Create series list with multiple series
  Future<List<List<charts.Series<Medicine, String>>>> allMedChart() async {
    List<Medicine> medicines = [];
    medicines = await _sqlHelper.getAllMedicines();
    for(Medicine med in medicines){
      seriesList.add(await _createSampleData(med.id));
    }
    return seriesList;
  }

Future<List<charts.Series<Medicine, String>>> _createSampleData(int id) async {
  Map result = await draw(id);
  final onTimeTreatment = result['taken'];

  final delayedTreatment = result['snoozed'];

  final missedTreatment = result['canceled'];

  return [
    // Blue bars with a lighter center color.
    new charts.Series<Medicine, String>(
      id: 'Taken',
      domainFn: (Medicine med, _) => DateFormat.yMMMd().format(med.startDate).toString(),
      measureFn: (Medicine med, _) =>med.doseAmount ,
      data: onTimeTreatment,
      colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
      fillColorFn: (_, __) =>
      charts.MaterialPalette.green.shadeDefault.darker,
    ),
    // Solid red bars. Fill color will default to the series color if no
    // fillColorFn is configured.
    new charts.Series<Medicine, String>(
      id: 'Delayed',
      measureFn: (Medicine med, _) => med.doseAmount,
      data: delayedTreatment,
      colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
      domainFn: (Medicine med, _) => DateFormat.yMMMd().format(med.startDate).toString(),
    ),
    // Hollow green bars.
    new charts.Series<Medicine, String>(
      id: 'Missed',
      domainFn: (Medicine med, _) => DateFormat.yMMMd().format(med.startDate).toString(),
      measureFn: (Medicine med, _) => med.doseAmount,
      data: missedTreatment,
      colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      fillColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
    ),
  ];
}
}
