import 'package:flutter/material.dart';

class CounterModel extends ChangeNotifier {
  int counter = 0;
  void increment() {
    counter++;
    notifyListeners();
  }
}


