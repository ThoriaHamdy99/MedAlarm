import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  static const id = 'EMPTY_SCREEN';
  const EmptyScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text('Empty'),
    );
  }
}
