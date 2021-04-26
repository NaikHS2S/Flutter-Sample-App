import 'package:flutter/material.dart';

class ModelClass extends ChangeNotifier {

  int counter = 0;

  void increment() {
    counter++;
    notifyListeners();
  }
  
}