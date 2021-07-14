import 'package:charts_flutter/flutter.dart'as charts;
import 'package:flutter/material.dart';
class Medicine{
  final DateTime day ;
  final int numOfMed ;
  final charts.Color barColor;

  Medicine({
    @required this.day,
    @required this.numOfMed,
    @required this.barColor,
  });
  @override
  String toString() {
    return '{ ${this.day}, ${this.numOfMed} }';
  }

}