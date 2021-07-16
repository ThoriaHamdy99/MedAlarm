import 'package:med_alarm/models/medicine.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart'as charts;

class MedChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;
  
  MedChart(this.seriesList, {this.animate});
  factory MedChart.withSampleData() {
    return new MedChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }
  double fun (){
    final num1= seriesList[0].data.fold(0, (t, e) =>( t as int) + e.numOfMed);
    final num2= seriesList[1].data.fold(0, (t, e) =>( t as int) + e.numOfMed);
    final num3= seriesList[2].data.fold(0, (t, e) =>( t as int) + e.numOfMed);
    final totals = num1+ num2+ num3 ;


    final double percentage = double.parse(((num1 /totals )*100).toStringAsFixed(2));

    return percentage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      height: 400,
      child:Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),

           child:Column(
             children: [
               Text("The Regularity of Patient percentage is ${fun()}%" , style: TextStyle(fontSize: 25),),
             Expanded(
               child: new charts.BarChart(
                seriesList,
                animate: animate,

                domainAxis: new charts.OrdinalAxisSpec(
                  renderSpec: charts.SmallTickRendererSpec(
                    labelRotation: 45,
                    

                  ),
                ),
                primaryMeasureAxis:charts.NumericAxisSpec(

                  showAxisLine: true,
                ) ,


                // Configure a stroke width to enable borders on the bars.
                defaultRenderer: new charts.BarRendererConfig(
                    groupingType: charts.BarGroupingType.grouped, strokeWidthPx: 2.0),
                behaviors: [
                  charts.SeriesLegend(
                    position: charts.BehaviorPosition.top,
                    horizontalFirst: true,
                    cellPadding: new EdgeInsets.only(top: 4.0,right: 15.0, ),
                  )
                ],
          ),

             ),
             ],
           ),
        ),
      ),
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<Medicine, String>> _createSampleData() {

    final onTimeTreatment = [
      new Medicine(day: DateTime.parse('2020-01-02'), numOfMed: 5),
      new Medicine(day: DateTime.parse('2020-01-03'), numOfMed: 4),
      new Medicine(day: DateTime.parse('2020-01-04'), numOfMed: 3),
      new Medicine(day: DateTime.parse('2020-01-05'), numOfMed: 5),
      new Medicine(day: DateTime.parse('2020-01-06'), numOfMed: 6),
      new Medicine(day: DateTime.parse('2020-01-07'), numOfMed: 2),
      new Medicine(day: DateTime.parse('2020-01-08'), numOfMed: 4),

    ];

    final delayedTreatment = [
      new Medicine(day: DateTime.parse('2020-01-02'), numOfMed: 2),
      new Medicine(day: DateTime.parse('2020-01-03'), numOfMed: 4),
      new Medicine(day: DateTime.parse('2020-01-04'), numOfMed: 3),
      new Medicine(day: DateTime.parse('2020-01-05'), numOfMed: 1),
      new Medicine(day: DateTime.parse('2020-01-06'), numOfMed: 1),
      new Medicine(day: DateTime.parse('2020-01-07'), numOfMed: 5),
      new Medicine(day: DateTime.parse('2020-01-08'), numOfMed: 3),

    ];

    final missedTreatment = [
      new Medicine(day: DateTime.parse('2020-01-02'), numOfMed: 1),
      new Medicine(day: DateTime.parse('2020-01-03'), numOfMed: 0),
      new Medicine(day: DateTime.parse('2020-01-04'), numOfMed: 2),
      new Medicine(day: DateTime.parse('2020-01-05'), numOfMed: 2),
      new Medicine(day: DateTime.parse('2020-01-06'), numOfMed: 1),
      new Medicine(day: DateTime.parse('2020-01-07'), numOfMed: 1),
      new Medicine(day: DateTime.parse('2020-01-08'), numOfMed: 1),

    ];

    return [
      // Blue bars with a lighter center color.
      new charts.Series<Medicine, String>(
        id: 'Taken',

        domainFn: (Medicine med, _) => DateFormat.yMMMd().format(med.day).toString(),
        measureFn: (Medicine med, _) => med.numOfMed,
        data: onTimeTreatment,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        fillColorFn: (_, __) =>
        charts.MaterialPalette.green.shadeDefault.darker,
      ),
      // Solid red bars. Fill color will default to the series color if no
      // fillColorFn is configured.
      new charts.Series<Medicine, String>(
        id: 'Delayed',
        measureFn: (Medicine med, _) => med.numOfMed,
        data: delayedTreatment,
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (Medicine med, _) => DateFormat.yMMMd().format(med.day).toString(),
      ),
      // Hollow green bars.
      new charts.Series<Medicine, String>(
        id: 'Missed',
        domainFn: (Medicine med, _) => DateFormat.yMMMd().format(med.day).toString(),
        measureFn: (Medicine med, _) => med.numOfMed,
        data: missedTreatment,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      ),
    ];
  }
}
