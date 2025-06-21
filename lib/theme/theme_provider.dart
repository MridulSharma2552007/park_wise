import 'package:flutter/material.dart';
import 'package:park_wise/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = darkMode;
  ThemeData get themeData => _themeData;
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggletheme() {
    if (_themeData == darkMode) {
      themeData = lightMode;
    } else
       {
        themeData = darkMode;
       }
  }
}
