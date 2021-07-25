import 'package:flutter/material.dart';
class Pressure{
  final DateTime day ;
  final int topNumber ;
  final int bottomNumber ;

  Pressure( {
    @required this.day,
     this.topNumber,
    this.bottomNumber,
  });
  @override
  String toString() {
    return '{ ${this.day}, ${this.topNumber} ,${this.bottomNumber} }';
  }
}