import 'dart:io';

import 'package:flutter/material.dart';

class HomeScreenController extends ChangeNotifier {
  File? image;
  int selectedScreen = 0;
  int selectedSubView = 0;

  switchScreen(int newScreen) {
    selectedScreen = newScreen;
    notifyListeners();
  }

  toPageTwo() {
    selectedSubView = 1;
    notifyListeners();
  }

  toPageOne() {
    selectedSubView = 0;
    notifyListeners();
  }

  postWrapUp() {
    image = null;
    selectedSubView = 0;
    selectedScreen = 0;
    notifyListeners();
  }
}
