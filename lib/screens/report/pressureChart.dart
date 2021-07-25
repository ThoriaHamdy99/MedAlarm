
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_alarm/screens/report/pressuer.dart';

class PointsLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  PointsLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory PointsLineChart.withSampleData() {
    return new PointsLineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      height: 400,
      child:Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),

          child:Column(
            children: [
              Text("Blood pressure" , style: TextStyle(fontSize: 25),),
              Expanded(
                child: new charts.TimeSeriesChart(seriesList,
                    animate: animate,
                  domainAxis: new charts.DateTimeAxisSpec(
                    tickProviderSpec: charts.DayTickProviderSpec(increments: [1]),
                    renderSpec: charts.SmallTickRendererSpec(
                        labelRotation: 45,
                    ),
                      tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                      day: new charts.TimeFormatterSpec(
                          format: 'yMMMd', transitionFormat: 'yMMMd', noonFormat: 'yMMMd'),
                    ),
                    showAxisLine: false,
                  ),
                  primaryMeasureAxis: new charts.NumericAxisSpec(
                      tickProviderSpec:
                  new charts.BasicNumericTickProviderSpec(desiredTickCount: 5)),
                    defaultRenderer: new charts.LineRendererConfig(includePoints: true, stacked: false),
                  behaviors: [
                    charts.SeriesLegend(
                      position: charts.BehaviorPosition.top,
                      horizontalFirst: true,
                      cellPadding: new EdgeInsets.only(top: 4.0,right: 30, ),
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

  /// Create one series with sample hard coded data.
  static List<charts.Series<Pressure, DateTime>> _createSampleData() {
    final systolic = [
      new Pressure(day: DateTime.parse('2020-01-02'), topNumber: 120),
      new Pressure(day: DateTime.parse('2020-01-03'), topNumber: 130),
      new Pressure(day: DateTime.parse('2020-01-04'), topNumber: 115),
      new Pressure(day: DateTime.parse('2020-01-05'),topNumber: 140),
      new Pressure(day: DateTime.parse('2020-01-06'), topNumber: 150),
      new Pressure(day: DateTime.parse('2020-01-07'),topNumber: 135),
      new Pressure(day: DateTime.parse('2020-01-08'), topNumber: 125),

    ];

    final diastolic = [
      new Pressure(day: DateTime.parse('2020-01-02'), bottomNumber: 60),
      new Pressure(day: DateTime.parse('2020-01-03'), bottomNumber: 80),
      new Pressure(day: DateTime.parse('2020-01-04'), bottomNumber: 75),
      new Pressure(day: DateTime.parse('2020-01-05'), bottomNumber: 65),
      new Pressure(day: DateTime.parse('2020-01-06'), bottomNumber: 55),
      new Pressure(day: DateTime.parse('2020-01-07'), bottomNumber: 80),
      new Pressure(day: DateTime.parse('2020-01-08'), bottomNumber: 75),

    ];
    return [
      new charts.Series<Pressure, DateTime>(
        id: 'Systolic',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Pressure press, _) =>press.day ,
        measureFn: (Pressure press, _) => press.topNumber,
        data: systolic,
      ),
      new charts.Series<Pressure, DateTime>(
        id: 'Diastolic',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (Pressure press, _) =>  press.day,
        measureFn: (Pressure press, _) => press.bottomNumber,
        data: diastolic,
      )
    ];
  }
}